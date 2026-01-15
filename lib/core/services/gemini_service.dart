import 'package:google_generative_ai/google_generative_ai.dart';
import '../config/gemini_config.dart';

/// Service untuk komunikasi dengan Google Gemini AI
/// 
/// Service ini menghandle request ke Gemini API dan mengembalikan response
class GeminiService {
  /// Instance dari GenerativeModel
  late final GenerativeModel _model;

  /// Constructor - inisialisasi model dengan API key
  GeminiService() {
    _model = GenerativeModel(
      model: GeminiConfig.model,
      apiKey: GeminiConfig.apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 2048,
      ),
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
      ],
    );
  }

  /// Mengirim pesan ke Gemini AI dan mendapatkan response
  /// 
  /// [message] - Pesan yang akan dikirim ke AI
  /// [context] - Konteks tambahan untuk AI (opsional)
  /// 
  /// Returns: Response text dari AI
  /// Throws: Exception jika terjadi error
  Future<String> sendMessage(String message, {String? context}) async {
    try {
      // Tambahkan system prompt untuk fokus pada gizi anak
      final systemPrompt = context ?? 
          '''Kamu adalah Asisten Gizi Virtual untuk aplikasi GiziSehat. 
Fokus kamu adalah membantu orang tua dengan pertanyaan seputar gizi dan tumbuh kembang anak. 
Berikan jawaban yang akurat, mudah dipahami, dan praktis. 
Jika pertanyaan di luar kemampuan kamu atau memerlukan konsultasi medis, sarankan untuk berkonsultasi dengan dokter anak atau ahli gizi.''';

      final prompt = '$systemPrompt\n\nUser: $message\nAsisten:';
      
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text == null || response.text!.isEmpty) {
        return 'Maaf, saya tidak dapat memberikan jawaban saat ini. Silakan coba lagi.';
      }

      return response.text!;
    } catch (e) {
      // Handle error dengan message yang user-friendly
      if (e.toString().contains('API_KEY')) {
        return 'Error: API Key tidak valid. Pastikan API key sudah benar di gemini_config.dart';
      } else if (e.toString().contains('quota') || e.toString().contains('429')) {
        return 'Maaf, server sedang sibuk. Silakan coba beberapa saat lagi.';
      } else if (e.toString().contains('safety')) {
        return 'Maaf, pertanyaan Anda tidak dapat diproses karena alasan keamanan.';
      } else {
        return 'Maaf, terjadi kesalahan: ${e.toString()}';
      }
    }
  }

  /// Generate response dengan chat history (untuk context percakapan)
  /// 
  /// [messages] - List pesan sebelumnya (untuk context)
  /// [newMessage] - Pesan baru yang akan dikirim
  /// 
  /// Returns: Response text dari AI
  Future<String> sendMessageWithHistory(
    List<String> messages,
    String newMessage,
  ) async {
    try {
      final chat = _model.startChat(
        history: messages.map((msg) => Content.text(msg)).toList(),
      );

      final response = await chat.sendMessage(Content.text(newMessage));

      if (response.text == null || response.text!.isEmpty) {
        return 'Maaf, saya tidak dapat memberikan jawaban saat ini. Silakan coba lagi.';
      }

      return response.text!;
    } catch (e) {
      if (e.toString().contains('API_KEY')) {
        return 'Error: API Key tidak valid. Pastikan API key sudah benar di gemini_config.dart';
      } else if (e.toString().contains('quota') || e.toString().contains('429')) {
        return 'Maaf, server sedang sibuk. Silakan coba beberapa saat lagi.';
      } else {
        return 'Maaf, terjadi kesalahan: ${e.toString()}';
      }
    }
  }
}
