import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/app_router.dart';
import 'package:gizi_sehat_mobile_app/features/doctor/data/models/doctor_model.dart';

class DoctorDetailScreen extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorDetailScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Detail Dokter",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDoctorHeader(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatBox(
                          "${doctor.patientStories}", "Patient Stories"),
                      _buildStatBox(
                          "${doctor.experience ?? '0'}", "Experience"),
                      _buildStatBox("${doctor.rating}%", "Rating"),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                if (doctor.about.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "About Doctor",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      doctor.about,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Informasi Praktik",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildServiceItem("STR:",
                    doctor.strNumber.isNotEmpty ? doctor.strNumber : '-'),
                _buildServiceItem("SIP:",
                    doctor.sipNumber.isNotEmpty ? doctor.sipNumber : '-'),
                _buildServiceItem(
                    "Alumni:", doctor.alumni.isNotEmpty ? doctor.alumni : '-'),
                _buildServiceItem(
                    "Lokasi:",
                    doctor.practiceLocation.isNotEmpty
                        ? doctor.practiceLocation
                        : '-'),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Chat Button (IconButton)
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chat_bubble_outline,
                          color: Color(0xFF5C9DFF)),
                      onPressed: () {
                        // Navigate to Chat
                        Navigator.pushNamed(
                          context,
                          AppRouter.chat,
                          arguments: {
                            'name': doctor.name,
                            'image': doctor.imageUrl,
                            'isDoctor': true,
                            'doctorId': doctor.id, // Pass ID for chat logic
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Book Button
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          AppRouter.appointmentBooking,
                          arguments: doctor, // Pass model to booking
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5C9DFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Book Appointment",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorHeader() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              image: doctor.imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(doctor.imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: doctor.imageUrl.isEmpty
                ? const Icon(Icons.person, size: 40, color: Colors.blue)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        doctor.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Icon(Icons.favorite, color: Colors.red, size: 20),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  doctor.specialty,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Generate stars based on rating (simplified)
                    ...List.generate(5, (index) {
                      return Icon(
                        index < (doctor.rating / 20).round()
                            ? Icons.star
                            : Icons.star_border,
                        size: 16,
                        color: Colors.amber,
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Rp ${doctor.price}",
                  style: const TextStyle(
                    color: Color(0xFF5C9DFF),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String value, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF5C9DFF),
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
