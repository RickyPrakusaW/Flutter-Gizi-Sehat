enum ChildGender { male, female }

class GrowthRecord {
  final String id;
  final String childId;
  final DateTime date;
  final int ageInMonths;
  final double weight;
  final double height;
  final String? notes;

  GrowthRecord({
    required this.id,
    required this.childId,
    required this.date,
    required this.ageInMonths,
    required this.weight,
    required this.height,
    this.notes,
  });

  factory GrowthRecord.fromJson(Map<String, dynamic> json) {
    return GrowthRecord(
      id: json['id'] as String,
      childId: json['child_id'] as String,
      date: DateTime.parse(json['date'] as String),
      ageInMonths: json['age_in_months'] as int,
      weight: (json['weight'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'child_id': childId,
      'date': date.toIso8601String(),
      'age_in_months': ageInMonths,
      'weight': weight,
      'height': height,
      'notes': notes,
    };
  }
}
