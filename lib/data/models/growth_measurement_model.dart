/// Model untuk data pemantauan pertumbuhan
/// Menyimpan pengukuran antropometri dan status gizi
import 'package:freezed_annotation/freezed_annotation.dart';

part 'growth_measurement_model.freezed.dart';
part 'growth_measurement_model.g.dart';

@freezed
class GrowthMeasurement with _$GrowthMeasurement {
  const factory GrowthMeasurement({
    required String id,
    required String childId,
    required DateTime measurementDate,
    required double weightKg,
    required double heightCm,
    double? armCircumferenceCm,
    double? weightForAgeZScore,
    double? heightForAgeZScore,
    double? weightForHeightZScore,
    String? nutritionalStatus,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _GrowthMeasurement;

  factory GrowthMeasurement.fromJson(Map<String, dynamic> json) =>
      _$GrowthMeasurementFromJson(json);
}
