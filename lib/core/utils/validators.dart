/// Utility untuk validasi input data
/// Digunakan di form login, register, dan input data pertumbuhan
class Validators {
  /// Validasi email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    
    return null;
  }

  /// Validasi password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kata sandi tidak boleh kosong';
    }
    
    if (value.length < 8) {
      return 'Kata sandi minimal 8 karakter';
    }
    
    return null;
  }

  /// Validasi konfirmasi password
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi kata sandi tidak boleh kosong';
    }
    
    if (value != password) {
      return 'Kata sandi tidak cocok';
    }
    
    return null;
  }

  /// Validasi berat badan (dalam kg)
  static String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Berat badan tidak boleh kosong';
    }
    
    final weight = double.tryParse(value);
    if (weight == null || weight <= 0 || weight > 100) {
      return 'Berat badan harus antara 0-100 kg';
    }
    
    return null;
  }

  /// Validasi tinggi badan (dalam cm)
  static String? validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tinggi badan tidak boleh kosong';
    }
    
    final height = double.tryParse(value);
    if (height == null || height <= 0 || height > 200) {
      return 'Tinggi badan harus antara 0-200 cm';
    }
    
    return null;
  }

  /// Validasi lingkar lengan atas (dalam cm)
  static String? validateArmCircumference(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lingkar lengan atas tidak boleh kosong';
    }
    
    final circumference = double.tryParse(value);
    if (circumference == null || circumference <= 0 || circumference > 50) {
      return 'Lingkar lengan atas harus antara 0-50 cm';
    }
    
    return null;
  }
}
