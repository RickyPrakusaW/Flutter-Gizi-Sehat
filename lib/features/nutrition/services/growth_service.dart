import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/data/models/child_model.dart'; // Dashboard Model
import 'package:gizi_sehat_mobile_app/features/nutrition/models/child_model.dart'; // GrowthRecord enum

class GrowthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection References
  // Note: Mengikuti struktur ChildService yang sudah ada: users/{uid}/children
  CollectionReference _childrenRef(String userId) =>
      _firestore.collection('users').doc(userId).collection('children');

  CollectionReference _recordsRef(String userId, String childId) =>
      _childrenRef(userId).doc(childId).collection('growth_records');

  /// Menambahkan data anak baru
  Future<String> addChild(String userId, ChildModel child) async {
    try {
      final docRef = _childrenRef(userId)
          .doc(); // Auto-ID if child.id is empty or we ignore it
      final newId = docRef.id;

      // We assume ChildModel here is the one from nutrition feature,
      // which has toJson matching what we want.
      // We must map it carefully to not break existing ChildModel structure if we read it elsewhere.
      // Existing ChildModel uses: name, gender, birthDate (camelCase), status.
      // Our ChildModel uses: name, gender, date_of_birth (snake_case), etc.
      // We should probably standardise to CamelCase to match existing app, or handle both.
      // For safety, let's look at how ChildService writes: 'birthDate', 'gender'.
      // We will duplicate keys or stick to one convention.
      // Let's write snake_case AND camelCase to be safe? No, that's messy.
      // Let's write camelCase to match existing Dashboard.

      final data = {
        'id': newId,
        'name': child.name,
        'gender': child
            .gender, // String 'Laki-laki' or 'Perempuan' from dashboard model
        'birthDate': child.birthDate.toIso8601String(),
        'status': 'Normal', // Default
        // Additional growth fields (not in Dashboard ChildModel? We can add extra fields to map)
        'parentId': userId,
      };

      await docRef.set(data);
      return newId;
    } catch (e) {
      throw Exception('Gagal menambahkan data anak: $e');
    }
  }

  /// Menambahkan record pertumbuhan (berat/tinggi)
  Future<void> addGrowthRecord(String userId, GrowthRecord record) async {
    final batch = _firestore.batch();
    final childRef = _childrenRef(userId).doc(record.childId);
    final recordRef = _recordsRef(userId, record.childId).doc(record.id);

    // Save record
    batch.set(recordRef, record.toJson());

    // Update child latest info (using camelCase to match the addChild logic above)
    batch.update(childRef, {
      'lastWeight': record.weight,
      'lastHeight': record.height,
      'lastMeasurementDate': record.date.toIso8601String(),
    });

    try {
      await batch.commit();
    } catch (e) {
      throw Exception('Gagal menyimpan data pertumbuhan: $e');
    }
  }

  // Calculator Logic (Same as before)
  Map<String, dynamic> calculateStatus({
    required int ageMonths,
    required double weight,
    required double height,
    required String gender, // String input
  }) {
    // Dummy Logic
    return {
      'bb_u': 'Normal',
      'tb_u': 'Normal',
      'bb_tb': 'Gizi Baik',
    };
  }
}
