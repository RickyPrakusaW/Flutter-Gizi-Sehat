import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/app_router.dart';

class BookAppointmentScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const BookAppointmentScreen({super.key, required this.doctor});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  int _selectedDateIndex = 1; // Default to Tomorrow
  String? _selectedTimeSlot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Select Time",
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Card
            _buildDoctorCard(),

            // Date Selection
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  _buildDateCard(
                      0, "Today, 23 Feb", "No slots available", false),
                  const SizedBox(width: 12),
                  _buildDateCard(
                      1, "Tomorrow, 24 Feb", "9 slots available", true),
                  const SizedBox(width: 12),
                  _buildDateCard(
                      2, "Thursday, 25 Feb", "10 slots available", false),
                ],
              ),
            ),

            const SizedBox(height: 10),
            const Center(
              child: Text(
                "Today, 23 Feb",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Time Slots
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Afternoon 7 slots",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildTimeSlot("1:00 PM"),
                  _buildTimeSlot("1:30 PM"),
                  _buildTimeSlot("2:00 PM"),
                  _buildTimeSlot("2:30 PM"),
                  _buildTimeSlot("3:00 PM"),
                  _buildTimeSlot("3:30 PM"),
                  _buildTimeSlot("4:00 PM"),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Evening 5 slots",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildTimeSlot("5:00 PM"),
                  _buildTimeSlot("5:30 PM"),
                  _buildTimeSlot("6:00 PM"),
                  _buildTimeSlot("6:30 PM"),
                  _buildTimeSlot("7:00 PM"),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Patient Details
                    Navigator.pushNamed(
                      context,
                      AppRouter.appointmentPatientDetails,
                      arguments: {
                        'doctor': widget.doctor,
                        'date':
                            'Tomorrow, 24 Feb', // Mock date as logic isn't dynamic yet
                        'time':
                            _selectedTimeSlot ?? '10:00 AM', // Provide default
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5C9DFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Next Step",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF5C9DFF)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Contact Clinic",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5C9DFF)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
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
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person, size: 30, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.doctor['name'] ?? "Dr. Name",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const Icon(Icons.favorite, color: Colors.red, size: 20),
                  ],
                ),
                Text(
                  "Upasana Dental Clinic, salt lake",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
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
        ],
      ),
    );
  }

  Widget _buildDateCard(int index, String date, String status, bool available) {
    bool isSelected = _selectedDateIndex == index;
    // The image logic: Green BG if available/selected? Image shows Green if Selected.
    // "No slots available" is greyed out.
    // I'll make a simple selectable logic.

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDateIndex = index;
        });
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5C9DFF) : const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              date,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF2D3748),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              status,
              style: TextStyle(
                color: isSelected
                    ? Colors.white.withOpacity(0.8)
                    : Colors.grey.shade500,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlot(String time) {
    bool isSelected = _selectedTimeSlot == time;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTimeSlot = time;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF5C9DFF)
              : const Color(0xFFE0F2F1), // Light Green bg for slots
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF5C9DFF),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
