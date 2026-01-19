import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gizi_sehat_mobile_app/app_router.dart';

class FavoriteDoctorsScreen extends StatelessWidget {
  const FavoriteDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock List of Save Doctors
    final favoriteDoctors = [
      {
        'id': '1',
        'name': 'Dr. Truluck Nik',
        'specialty': 'Medicine Specialist',
        'rating': 4.0,
        'image': 'https://placehold.co/200x200/png?text=Dr+Nik',
        'hospital': 'Siloam Hospital', // Added mock data
      },
      {
        'id': '2',
        'name': 'Dr. Tranquilli',
        'specialty': 'Pathology Specialist',
        'rating': 5.0,
        'image': 'https://placehold.co/200x200/png?text=Dr+Tran',
        'hospital': 'Mitra Keluarga', // Added mock data
      },
      // Added a few more for demo
      {
        'id': '3',
        'name': 'Dr. Shoemaker',
        'specialty': 'Pediatrician',
        'rating': 3.5,
        'image': 'https://placehold.co/200x200/png?text=Dr+Shoe',
        'hospital': 'Hermina Hospital',
      }
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Saved Doctors",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: favoriteDoctors.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border,
                      size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    "No saved doctors yet",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: favoriteDoctors.length,
              itemBuilder: (context, index) {
                final doctor = favoriteDoctors[index];
                return _buildDoctorCard(context, doctor);
              },
            ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, Map<String, dynamic> doctor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image:
                        CachedNetworkImageProvider(doctor['image'] as String),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            doctor['name'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                        ),
                        const Icon(Icons.favorite, color: Colors.red, size: 20),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor['specialty'] as String,
                      style: const TextStyle(
                        color: Color(0xFF5C9DFF),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          doctor['rating'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '• ${doctor['hospital'] ?? "General Hospital"}',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.doctorDetail,
                        arguments: doctor);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE3F2FD),
                    foregroundColor: const Color(0xFF5C9DFF),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    "Book Appointment",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
