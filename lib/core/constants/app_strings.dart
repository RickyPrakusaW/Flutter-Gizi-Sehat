/// Konstanta string aplikasi GiziSehat
/// Semua text hardcoded harus disimpan di sini untuk kemudahan maintenance
/// dan future localization
abstract class AppStrings {
  /// App Name
  static const String appName = 'GiziSehat';
  static const String appTagline = 'Solusi Digital Pencegahan Stunting';

  /// Authentication Strings
  static const String loginTitle = 'Masuk ke Akun Anda';
  static const String registerTitle = 'Buat Akun Baru';
  static const String emailLabel = 'Email';
  static const String passwordLabel = 'Kata Sandi';
  static const String confirmPasswordLabel = 'Konfirmasi Kata Sandi';
  static const String loginButton = 'Masuk';
  static const String registerButton = 'Daftar';
  static const String forgotPasswordLink = 'Lupa Kata Sandi?';
  static const String noAccountText = 'Belum punya akun? ';
  static const String alreadyHaveAccountText = 'Sudah punya akun? ';

  /// Navigation
  static const String homeNav = 'Beranda';
  static const String growthNav = 'Tumbuh';
  static const String nutritionNav = 'Gizi';
  static const String assistantNav = 'Asisten';
  static const String profileNav = 'Profil';

  /// Onboarding
  static const String onboardingSkip = 'Lewati';
  static const String onboardingNext = 'Lanjut';
  static const String onboardingStart = 'Mulai Sekarang';

  /// Dashboard
  static const String dashboardTitle = 'Beranda';
  static const String summaryTitle = 'Ringkasan Pertumbuhan';
  static const String tipsTitle = 'Tips Gizi Harian';

  /// Growth Tracking
  static const String growthTitle = 'Pemantauan Pertumbuhan';
  static const String inputHeight = 'Tinggi Badan (cm)';
  static const String inputWeight = 'Berat Badan (kg)';
  static const String inputArmCircumference = 'Lingkar Lengan Atas (cm)';

  /// Profile
  static const String profileTitle = 'Profil';
  static const String childDataLabel = 'Data Anak';
  static const String parentDataLabel = 'Data Orang Tua';
  static const String darkModeLabel = 'Mode Gelap';
  static const String notificationLabel = 'Notifikasi';
  static const String languageLabel = 'Bahasa';
  static const String logoutButton = 'Keluar';

  /// Health Services
  static const String healthServicesTitle = 'Layanan Kesehatan';
  static const String puskesmasLabel = 'Puskesmas';
  static const String posyanduLabel = 'Posyandu';
  static const String hospitalLabel = 'Rumah Sakit';

  /// AI Assistant
  static const String assistantTitle = 'Asisten Gizi';
  static const String askQuestion = 'Tanya sesuatu...';

  /// Common
  static const String loading = 'Memuat...';
  static const String error = 'Terjadi kesalahan';
  static const String retry = 'Coba Lagi';
  static const String back = 'Kembali';
  static const String save = 'Simpan';
  static const String cancel = 'Batal';
  static const String success = 'Berhasil';
}
