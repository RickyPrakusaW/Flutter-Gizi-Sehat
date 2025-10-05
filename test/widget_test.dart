import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gizi_sehat_mobile_app/main.dart';

void main() {
  testWidgets('Flow: Onboarding -> LoginScreen', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const GiziSehatApp());

    // Halaman Onboarding harus tampil, tombol "Lanjut" ada
    expect(find.text('Lanjut'), findsOneWidget);

    // Tap "Lanjut" dua kali untuk ke slide terakhir (sesuaikan jumlah slide kamu)
    await tester.tap(find.text('Lanjut'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Lanjut'));
    await tester.pumpAndSettle();

    // Di slide terakhir, tombol berubah menjadi "Mulai Sekarang"
    expect(find.text('Mulai Sekarang'), findsOneWidget);

    // Tap "Mulai Sekarang" -> pindah ke LoginScreen
    await tester.tap(find.text('Mulai Sekarang'));
    await tester.pumpAndSettle();

    // Verifikasi elemen khas LoginScreen
    expect(find.text('Masuk ke Akun Anda'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Masuk'), findsOneWidget);
  });
}
