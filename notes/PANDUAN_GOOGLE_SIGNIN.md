# Panduan Implementasi Google Sign-In di Flutter

## 📚 Penjelasan Lengkap

### Apa itu Google Sign-In?

Google Sign-In adalah metode autentikasi yang memungkinkan user untuk login menggunakan akun Google mereka, tanpa perlu membuat password baru. Ini membuat proses login lebih cepat dan aman.

---

## 🔧 Langkah-langkah Implementasi

### 1. **Menambahkan Dependency**

Tambahkan package `google_sign_in` ke `pubspec.yaml`:

```yaml
dependencies:
  google_sign_in: ^6.2.1
```

Kemudian jalankan:
```bash
flutter pub get
```

---

### 2. **Setup Firebase Console**

**PENTING:** Sebelum bisa menggunakan Google Sign-In, Anda harus mengaktifkannya di Firebase Console:

1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Pilih project Anda
3. Pergi ke **Authentication** → **Sign-in method**
4. Klik **Google** → **Enable**
5. Masukkan **Support email**
6. Klik **Save**

---

### 3. **Struktur Kode (Architecture)**

Implementasi Google Sign-In mengikuti pola **Repository Pattern**:

```
LoginScreen (UI)
    ↓
AuthProvider (State Management)
    ↓
AuthRepository (Interface)
    ↓
AuthRepositoryImpl (Implementation)
    ↓
AuthService (Firebase + Google Sign-In)
```

---

### 4. **Penjelasan Setiap Layer**

#### **A. AuthService** (`lib/core/services/auth_service.dart`)

Ini adalah layer paling bawah yang berinteraksi langsung dengan Firebase dan Google Sign-In.

```dart
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    // Step 1: Trigger Google Sign-In flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Step 2: Dapatkan authentication details
    final GoogleSignInAuthentication googleAuth = 
        await googleUser.authentication;

    // Step 3: Buat credential untuk Firebase
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Step 4: Sign in ke Firebase
    await _auth.signInWithCredential(credential);
  }
}
```

**Penjelasan:**
- `GoogleSignIn()`: Membuat instance untuk Google Sign-In
- `signIn()`: Membuka dialog Google Sign-In, user memilih akun
- `authentication`: Mendapatkan access token dan ID token dari Google
- `GoogleAuthProvider.credential()`: Membuat credential untuk Firebase
- `signInWithCredential()`: Sign in ke Firebase menggunakan credential

---

#### **B. AuthRepository** (`lib/data/repositories/auth_repository.dart`)

Interface yang mendefinisikan kontrak untuk autentikasi.

```dart
abstract class AuthRepository {
  Future<void> signInWithGoogle(); // Method untuk Google Sign-In
  // ... method lainnya
}
```

---

#### **C. AuthRepositoryImpl** (`lib/data/repositories/auth_repository_impl.dart`)

Implementasi dari AuthRepository yang memanggil AuthService.

```dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthService _service;

  @override
  Future<void> signInWithGoogle() {
    return _service.signInWithGoogle();
  }
}
```

---

#### **D. AuthProvider** (`lib/features/auth/state/auth_provider.dart`)

State management yang mengelola state autentikasi dan menangani error.

```dart
class AuthProvider extends ChangeNotifier {
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _clearError();

    try {
      await _repo.signInWithGoogle();
      return true; // Berhasil
    } catch (e) {
      _setError(_readableError(e));
      return false; // Gagal
    } finally {
      _setLoading(false);
    }
  }
}
```

**Fitur:**
- Loading state: Menampilkan loading indicator
- Error handling: Menangani error dan menampilkan pesan yang user-friendly
- Auto navigation: Setelah login berhasil, user otomatis masuk ke dashboard

---

#### **E. LoginScreen** (`lib/features/auth/presentation/login_screen.dart`)

UI yang memanggil AuthProvider ketika tombol Google diklik.

```dart
Future<void> _onGoogleSignIn() async {
  final auth = context.read<AuthProvider>();
  
  final ok = await auth.signInWithGoogle();
  
  if (ok) {
    // Login berhasil → navigasi ke dashboard
    Navigator.pushReplacementNamed(context, AppRouter.dashboard);
  } else {
    // Login gagal → tampilkan error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(auth.errorMessage)),
    );
  }
}
```

---

## 🔄 Alur Kerja (Flow)

1. **User klik tombol "Masuk dengan Google"**
   - `LoginScreen._onGoogleSignIn()` dipanggil

2. **AuthProvider menangani request**
   - `AuthProvider.signInWithGoogle()` dipanggil
   - Loading state diaktifkan

3. **AuthRepository memanggil AuthService**
   - `AuthRepositoryImpl.signInWithGoogle()` → `AuthService.signInWithGoogle()`

4. **Google Sign-In dialog muncul**
   - User memilih akun Google
   - Google mengembalikan access token dan ID token

5. **Firebase authentication**
   - Credential dibuat dari token Google
   - Firebase sign in dengan credential tersebut

6. **Success/Error handling**
   - Jika berhasil: User otomatis masuk ke dashboard
   - Jika gagal: Error message ditampilkan

---

## 🎯 Keuntungan Menggunakan Google Sign-In

1. **User Experience**
   - Tidak perlu membuat password baru
   - Login lebih cepat (1 klik)
   - Tidak perlu mengingat password

2. **Security**
   - Google mengelola keamanan akun
   - Two-factor authentication otomatis
   - Lebih aman dari password biasa

3. **Developer Experience**
   - Tidak perlu handle password reset
   - Tidak perlu validasi password
   - Integrasi mudah dengan Firebase

---

## ⚠️ Error Handling

Beberapa error yang mungkin terjadi:

1. **User membatalkan sign-in**
   ```dart
   if (raw.contains('dibatalkan') || raw.contains('cancelled')) {
     return 'Login dengan Google dibatalkan';
   }
   ```

2. **Network error**
   ```dart
   if (raw.contains('network_error')) {
     return 'Koneksi internet bermasalah';
   }
   ```

3. **Firebase error**
   - Error dari Firebase akan ditangani oleh `_readableError()`

---

## 📱 Testing

### Cara Test Google Sign-In:

1. **Run aplikasi**
   ```bash
   flutter run
   ```

2. **Klik tombol "Masuk dengan Google"**
   - Dialog Google Sign-In akan muncul

3. **Pilih akun Google**
   - Pilih akun yang ingin digunakan
   - Atau tambahkan akun baru

4. **Verifikasi**
   - Jika berhasil, Anda akan masuk ke dashboard
   - Jika gagal, error message akan muncul

---

## 🔐 Security Best Practices

1. **Jangan hardcode credentials**
   - Semua credentials disimpan di Firebase Console

2. **Enable Google Sign-In di Firebase**
   - Pastikan Google Sign-In sudah diaktifkan

3. **Handle error dengan baik**
   - Jangan expose error detail ke user
   - Gunakan pesan error yang user-friendly

4. **Logout yang benar**
   - Pastikan sign out dari Google juga
   ```dart
   Future<void> signOut() async {
     await _googleSignIn.signOut(); // Sign out dari Google
     await _auth.signOut(); // Sign out dari Firebase
   }
   ```

---

## 📝 Checklist Setup

- [x] Dependency `google_sign_in` ditambahkan
- [x] Google Sign-In diaktifkan di Firebase Console
- [x] `AuthService.signInWithGoogle()` diimplementasi
- [x] `AuthRepository.signInWithGoogle()` diimplementasi
- [x] `AuthProvider.signInWithGoogle()` diimplementasi
- [x] `LoginScreen` memanggil Google Sign-In
- [x] Error handling ditambahkan
- [x] Testing dilakukan

---

## 🎓 Kesimpulan

Google Sign-In adalah fitur yang sangat berguna untuk meningkatkan user experience. Dengan mengikuti pola Repository Pattern, kode menjadi lebih terorganisir dan mudah di-maintain.

**Key Points:**
- Google Sign-In menggunakan OAuth 2.0
- Firebase Authentication mengintegrasikan Google Sign-In dengan mudah
- Error handling penting untuk user experience
- Testing di device/emulator yang berbeda

---

## 📚 Referensi

- [Google Sign-In Flutter Package](https://pub.dev/packages/google_sign_in)
- [Firebase Authentication](https://firebase.google.com/docs/auth)
- [OAuth 2.0](https://oauth.net/2/)

---

**Last Updated:** $(date)  
**Status:** ✅ Implemented
