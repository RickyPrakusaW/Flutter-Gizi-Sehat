import 'package:freezed_annotation/freezed_annotation.dart';

part 'nutrition_plan_model.freezed.dart';
part 'nutrition_plan_model.g.dart';

/// Model untuk rencana gizi (meal plan)
@freezed
class NutritionPlanModel with _$NutritionPlanModel {
  const factory NutritionPlanModel({
    required String id,
    required String childId,
    required String title,
    required String description,
    required List<String> ingredients,
    required String instructions,
    required Map<String, dynamic> nutrition, // protein, carbs, fat, calories
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _NutritionPlanModel;

  factory NutritionPlanModel.fromJson(Map<String, dynamic> json) =>
      _$NutritionPlanModelFromJson(json);
}
