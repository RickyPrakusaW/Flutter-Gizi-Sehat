import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/features/auth/state/auth_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorScheduleScreen extends StatefulWidget {
  const DoctorScheduleScreen({super.key});

  @override
  State<DoctorScheduleScreen> createState() => _DoctorScheduleScreenState();
}

class _DoctorScheduleScreenState extends State<DoctorScheduleScreen> {
  int _selectedDateIndex = 0;
  bool _isLoading = false;

  // Map<DateString, List<TimeString>>
  Map<String, List<String>> _schedules = {};

  // Standard slots to toggle
  final List<String> _allSlots = [
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
  ];

  // Generate next 7 days
  final List<DateTime> _dates =
      List.generate(7, (index) => DateTime.now().add(Duration(days: index)));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSchedule();
    });
  }

  Future<void> _fetchSchedule() async {
    setState(() => _isLoading = true);
    final user = Provider.of<AuthProvider>(context, listen: false).userModel;
    if (user == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(user.id)
          .get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        if (data['schedules'] != null) {
          if (mounted) {
            setState(() {
              _schedules = Map<String, List<String>>.from(
                  (data['schedules'] as Map).map(
                      (key, value) => MapEntry(key, List<String>.from(value))));
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading schedule: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveSchedule() async {
    setState(() => _isLoading = true);
    final user = Provider.of<AuthProvider>(context, listen: false).userModel;
    if (user == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('doctors').doc(user.id).set({
        'schedules': _schedules,
      }, SetOptions(merge: true));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Jadwal berhasil disimpan!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error saving schedule: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _toggleSlot(String dateKey, String time) {
    final currentSlots = _schedules[dateKey] ?? [];
    setState(() {
      if (currentSlots.contains(time)) {
        currentSlots.remove(time);
      } else {
        currentSlots.add(time);
        // Sort slots properly
        currentSlots.sort((a, b) => a.compareTo(b));
      }
      _schedules[dateKey] = currentSlots;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = _dates[_selectedDateIndex];
    final selectedDateKey = DateFormat('yyyy-MM-dd').format(selectedDate);
    final activeSlots = _schedules[selectedDateKey] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Atur Jadwal Praktik",
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
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Color(0xFF5C9DFF)),
            onPressed: _saveSchedule,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                    child: Text("Pilih Tanggal",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  // Date Selection
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: List.generate(_dates.length, (index) {
                        final date = _dates[index];
                        final dateKey = DateFormat('yyyy-MM-dd').format(date);
                        final slotsCount = (_schedules[dateKey] ?? []).length;
                        final label = index == 0
                            ? "Hari Ini"
                            : index == 1
                                ? "Besok"
                                : DateFormat('EEEE').format(date);
                        final fullDate = DateFormat('d MMM').format(date);
                        final isSelected = index == _selectedDateIndex;

                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _selectedDateIndex = index),
                            child: Container(
                              width: 140,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF5C9DFF)
                                    : const Color(0xFFF7F9FC),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "$label, $fullDate",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFF2D3748),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "$slotsCount slot aktif",
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
                          ),
                        );
                      }),
                    ),
                  ),

                  const Divider(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Text("Slot Waktu",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const Spacer(),
                        Text(
                            DateFormat('EEEE, d MMMM yyyy')
                                .format(selectedDate),
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2.5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _allSlots.length,
                      itemBuilder: (context, index) {
                        final time = _allSlots[index];
                        final isActive = activeSlots.contains(time);

                        return InkWell(
                          onTap: () => _toggleSlot(selectedDateKey, time),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xFF5C9DFF)
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isActive
                                    ? const Color(0xFF5C9DFF)
                                    : Colors.grey.shade300,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              time,
                              style: TextStyle(
                                color: isActive
                                    ? Colors.white
                                    : Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                                decoration: !isActive
                                    ? null
                                    : null, // Could add strikethrough if we meant "unavailable" was specific
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "* Klik pada slot waktu untuk mengaktifkan/menonaktifkan ketersediaan.",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}
