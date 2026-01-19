import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createAppointment({
    required String doctorId,
    required String parentId,
    required String patientName,
    required String contactNumber,
    required String date,
    required String time,
    required String doctorName,
    required String doctorImage,
    required String doctorSpecialty,
  }) async {
    try {
      await _firestore.collection('appointments').add({
        'doctorId': doctorId,
        'parentId': parentId,
        'patientName': patientName,
        'contactNumber': contactNumber,
        'date': date,
        'time': time,
        'status': 'pending', // pending, confirmed, completed, cancelled
        'doctorName': doctorName,
        'doctorImage': doctorImage,
        'doctorSpecialty': doctorSpecialty,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Error creating appointment: $e");
      rethrow;
    }
  }

  Stream<QuerySnapshot> getDoctorAppointments(String doctorId) {
    return _firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getParentAppointments(String parentId) {
    return _firestore
        .collection('appointments')
        .where('parentId', isEqualTo: parentId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> updateAppointmentStatus(
      String appointmentId, String status) async {
    await _firestore.collection('appointments').doc(appointmentId).update({
      'status': status,
    });
  }
}
