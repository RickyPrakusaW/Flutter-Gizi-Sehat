import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/data/models/child_model.dart';

class ChildService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add Child
  Future<void> addChild(String userId, ChildModel child) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('children')
        .add(child.toMap());
  }

  // Update Child
  Future<void> updateChild(String userId, ChildModel child) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('children')
        .doc(child.id)
        .update(child.toMap());
  }

  // Delete Child
  Future<void> deleteChild(String userId, String childId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('children')
        .doc(childId)
        .delete();
  }

  // Get Children Stream
  Stream<List<ChildModel>> getChildrenStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('children')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ChildModel.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }
}
