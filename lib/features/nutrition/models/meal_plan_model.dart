enum MealType { breakfast, selenium, lunch, snack, dinner, other }

class MealPlanModel {
  final String id;
  final MealType type;
  final String title;
  final String description;
  final int calories;
  final bool isCompleted;
  final DateTime time;

  MealPlanModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.calories,
    this.isCompleted = false,
    required this.time,
  });

  String get timeFormatted {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }
}
