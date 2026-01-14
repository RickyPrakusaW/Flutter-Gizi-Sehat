/// Model untuk data anak
/// Menyimpan informasi dasar dan identitas anak
import 'package:freezed_annotation/freezed_annotation.dart';

part 'child_model.freezed.dart';
part 'child_model.g.dart';

@freezed
class Child with _$Child {
  const factory Child({
    required String id,
    required String parentId,
    required String fullName,
    required DateTime birthDate,
    String? gender,
    String? bloodType,
    String? birthCertificateNumber,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Child;

  factory Child.fromJson(Map<String, dynamic> json) =>
      _$ChildFromJson(json);
}
