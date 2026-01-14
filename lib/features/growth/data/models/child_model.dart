import 'package:freezed_annotation/freezed_annotation.dart';

part 'child_model.freezed.dart';
part 'child_model.g.dart';

/// Model untuk data anak
@freezed
class ChildModel with _$ChildModel {
  const factory ChildModel({
    required String id,
    required String userId,
    required String name,
    required String gender, // 'male' atau 'female'
    required DateTime dateOfBirth,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _ChildModel;

  factory ChildModel.fromJson(Map<String, dynamic> json) =>
      _$ChildModelFromJson(json);
}
