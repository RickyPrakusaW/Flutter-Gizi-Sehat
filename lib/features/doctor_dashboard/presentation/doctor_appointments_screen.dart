import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gizi_sehat_mobile_app/features/auth/state/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorAppointmentsScreen extends StatefulWidget {
  const DoctorAppointmentsScreen({super.key});

  @override
  State<DoctorAppointmentsScreen> createState() =>
      _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState extends State<DoctorAppointmentsScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _appointments = [];

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    final user = Provider.of<AuthProvider>(context, listen: false).userModel;
    if (user == null) return;

    try {
      // In a real app, this should be in AppointmentService
      // For now, querying directly or via simple service wrapper
      final snapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: user.id)
          .orderBy('createdAt', descending: true)
          .get();

      final List<Map<String, dynamic>> loadedData = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        loadedData.add(data);
      }

      if (mounted) {
        setState(() {
          _appointments = loadedData;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading appointments: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateStatus(String appointmentId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .update({'status': newStatus});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status updated to $newStatus')),
      );

      _fetchAppointments(); // Refresh list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text(
          "Daftar Booking Pasien",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _appointments.isEmpty
              ? const Center(child: Text("Belum ada janji temu."))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _appointments.length,
                  itemBuilder: (context, index) {
                    final appt = _appointments[index];
                    return _buildAppointmentCard(appt);
                  },
                ),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appt) {
    final String status = appt['status'] ?? 'pending';
    Color statusColor = Colors.orange;
    if (status == 'confirmed') statusColor = Colors.green;
    if (status == 'cancelled') statusColor = Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appt['patientName'] ?? 'Unknown Patient',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text("Tanggal: ${appt['date']} - Jam: ${appt['time']}"),
            Text("Keluhan: ${appt['complaint'] ?? '-'}"),
            const SizedBox(height: 8),
            Text(
              "Kontak Ortu: ${appt['contactParent']}",
              style: const TextStyle(color: Colors.blue),
            ),
            const SizedBox(height: 16),
            if (status == 'pending')
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => _updateStatus(appt['id'], 'cancelled'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text("Tolak"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => _updateStatus(appt['id'], 'confirmed'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Terima"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
