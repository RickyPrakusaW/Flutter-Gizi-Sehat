/// Konfigurasi inisialisasi Supabase untuk aplikasi GiziSehat
/// Memanggil fungsi ini di main() sebelum runApp()
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_options.dart';

/// Menginisialisasi Supabase dengan konfigurasi yang tepat
Future<void> initializeSupabase() async {
  try {
    await Supabase.initialize(
      url: SupabaseOptions.supabaseUrl,
      anonKey: SupabaseOptions.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        autoRefreshToken: true,
      ),
    );

    if (kDebugMode) {
      print('[Supabase] Berhasil diinisialisasi');
    }
  } catch (e) {
    if (kDebugMode) {
      print('[Supabase Error] $e');
    }
    rethrow;
  }
}
