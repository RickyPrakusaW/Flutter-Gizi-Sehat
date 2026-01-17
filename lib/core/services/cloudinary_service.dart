import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class CloudinaryService {
  // Konfigurasi Cloudinary
  final String _cloudName = 'dxdjtj4xr';
  final String _uploadPreset =
      'stunting_app'; // Sesuai screenshot Anda (Unsigned)

  Future<String?> uploadImage(File imageFile) async {
    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
    );

    try {
      final request = http.MultipartRequest('POST', url);

      // Tambahkan file
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      // Tambahkan upload preset (Wajib untuk Unsigned upload)
      request.fields['upload_preset'] = _uploadPreset;

      // Kirim request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // Ambil URL aman (https)
        final String secureUrl = jsonResponse['secure_url'];
        debugPrint('Cloudinary Upload Success: $secureUrl');
        return secureUrl;
      } else {
        debugPrint('Cloudinary Upload Failed: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
        throw Exception(
          'Gagal upload ke Cloudinary. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Cloudinary Error: $e');
      rethrow;
    }
  }
}
