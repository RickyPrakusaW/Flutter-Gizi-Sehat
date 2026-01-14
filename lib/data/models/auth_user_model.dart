/// Model untuk user profile yang tersimpan di Supabase database
/// Berbeda dengan AuthUserData yang berasal dari auth session
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user_model.freezed.dart';
part 'auth_user_model.g.dart';

@freezed
class AuthUserModel with _$AuthUserModel {
  const factory AuthUserModel({
    required String id, // uid dari auth
    required String email,
    String? fullName,
    String? photoUrl,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AuthUserModel;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserModelFromJson(json);
}
