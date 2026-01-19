import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/features/doctor/data/models/doctor_model.dart';

class DoctorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _limit = 10;
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;

  bool get hasMore => _hasMore;

  Future<List<DoctorModel>> getDoctors({bool refresh = false}) async {
    if (refresh) {
      _lastDocument = null;
      _hasMore = true;
    }

    if (!_hasMore) return [];

    Query query = _firestore
        .collection('users')
        .where('role', isEqualTo: 'doctor')
        .where('status', isEqualTo: 'active') // Only active doctors
        .limit(_limit);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    try {
      final snapshot = await query.get();

      if (snapshot.docs.length < _limit) {
        _hasMore = false;
      }

      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
      }

      return snapshot.docs
          .map((doc) => DoctorModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint("Error fetching doctors: $e");
      return [];
    }
  }

  // Fetch all doctors (lightweight) for caching if needed
  Future<List<DoctorModel>> getAllDoctors() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'doctor')
          .where('status', isEqualTo: 'active')
          .get();
      return snapshot.docs
          .map((doc) => DoctorModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
