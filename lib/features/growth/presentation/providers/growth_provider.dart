import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../providers/auth_provider.dart';
import '../data/models/growth_measurement_model.dart';
import '../data/repositories/growth_repository.dart';
import '../data/repositories/growth_repository_impl.dart';

/// Provider untuk Supabase client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provider untuk GrowthRepository
final growthRepositoryProvider = Provider<GrowthRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return GrowthRepositoryImpl(supabase);
});

/// Provider untuk fetch measurements berdasarkan child ID
final growthMeasurementsProvider =
    FutureProvider.family<List<GrowthMeasurementModel>, String>((ref, childId) async {
  final repository = ref.watch(growthRepositoryProvider);
  return repository.getChildMeasurements(childId);
});

/// Provider untuk fetch latest measurement berdasarkan child ID
final latestMeasurementProvider =
    FutureProvider.family<GrowthMeasurementModel?, String>((ref, childId) async {
  final repository = ref.watch(growthRepositoryProvider);
  return repository.getLatestMeasurement(childId);
});

/// State notifier untuk form input measurement
class MeasurementFormState {
  final bool isLoading;
  final String? error;
  final GrowthMeasurementModel? savedMeasurement;

  const MeasurementFormState({
    this.isLoading = false,
    this.error,
    this.savedMeasurement,
  });

  MeasurementFormState copyWith({
    bool? isLoading,
    String? error,
    GrowthMeasurementModel? savedMeasurement,
  }) {
    return MeasurementFormState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      savedMeasurement: savedMeasurement ?? this.savedMeasurement,
    );
  }
}

/// Notifier untuk mengelola form submission
class MeasurementFormNotifier extends StateNotifier<MeasurementFormState> {
  final GrowthRepository _repository;

  MeasurementFormNotifier(this._repository)
      : super(const MeasurementFormState());

  /// Simpan measurement baru
  Future<bool> saveMeasurement(GrowthMeasurementModel measurement) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final saved = await _repository.saveMeasurement(measurement);
      state = state.copyWith(isLoading: false, savedMeasurement: saved);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider untuk form state
final measurementFormProvider =
    StateNotifierProvider<MeasurementFormNotifier, MeasurementFormState>((ref) {
  final repository = ref.watch(growthRepositoryProvider);
  return MeasurementFormNotifier(repository);
});
