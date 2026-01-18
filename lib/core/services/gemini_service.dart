import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';

class GeminiService {
  // API Key baru Anda
  final String _apiKey = 'AIzaSyAuPK-7zvjDLD2x_UrJZDaYasc1M3yXgLI';

  late final GenerativeModel _model;

  GeminiService() {
    // Inisialisasi Model menggunakan SDK resmi
    // 'gemini-1.5-flash' adalah model yang cepat dan efisien
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      // Safety settings (opsional, defaultnya sudah aman)
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
      ],
    );
  }

  Future<String> sendMessage(String message) async {
    try {
      // Kita mulai chat baru dengan instruksi sistem di awal
      final chat = _model.startChat(
        history: [
          Content.text('''
        Instruksi Sistem:
        Kamu adalah "AIza", Asisten Gizi Sehat dari aplikasi GiziSehat.
        Tugasmu adalah menjawab pertanyaan orang tua seputar gizi anak, MPASI, pencegahan stunting, dan kesehatan ibu hamil.
        
        Gaya Bicara:
        - Ramah, empatik, dan menggunakan sapaan "Bunda" atau "Ayah".
        - Bahasa Indonesia yang baik tapi santai (tidak kaku).
        - Gunakan emoji sesekali agar ceria.
        
        Batasan:
        - Jika ada pertanyaan medis darurat (anak kejang, tidak sadar, demam sangat tinggi), WAJIB sarankan segera ke IGD/Dokter.
        - Jawablah dengan ringkas dan to the point (maksimal 3-4 paragraf pendek).
        '''),
          Content.model([
            TextPart(
              'Siap Bunda! Saya AIza mengerti tugas saya. Silakan tanya apa saja ya.',
            ),
          ]),
        ],
      );

      debugPrint('Mengirim pesan ke Gemini: $message');

      final response = await chat.sendMessage(Content.text(message));

      if (response.text != null) {
        return response.text!;
      } else {
        return 'Maaf Bunda, saya bingung. Bisa ulangi pertanyaannya?';
      }
    } catch (e) {
      debugPrint('Gemini SDK Error: $e');
      if (e.toString().contains('404') || e.toString().contains('not found')) {
        return 'Maaf, model AI sedang gangguan (Error 404). Silakan coba lagi nanti.';
      }
      return 'Yah, koneksi saya terganggu 😔. Coba periksa internet Bunda ya.';
    }
  }
}
