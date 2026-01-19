import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gizi_sehat_mobile_app/app_router.dart';
import 'package:provider/provider.dart';
import 'package:gizi_sehat_mobile_app/features/auth/state/auth_provider.dart';
import 'package:gizi_sehat_mobile_app/features/doctor/data/services/appointment_service.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/data/models/child_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentPatientDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;
  final String date;
  final String time;

  const AppointmentPatientDetailsScreen({
    super.key,
    required this.doctor,
    required this.date,
    required this.time,
  });

  @override
  State<AppointmentPatientDetailsScreen> createState() =>
      _AppointmentPatientDetailsScreenState();
}

class _AppointmentPatientDetailsScreenState
    extends State<AppointmentPatientDetailsScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  int _selectedProfileIndex = 0; // 0 = Me, 1+ = Children
  List<ChildModel> _children = [];
  bool _isLoadingChildren = true;

  @override
  void initState() {
    super.initState();
    _fetchChildren();
  }

  Future<void> _fetchChildren() async {
    final user = Provider.of<AuthProvider>(context, listen: false).userModel;
    if (user != null) {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .collection('children')
            .get();

        if (mounted) {
          setState(() {
            _children = snapshot.docs
                .map((doc) => ChildModel.fromMap(doc.data(), doc.id))
                .toList();
            _isLoadingChildren = false;
          });
        }
      } catch (e) {
        debugPrint("Error fetching children: $e");
        if (mounted) setState(() => _isLoadingChildren = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _isSaving = false;

  Future<void> _submitAppointment() async {
    final user = Provider.of<AuthProvider>(context, listen: false).userModel;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Silakan login terlebih dahulu.")));
      return;
    }
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Harap isi nama dan kontak pasien.")));
      return;
    }

    setState(() => _isSaving = true);

    try {
      if (widget.doctor['id'] == null) throw "ID Dokter tidak valid";

      await AppointmentService().createAppointment(
        doctorId: widget.doctor['id']!,
        parentId: user.id,
        patientName: _nameController.text,
        contactNumber: _phoneController.text,
        date: widget.date,
        time: widget.time,
        doctorName: widget.doctor['name'] ?? 'Dokter',
        doctorImage: widget.doctor['imageUrl'] ?? widget.doctor['image'] ?? '',
        doctorSpecialty: widget.doctor['specialty'] ?? 'Umum',
      );

      if (!mounted) return;
      _showSuccessDialog();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Gagal booking: $e")));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE3F2FD),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.thumb_up_rounded,
                      color: Color(0xFF5C9DFF),
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Thank You !',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your Appointment Successful',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'You booked an appointment with ${widget.doctor['name']} on ${widget.date}, at ${widget.time}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRouter.dashboard,
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5C9DFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().userModel;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Appointment",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Card
            _buildDoctorCard(),
            const SizedBox(height: 24),

            // Form
            const Text(
              "Appointment For",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField("Patient Name", _nameController),
            const SizedBox(height: 16),
            _buildTextField("Contact Number", _phoneController),
            const SizedBox(height: 24),

            // Who is this patient
            const Text(
              "Who is this patient?",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 110,
              child: _isLoadingChildren
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildAddButton(),
                        const SizedBox(width: 16),
                        // Self
                        _buildProfileItem(
                          0,
                          "Me",
                          user?.profileImage ?? '',
                          isUser: true,
                          onTap: () {
                            setState(() {
                              _selectedProfileIndex = 0;
                              _nameController.text = user?.name ?? '';
                            });
                          },
                        ),
                        // Children
                        ..._children.asMap().entries.map((entry) {
                          final index = entry.key + 1;
                          final child = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: _buildProfileItem(
                              index,
                              child.name,
                              child.profileImage ?? '',
                              isUser: false,
                              onTap: () {
                                setState(() {
                                  _selectedProfileIndex = index;
                                  _nameController.text = child.name;
                                });
                              },
                            ),
                          );
                        }),
                      ],
                    ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _submitAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5C9DFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Book Appointment',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard() {
    final price = widget.doctor['price'] != null
        ? "Rp ${widget.doctor['price']}"
        : "Rp -";

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: widget.doctor['image'] != null &&
                        (widget.doctor['image'] as String).startsWith('http')
                    ? CachedNetworkImageProvider(widget.doctor['image'])
                        as ImageProvider
                    : const AssetImage('assets/images/doctor1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.doctor['name'] ?? "Doctor Name",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.doctor['specialty'] ?? "Specialist",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    Icon(Icons.star, size: 14, color: Colors.grey.shade300),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.favorite, color: Colors.red, size: 20),
              const SizedBox(height: 16),
              Text(
                price,
                style: const TextStyle(
                  color: Color(0xFF5C9DFF),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Column(
      children: [
        Container(
          width: 60,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD), // Light blue bg
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(Icons.add, color: Color(0xFF5C9DFF), size: 30),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Add",
          style: TextStyle(
            color: Color(0xFF5C9DFF),
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileItem(int index, String label, String imageUrl,
      {required bool isUser, required VoidCallback onTap}) {
    bool isSelected = _selectedProfileIndex == index;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: imageUrl.isNotEmpty && imageUrl.startsWith('http')
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
              color: imageUrl.isEmpty ? Colors.grey.shade200 : null,
              border: isSelected
                  ? Border.all(color: const Color(0xFF5C9DFF), width: 2)
                  : null,
            ),
            child: imageUrl.isEmpty
                ? Icon(
                    isUser ? Icons.person : Icons.child_care,
                    size: 30,
                    color: Colors.grey,
                  )
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color:
                  isSelected ? const Color(0xFF2D3748) : Colors.grey.shade500,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // End of Class
}
