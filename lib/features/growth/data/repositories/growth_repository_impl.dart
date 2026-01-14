import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/growth_measurement_model.dart';
import 'growth_repository.dart';

/// Implementasi GrowthRepository menggunakan Supabase
class GrowthRepositoryImpl implements GrowthRepository {
  final SupabaseClient supabase;

  GrowthRepositoryImpl(this.supabase);

  static const String _tableName = 'growth_measurements';

  @override
  Future<List<GrowthMeasurementModel>> getChildMeasurements(String childId) async {
    try {
      final response = await supabase
          .from(_tableName)
          .select()
          .eq('child_id', childId)
          .order('measurement_date', ascending: false);

      return (response as List)
          .map((item) => GrowthMeasurementModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Error fetching measurements: $e');
    }
  }

  @override
  Future<GrowthMeasurementModel?> getLatestMeasurement(String childId) async {
    try {
      final response = await supabase
          .from(_tableName)
          .select()
          .eq('child_id', childId)
          .order('measurement_date', ascending: false)
          .limit(1)
          .single();

      return GrowthMeasurementModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<GrowthMeasurementModel> saveMeasurement(
    GrowthMeasurementModel measurement,
  ) async {
    try {
      final response = await supabase
          .from(_tableName)
          .insert(measurement.toJson())
          .select()
          .single();

      return GrowthMeasurementModel.fromJson(response);
    } catch (e) {
      throw Exception('Error saving measurement: $e');
    }
  }

  @override
  Future<void> updateMeasurement(GrowthMeasurementModel measurement) async {
    try {
      await supabase
          .from(_tableName)
          .update(measurement.toJson())
          .eq('id', measurement.id);
    } catch (e) {
      throw Exception('Error updating measurement: $e');
    }
  }

  @override
  Future<void> deleteMeasurement(String measurementId) async {
    try {
      await supabase.from(_tableName).delete().eq('id', measurementId);
    } catch (e) {
      throw Exception('Error deleting measurement: $e');
    }
  }
}
