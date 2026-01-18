import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';
import 'package:gizi_sehat_mobile_app/features/auth/state/auth_provider.dart';
import 'package:gizi_sehat_mobile_app/app_router.dart';
import 'package:gizi_sehat_mobile_app/widgets/status_badge.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/data/models/child_model.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/data/services/child_service.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/presentation/widgets/indonesian_location_selector.dart';
import 'package:gizi_sehat_mobile_app/core/services/cloudinary_service.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/presentation/widgets/child_dialogs.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // We only need AuthProvider here for user details & logout
    final auth = context.watch<AuthProvider>();
    final user = auth.userModel;
    final userEmail = auth.currentEmail ?? '-';
    // Use data provided name or update locally if null
    final userName = user?.name ?? 'Orang Tua';
    final userPhoto = user?.profileImage;

    // Force light theme usage for consistent look as requested (dark mode removed)
    const headingColor = AppColors.lightTextPrimary;
    const subtitleColor = AppColors.lightTextSecondary;
    const sectionBg = Colors.white;
    const borderColor = AppColors.lightBorder;
    const innerCardBg = Color(0xFFF9F9F9);
    final avatarBg = AppColors.accent.withOpacity(0.15);

    // Services
    final childService = ChildService();
    // Get current user ID
    final uid = user?.id;

    // --- Actions ---

    Future<void> handleLogout() async {
      await context.read<AuthProvider>().logout();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRouter.login,
          (route) => false,
        );
      }
    }

    void showEditProfileDialog() {
      if (uid == null) return;
      showDialog(
        context: context,
        builder: (context) => _EditProfileDialog(
          initialName: userName,
          initialPhotoUrl: userPhoto,
          initialProvince: user?.province,
          initialCity: user?.city,
          initialDistrict: user?.district,
          uid: uid,
        ),
      );
    }

    void showAddChildDialog() {
      if (uid == null) return;
      showDialog(
        context: context,
        builder: (context) => AddEditChildDialog(userId: uid),
      );
    }

    void showEditChildDialog(ChildModel child) {
      if (uid == null) return;
      showDialog(
        context: context,
        builder: (context) => AddEditChildDialog(userId: uid, child: child),
      );
    }

    // --- Widgets ---

    Widget childTile(ChildModel child) {
      return Container(
        decoration: BoxDecoration(
          color: innerCardBg,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Child Avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: child.gender == 'Perempuan'
                    ? AppColors.femalePink.withOpacity(0.2)
                    : Colors.blue.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.face, // Improved icon
                color: child.gender == 'Perempuan'
                    ? AppColors.femalePink
                    : Colors.blue,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // Child Information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          child.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: headingColor,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          StatusBadge(
                            label: child.status,
                            isWarning: child.status != 'Normal',
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => showEditChildDialog(child),
                            child: Icon(
                              Icons.edit_outlined,
                              size: 18,
                              color: headingColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${child.gender} • ${child.ageString}',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget sectionCard({required Widget child}) {
      return Container(
        decoration: BoxDecoration(
          color: sectionBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 24),
        child: child,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC), // Consistent background
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF7F9FC),
        foregroundColor: headingColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ===== HEADER PROFILE =====
              GestureDetector(
                onTap: showEditProfileDialog,
                child: Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: avatarBg,
                        shape: BoxShape.circle,
                        image: userPhoto != null
                            ? DecorationImage(
                                image: CachedNetworkImageProvider(userPhoto),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: userPhoto == null
                          ? const Icon(
                              Icons.person,
                              color: AppColors.accent,
                              size: 40,
                            )
                          : null,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                userName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: headingColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userEmail,
                style: TextStyle(fontSize: 14, color: subtitleColor),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: showEditProfileDialog,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit_outlined, size: 16, color: headingColor),
                    const SizedBox(width: 6),
                    Text(
                      'Edit Profil',
                      style: TextStyle(
                        fontSize: 14,
                        color: headingColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ===== KELOLA ANAK (REALTIME DATA) =====
              if (uid != null)
                sectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.tag_faces_outlined,
                            color: headingColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Kelola Anak',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: headingColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // StreamBuilder for Realtime Updates
                      StreamBuilder<List<ChildModel>>(
                        stream: childService.getChildrenStream(uid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          final children = snapshot.data ?? [];
                          if (children.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                child: Text(
                                  'Belum ada data anak.\nSilakan tambah data anak.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: subtitleColor),
                                ),
                              ),
                            );
                          }
                          return Column(
                            children: children
                                .map((child) => childTile(child))
                                .toList(),
                          );
                        },
                      ),

                      const SizedBox(height: 8),
                      // Add Child Button
                      GestureDetector(
                        onTap: showAddChildDialog,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor, width: 1),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, size: 18, color: headingColor),
                              const SizedBox(width: 8),
                              Text(
                                'Tambah Anak',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: headingColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // ===== Logout Button =====
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: sectionBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: handleLogout,
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        'Keluar Akun',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Anda akan keluar dari aplikasi ini',
                      style: TextStyle(fontSize: 13, color: subtitleColor),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Dialogs ---

class _EditProfileDialog extends StatefulWidget {
  final String initialName;
  final String? initialPhotoUrl;
  final String uid;
  final String? initialProvince;
  final String? initialCity;
  final String? initialDistrict;

  const _EditProfileDialog({
    required this.initialName,
    this.initialPhotoUrl,
    this.initialProvince,
    this.initialCity,
    this.initialDistrict,
    required this.uid,
  });

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  late TextEditingController _nameController;
  File? _imageFile;
  bool _isLoading = false;

  // Location State
  String? _selectedProvince;
  String? _selectedCity;
  String? _selectedDistrict;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _selectedProvince = widget.initialProvince;
    _selectedCity = widget.initialCity;
    _selectedDistrict = widget.initialDistrict;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);

    String? photoUrl;
    String? uploadError; // To capture upload error but not stop execution

    // 1. Upload Image to Cloudinary (Unsigned)
    if (_imageFile != null) {
      try {
        final cloudinaryService = CloudinaryService();
        photoUrl = await cloudinaryService.uploadImage(_imageFile!);
      } catch (e) {
        uploadError = 'Gagal upload foto: $e';
        debugPrint('Cloudinary upload failed: $e');
        // We continue execution to save other data
      }
    }

    // 2. Save Profile Data (Firestore)
    try {
      if (mounted) {
        await context.read<AuthProvider>().updateProfile(
          name: _nameController.text.trim(),
          photoUrl: photoUrl, // Will be null if upload failed or no new image
          province: _selectedProvince,
          city: _selectedCity,
          district: _selectedDistrict,
        );

        if (mounted) {
          Navigator.pop(context);

          // Show feedback
          if (uploadError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(uploadError), // Show exact error
                backgroundColor: Colors.orange,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profil berhasil diperbarui')),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error saving profile data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui data profil: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profil'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!)
                    : (widget.initialPhotoUrl != null
                              ? NetworkImage(widget.initialPhotoUrl!)
                              : null)
                          as ImageProvider?,
                child: (_imageFile == null && widget.initialPhotoUrl == null)
                    ? const Icon(Icons.camera_alt, size: 30, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ketuk untuk ganti foto',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Location Selector
            IndonesianLocationSelector(
              onLocationSelected: (prov, city, district) {
                setState(() {
                  _selectedProvince = prov;
                  _selectedCity = city;
                  _selectedDistrict = district;
                });
              },
              // Optional: pass initial values if you had them in user model
              initialProvince: widget.initialProvince,
              initialCity: widget.initialCity,
              initialDistrict: widget.initialDistrict,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveProfile,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Simpan'),
        ),
      ],
    );
  }
}
