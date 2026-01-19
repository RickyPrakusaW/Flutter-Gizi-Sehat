import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/app_router.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Dummy Data
  final List<Map<String, dynamic>> _doctors = [
    {
      'id': '1',
      'name': 'Dr. Shruti Kedia',
      'specialty': 'Tooths Dentist',
      'exp': '7 Years experience',
      'percentage': '87%',
      'stories': '69 Patient Stories',
      'nextAvailable': '10:00 AM tomorrow',
      'image': 'assets/images/doctor1.png',
      'isFavorite': true,
    },
    {
      'id': '2',
      'name': 'Dr. Watamaniuk',
      'specialty': 'Tooths Dentist',
      'exp': '9 Years experience',
      'percentage': '74%',
      'stories': '78 Patient Stories',
      'nextAvailable': '12:00 AM tomorrow',
      'image': 'assets/images/doctor2.png',
      'isFavorite': false,
    },
    {
      'id': '3',
      'name': 'Dr. Crownover',
      'specialty': 'Tooths Dentist',
      'exp': '5 Years experience',
      'percentage': '59%',
      'stories': '86 Patient Stories',
      'nextAvailable': '11:00 AM tomorrow',
      'image': 'assets/images/doctor3.png',
      'isFavorite': true,
    },
    {
      'id': '4',
      'name': 'Dr. Balestra',
      'specialty': 'Tooths Dentist',
      'exp': '6 Years experience',
      'percentage': '87%',
      'stories': '60 Patient Stories',
      'nextAvailable': '10:00 AM tomorrow',
      'image': 'assets/images/doctor4.png',
      'isFavorite': false,
    },
  ];

  List<Map<String, dynamic>> get _filteredDoctors {
    if (_searchController.text.isEmpty) {
      return _doctors;
    }
    return _doctors.where((doc) {
      final name = doc['name'].toString().toLowerCase();
      final specialty = doc['specialty'].toString().toLowerCase();
      final query = _searchController.text.toLowerCase();
      return name.contains(query) || specialty.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Find Doctors',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () =>
                Navigator.pushNamed(context, AppRouter.favoriteDoctors),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF5C9DFF).withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {}); // Trigger rebuild to filter
                },
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFF5C9DFF)),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close,
                              size: 18, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  hintText: 'Cari dokter atau spesialis...',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                ),
              ),
            ),
          ),

          // List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _filteredDoctors.length,
              itemBuilder: (context, index) {
                final doctor = _filteredDoctors[index];
                return _buildDoctorCard(context, doctor);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, Map<String, dynamic> doctor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person, size: 40, color: Colors.grey),
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
                              doctor['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3748),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            doctor['isFavorite']
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: doctor['isFavorite']
                                ? Colors.red
                                : Colors.grey.shade400,
                            size: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctor['specialty'],
                        style: const TextStyle(
                          color: Color(0xFF5C9DFF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctor['exp'],
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildDotInfo(Colors.green, doctor['percentage']),
                          const SizedBox(width: 16),
                          _buildDotInfo(Colors.green, doctor['stories']),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Next Available',
                      style: TextStyle(
                        color: Color(0xFF5C9DFF),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor['nextAvailable'],
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.doctorDetail,
                        arguments: doctor);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5C9DFF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDotInfo(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }
}
