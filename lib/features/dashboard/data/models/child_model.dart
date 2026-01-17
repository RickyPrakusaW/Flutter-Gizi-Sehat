class ChildModel {
  final String id;
  final String name;
  final String gender; // 'Laki-laki' or 'Perempuan'
  final DateTime birthDate;
  final String status; // 'Normal', 'Berisiko', etc.

  ChildModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'birthDate': birthDate.toIso8601String(),
      'status': status,
    };
  }

  factory ChildModel.fromMap(Map<String, dynamic> map, String id) {
    return ChildModel(
      id: id,
      name: map['name'] ?? '',
      gender: map['gender'] ?? 'Laki-laki',
      birthDate: map['birthDate'] != null
          ? DateTime.parse(map['birthDate'])
          : DateTime.now(),
      status: map['status'] ?? 'Normal',
    );
  }

  String get ageString {
    final now = DateTime.now();
    final difference = now.difference(birthDate);
    final years = difference.inDays ~/ 365;
    final months = (difference.inDays % 365) ~/ 30;

    if (years > 0) {
      if (months > 0) {
        return '$years tahun $months bulan';
      }
      return '$years tahun';
    }
    return '$months bulan';
  }
}
