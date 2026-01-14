import '../models/growth_measurement_model.dart';

/// Repository abstract untuk growth tracking
abstract class GrowthRepository {
  /// Fetch semua measurements untuk seorang anak
  Future<List<GrowthMeasurementModel>> getChildMeasurements(String childId);

  /// Fetch measurement terakhir untuk seorang anak
  Future<GrowthMeasurementModel?> getLatestMeasurement(String childId);

  /// Simpan measurement baru
  Future<GrowthMeasurementModel> saveMeasurement(
    GrowthMeasurementModel measurement,
  );

  /// Update measurement yang sudah ada
  Future<void> updateMeasurement(GrowthMeasurementModel measurement);

  /// Hapus measurement
  Future<void> deleteMeasurement(String measurementId);
}
