import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser {
    return _auth.currentUser;
  }

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Sign in dengan Google
  /// Langkah-langkah:
  /// 1. Trigger Google Sign-In flow
  /// 2. Dapatkan authentication credentials dari Google
  /// 3. Sign in ke Firebase menggunakan credentials tersebut
  Future<void> signInWithGoogle() async {
    // Step 1: Trigger Google Sign-In flow
    // Ini akan membuka dialog Google Sign-In
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Jika user membatalkan sign-in, throw error
    if (googleUser == null) {
      throw Exception('Google Sign-In dibatalkan oleh user');
    }

    // Step 2: Dapatkan authentication details dari Google account
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Step 3: Buat credential untuk Firebase
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Step 4: Sign in ke Firebase menggunakan credential
    await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    // Sign out dari Google juga
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
