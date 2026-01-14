/// Model untuk data pengguna (orang tua)
/// Digunakan untuk menyimpan dan mengelola data profil pengguna
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String userId,
    required String fullName,
    String? phoneNumber,
    DateTime? birthDate,
    String? address,
    String? city,
    String? province,
    String? postalCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
