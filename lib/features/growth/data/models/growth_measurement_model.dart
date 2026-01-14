import 'package:freezed_annotation/freezed_annotation.dart';

part 'growth_measurement_model.freezed.dart';
part 'growth_measurement_model.g.dart';

/// Model untuk pencatatan pertumbuhan (berat badan, tinggi badan, lingkar lengan)
@freezed
class GrowthMeasurementModel with _$GrowthMeasurementModel {
  const factory GrowthMeasurementModel({
    required String id,
    required String childId,
    required double weightKg, // berat badan dalam kg
    required double heightCm, // tinggi badan dalam cm
    double? armCircumferenceCm, // lingkar lengan dalam cm (opsional)
    required DateTime measurementDate,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _GrowthMeasurementModel;

  /// Hitung kategori status gizi berdasarkan WHO standards (placeholder)
  String getCategory() {
    // Placeholder: logika penentuan kategori bisa dikembangkan lebih lanjut
    return 'Normal';
  }

  factory GrowthMeasurementModel.fromJson(Map<String, dynamic> json) =>
      _$GrowthMeasurementModelFromJson(json);
}
