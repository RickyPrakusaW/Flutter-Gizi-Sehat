import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/app_router.dart';
import 'package:gizi_sehat_mobile_app/features/doctor/data/models/doctor_model.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class BookAppointmentScreen extends StatefulWidget {
  final DoctorModel doctor;

  const BookAppointmentScreen({super.key, required this.doctor});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  int _selectedDateIndex = 0;
  String? _selectedTimeSlot;
  Map<String, List<String>> _fetchedSchedules = {};
  bool _isLoading = true;
  final List<String> _existingAppointments = [];

  // Generate next 7 days
  final List<DateTime> _dates =
      List.generate(7, (index) => DateTime.now().add(Duration(days: index)));

  @override
  void initState() {
    super.initState();
    _fetchedSchedules = widget.doctor.schedules; // Initialize with passed data
    _fetchLatestSchedule();
  }

  Future<void> _fetchLatestSchedule() async {
    try {
      // 1. Fetch Doctor's Schedule
      final doc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(widget.doctor.id)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        if (data['schedules'] != null) {
          if (mounted) {
            setState(() {
              _fetchedSchedules = Map<String, List<String>>.from(
                  (data['schedules'] as Map).map(
                      (key, value) => MapEntry(key, List<String>.from(value))));
            });
          }
        }
      }

      // 2. Fetch Existing Bookings for current selection
      await _fetchBookedSlots();
    } catch (e) {
      debugPrint("Error fetching schedule: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchBookedSlots() async {
    final formattedDate =
        DateFormat('d MMMM yyyy').format(_dates[_selectedDateIndex]);

    try {
      final query = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: widget.doctor.id)
          .where('date', isEqualTo: formattedDate)
          .get();

      final bookedTimes = <String>[];
      for (var doc in query.docs) {
        final data = doc.data();
        if (data['status'] != 'cancelled') {
          bookedTimes.add(data['time']);
        }
      }

      if (mounted) {
        setState(() {
          _existingAppointments.clear();
          _existingAppointments.addAll(bookedTimes);
        });
      }
    } catch (e) {
      debugPrint("Error fetching bookings: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get formatted date key for the selected day 'yyyy-MM-dd'
    final dateKey = DateFormat('yyyy-MM-dd').format(_dates[_selectedDateIndex]);
    final availableSlots = _fetchedSchedules[dateKey] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Pilih Jadwal",
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor Card
                  _buildDoctorCard(),

                  // Date Selection
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      children: List.generate(_dates.length, (index) {
                        final date = _dates[index];
                        final dateKey = DateFormat('yyyy-MM-dd').format(date);
                        final slots = _fetchedSchedules[dateKey] ?? [];
                        final isAvailable = slots.isNotEmpty;
                        final label = index == 0
                            ? "Hari Ini"
                            : index == 1
                                ? "Besok"
                                : DateFormat('EEEE').format(date);
                        final fullDate = DateFormat('d MMM').format(date);

                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _buildDateCard(index, "$label, $fullDate",
                              "${slots.length} jam tersedia", isAvailable),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      DateFormat('EEEE, d MMMM yyyy')
                          .format(_dates[_selectedDateIndex]),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Time Slots
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      availableSlots.isEmpty
                          ? "Tidak ada jadwal tersedia hari ini."
                          : "Jam Tersedia",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (availableSlots.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          ...[
                            '09:00',
                            '09:30',
                            '10:00',
                            '10:30',
                            '11:00',
                            '11:30',
                            '13:00',
                            '13:30',
                            '14:00',
                            '14:30',
                            '15:00',
                            '15:30',
                            '16:00',
                            '16:30',
                            '19:00',
                            '19:30',
                            '20:00',
                            '20:30'
                          ].map((time) {
                            // Check if this slot is in the doctor's enabled availableSlots
                            bool isEnabled = availableSlots.contains(time);

                            // ALSO check if it's already booked
                            if (_existingAppointments.contains(time)) {
                              isEnabled = false;
                              // If booked, we treat it as unavailable
                            }

                            return _buildTimeSlot(time, isEnabled);
                          }),
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
                        onPressed: _selectedTimeSlot == null
                            ? null
                            : () {
                                Navigator.pushNamed(
                                  context,
                                  AppRouter.appointmentPatientDetails,
                                  arguments: {
                                    'doctor': widget.doctor.toMap(),
                                    'date': DateFormat('d MMMM yyyy')
                                        .format(_dates[_selectedDateIndex]),
                                    'time': _selectedTimeSlot,
                                  },
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5C9DFF),
                          disabledBackgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Lanjut",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
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
              image: widget.doctor.imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(widget.doctor.imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: widget.doctor.imageUrl.isEmpty
                ? const Icon(Icons.person, size: 30, color: Colors.grey)
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
                        widget.doctor.name,
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
                Text(
                  widget.doctor.practiceLocation.isNotEmpty
                      ? widget.doctor.practiceLocation
                      : "Lokasi Praktik",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(
                      5,
                      (index) => Icon(
                          index < (widget.doctor.rating / 20).round()
                              ? Icons.star
                              : Icons.star_border,
                          size: 14,
                          color: Colors.amber)),
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

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDateIndex = index;
          _selectedTimeSlot = null; // Reset time selection on date change
        });
        _fetchBookedSlots(); // Fetch bookings for the new date
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF5C9DFF)
              : (available ? const Color(0xFFF7F9FC) : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? null : Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Text(
              date,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (available ? const Color(0xFF2D3748) : Colors.grey),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              status,
              textAlign: TextAlign.center,
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

  Widget _buildTimeSlot(String time, bool isAvailable) {
    bool isSelected = _selectedTimeSlot == time;
    return GestureDetector(
      onTap: isAvailable
          ? () {
              setState(() {
                _selectedTimeSlot = time;
              });
            }
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isAvailable
              ? (isSelected ? const Color(0xFF5C9DFF) : const Color(0xFFE0F2F1))
              : Colors.grey.shade200, // Gray for unavailable
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: isAvailable
                ? (isSelected ? Colors.white : const Color(0xFF5C9DFF))
                : Colors.grey, // Gray text for unavailable
            fontWeight: FontWeight.bold,
            fontSize: 13,
            decoration: isAvailable ? null : TextDecoration.lineThrough,
          ),
        ),
      ),
    );
  }
}
