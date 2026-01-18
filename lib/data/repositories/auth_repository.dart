import 'dart:io';
import 'package:gizi_sehat_mobile_app/features/auth/models/user_model.dart';

class AuthUserData {
  final String uid;
  final String? email;

  const AuthUserData({required this.uid, required this.email});

  @override
  String toString() {
    return 'AuthUserData(uid: $uid, email: $email)';
  }
}

abstract class AuthRepository {
  Stream<AuthUserData?> watchAuthState();
  AuthUserData? get currentUser;
  Future<void> login(String email, String password);
  Future<void> register(
    String email,
    String password, {
    UserRole role = UserRole.parent,
    String? name,
    String? title,
    String? specialist,
    String? strNumber,
    String? sipNumber,
    String? practiceLocation,
    String? alumni,
    int? experienceYear,
    File? proofImage,
  });
  Future<void> signInWithGoogle(); // Method baru untuk Google Sign-In
  Future<void> logout();
}
