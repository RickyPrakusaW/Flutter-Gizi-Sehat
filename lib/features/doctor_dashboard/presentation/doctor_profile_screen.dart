import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gizi_sehat_mobile_app/features/auth/state/auth_provider.dart';
import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';
import 'package:gizi_sehat_mobile_app/core/services/cloudinary_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _titleController;
  late TextEditingController _specialistController;
  late TextEditingController _strController;
  late TextEditingController _sipController;
  late TextEditingController _practiceLocationController;
  late TextEditingController _alumniController;
  late TextEditingController _experienceController;
  late TextEditingController _priceController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().userModel;
    _nameController = TextEditingController(text: user?.name ?? '');
    _titleController = TextEditingController(text: user?.title ?? '');
    _specialistController = TextEditingController(text: user?.specialist ?? '');
    _strController = TextEditingController(text: user?.strNumber ?? '');
    _sipController = TextEditingController(text: user?.sipNumber ?? '');
    _practiceLocationController =
        TextEditingController(text: user?.practiceLocation ?? '');
    _alumniController = TextEditingController(text: user?.alumni ?? '');
    _experienceController =
        TextEditingController(text: user?.experienceYear?.toString() ?? '');
    _priceController = TextEditingController();

    if (user != null) {
      _fetchDoctorData(user.id);
    }
  }

  Future<void> _fetchDoctorData(String uid) async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection('doctors').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        if (data['price'] != null) {
          _priceController.text = data['price'].toString();
        }
      }
    } catch (e) {
      debugPrint("Error fetching doctor data: $e");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _specialistController.dispose();
    _strController.dispose();
    _sipController.dispose();
    _practiceLocationController.dispose();
    _alumniController.dispose();
    _experienceController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final user = authProvider.userModel;

      if (user != null) {
        final data = {
          'name': _nameController.text.trim(),
          'title': _titleController.text.trim(),
          'specialist': _specialistController.text.trim(),
          'str_number': _strController.text.trim(),
          'sip_number': _sipController.text.trim(),
          'practice_location': _practiceLocationController.text.trim(),
          'alumni': _alumniController.text.trim(),
          'experience_year':
              int.tryParse(_experienceController.text.trim()) ?? 0,
          'price': _priceController.text.trim(), // Save price
        };

        // Update Firestore Users
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .update(data);

        // Update Firestore Doctors (Sync)
        await FirebaseFirestore.instance
            .collection('doctors')
            .doc(user.id)
            .set(data, SetOptions(merge: true));

        // Listener in AuthProvider will automatically update the UI

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil berhasil diperbaharui')),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memperbarui profil: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _changeProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() => _isLoading = true);

    try {
      final File imageFile = File(pickedFile.path);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mengupload foto...')),
      );

      // Upload to Cloudinary
      final cloudinaryService = CloudinaryService();
      final String? imageUrl = await cloudinaryService.uploadImage(imageFile);

      if (imageUrl != null) {
        final authProvider = context.read<AuthProvider>();
        final user = authProvider.userModel;

        if (user != null) {
          // Update Firestore
          final updateData = {'profile_image': imageUrl};

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.id)
              .update(updateData);

          await FirebaseFirestore.instance
              .collection('doctors')
              .doc(user.id)
              .set(updateData, SetOptions(merge: true));

          // The AuthProvider stream listener handles the UI update automatically
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Foto Profil Berhasil Diubah')),
            );
          }
        }
      }
    } catch (e) {
      debugPrint("Error changing photo: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal upload foto: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().userModel;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Profil Dokter'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Image
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                        image: user.profileImage != null
                            ? DecorationImage(
                                image: NetworkImage(user.profileImage!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: user.profileImage == null
                          ? Icon(Icons.person,
                              size: 50, color: Colors.grey.shade400)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _changeProfilePicture,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              _buildSectionTitle('Informasi Pribadi'),
              _buildTextField('Nama Lengkap', _nameController, Icons.person),
              const SizedBox(height: 16),
              _buildTextField(
                  'Gelar (Contoh: Sp.A)', _titleController, Icons.school),
              const SizedBox(height: 24),

              _buildSectionTitle('Informasi Profesional'),
              _buildTextField('Spesialisasi', _specialistController,
                  Icons.medical_services),
              const SizedBox(height: 16),
              _buildTextField('Lokasi Praktik (RS/Klinik)',
                  _practiceLocationController, Icons.local_hospital),
              const SizedBox(height: 16),
              _buildTextField(
                  'Biaya Konsultasi (Rp)', _priceController, Icons.attach_money,
                  isNumber: true),
              const SizedBox(height: 16),
              _buildTextField('Universitas Alumni', _alumniController,
                  Icons.school_outlined),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                        'No. STR', _strController, Icons.numbers),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Pengalaman (Tahun)',
                        _experienceController, Icons.history,
                        isNumber: true),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField('No. SIP', _sipController, Icons.file_present),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text('Simpan Perubahan',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D3748),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon,
      {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
    );
  }
}
