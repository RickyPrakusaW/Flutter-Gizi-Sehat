/// Konfigurasi Supabase untuk aplikasi GiziSehat
/// Pastikan variabel lingkungan sudah diatur di file .env atau Supabase CLI

class SupabaseOptions {
  /// URL project Supabase dari variable lingkungan
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-supabase-url.supabase.co',
  );

  /// API Key Supabase publik dari variable lingkungan
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key',
  );

  /// Verifikasi konfigurasi sudah diatur dengan benar
  static bool get isConfigured {
    return supabaseUrl.isNotEmpty && 
           supabaseAnonKey.isNotEmpty &&
           !supabaseUrl.contains('your-supabase');
  }
}
