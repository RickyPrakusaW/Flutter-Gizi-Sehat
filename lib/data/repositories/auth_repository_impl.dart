import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gizi_sehat_mobile_app/core/services/auth_service.dart';
import 'package:gizi_sehat_mobile_app/core/services/cloudinary_service.dart';
import 'package:gizi_sehat_mobile_app/features/auth/models/user_model.dart';
import 'package:gizi_sehat_mobile_app/features/auth/services/role_service.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _service;

  AuthRepositoryImpl(this._service);

  @override
  Stream<AuthUserData?> watchAuthState() {
    return _service.authStateChanges().map((user) {
      if (user == null) {
        return null;
      }

      return AuthUserData(uid: user.uid, email: user.email);
    });
  }

  @override
  AuthUserData? get currentUser {
    final user = _service.currentUser;
    if (user == null) return null;
    return AuthUserData(uid: user.uid, email: user.email);
  }

  @override
  Future<void> login(String email, String password) {
    return _service.signInWithEmail(email: email, password: password);
  }

  @override
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
  }) async {
    final cred = await _service.registerWithEmail(
      email: email,
      password: password,
    );

    if (cred.user != null) {
      // Upload proof image if exists
      String? uploadedProofUrl;
      if (proofImage != null) {
        try {
          final cloudinaryService = CloudinaryService();
          uploadedProofUrl = await cloudinaryService.uploadImage(proofImage);
        } catch (e) {
          // Fallback logic handled by caller or just log
          // Might want to throw if strict, but let's proceed to create user doc with optional proof
          print('Failed to upload proof image to Cloudinary: $e');
        }
      }

      // Save user data to Firestore
      final userModel = UserModel(
        id: cred.user!.uid,
        email: email,
        name:
            name ??
            email.split('@')[0], // Use provided name or default to email prefix
        role: role,
        status: role == UserRole.doctor
            ? UserStatus.pending
            : UserStatus.active,
        proofUrl: uploadedProofUrl,
        title: title,
        specialist: specialist,
        strNumber: strNumber,
        sipNumber: sipNumber,
        practiceLocation: practiceLocation,
        alumni: alumni,
        experienceYear: experienceYear,
      );

      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(cred.user!.uid)
            .set(userModel.toJson());

        // Update local RoleService for immediate feedback if needed (optional)
        RoleService.setUser(userModel);
      } on FirebaseException catch (e) {
        if (e.code == 'permission-denied') {
          throw Exception(
            'Gagal menyimpan data user: Izin ditolak (Permission Denied). \n'
            'Pastikan Firestore Database sudah dibuat dan Rules diatur ke "Allow Read/Write".\n'
            'Cek Firebase Console > Build > Firestore Database.',
          );
        }
        rethrow;
      }
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    final cred = await _service.signInWithGoogle();

    // Jika login berhasil, cek apakah data user sudah ada di Firestore
    if (cred.user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .get();

      if (!userDoc.exists) {
        // User baru pertama kali login via Google -> Buat sebagai Parent
        final email = cred.user!.email ?? 'no-email';
        final name = cred.user!.displayName ?? email.split('@')[0];
        final photo = cred.user!.photoURL;

        final newUser = UserModel(
          id: cred.user!.uid,
          email: email,
          name: name,
          role: UserRole.parent, // Default role untuk Google Sign-In
          status: UserStatus.active, // Langsung aktif
          profileImage: photo,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(cred.user!.uid)
            .set(newUser.toJson());
      }
    }
  }

  @override
  Future<void> logout() {
    return _service.signOut();
  }
}
