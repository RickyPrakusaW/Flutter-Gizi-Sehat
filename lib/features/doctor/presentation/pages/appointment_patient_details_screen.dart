import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gizi_sehat_mobile_app/app_router.dart';

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
  int _selectedProfileIndex = 1; // Default My Self

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
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
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Edit your appointment',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
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
            Row(
              children: [
                _buildAddButton(),
                const SizedBox(width: 16),
                _buildProfileItem(
                  1,
                  "My Self",
                  "https://placehold.co/200x200/png?text=Me",
                ),
                const SizedBox(width: 16),
                _buildProfileItem(
                  2,
                  "My child",
                  "https://placehold.co/200x200/png?text=Baby",
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _showSuccessDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5C9DFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Next",
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
                "\$ 28.00/hr", // Dummy price or from data
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

  Widget _buildProfileItem(int index, String label, String imageUrl) {
    bool isSelected = _selectedProfileIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedProfileIndex = index;
        });
      },
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80, // Taller card aspect
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: CachedNetworkImageProvider(imageUrl),
                fit: BoxFit.cover,
              ),
              border: isSelected
                  ? Border.all(color: const Color(0xFF5C9DFF), width: 2)
                  : null,
            ),
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
          ),
        ],
      ),
    );
  }
}
