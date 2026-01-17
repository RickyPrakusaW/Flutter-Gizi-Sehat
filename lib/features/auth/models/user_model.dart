enum UserRole { parent, doctor, kader, admin }

enum UserStatus { active, pending, rejected }

class UserModel {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? profileImage;
  final UserStatus status;
  final String? proofUrl;
  final String? title; // Gelar dokter
  final String? specialist; // Spesialisasi
  final String? strNumber; // Nomor STR
  final String? sipNumber; // Nomor SIP
  final String? practiceLocation; // Lokasi Praktik
  final String? alumni; // Alumni Universitas
  final int? experienceYear; // Tahun Pengalaman (angka)

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.role = UserRole.parent,
    this.profileImage,
    this.status = UserStatus.active,
    this.proofUrl,
    this.title,
    this.specialist,
    this.strNumber,
    this.sipNumber,
    this.practiceLocation,
    this.alumni,
    this.experienceYear,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.name == (json['role'] ?? 'parent'),
        orElse: () => UserRole.parent,
      ),
      profileImage: json['profile_image'] as String?,
      status: UserStatus.values.firstWhere(
        (e) => e.name == (json['status'] ?? 'active'),
        orElse: () => UserStatus.active,
      ),
      proofUrl: json['proof_url'] as String?,
      title: json['title'] as String?,
      specialist: json['specialist'] as String?,
      strNumber: json['str_number'] as String?,
      sipNumber: json['sip_number'] as String?,
      practiceLocation: json['practice_location'] as String?,
      alumni: json['alumni'] as String?,
      experienceYear: json['experience_year'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.name,
      'profile_image': profileImage,
      'status': status.name,
      'proof_url': proofUrl,
      'title': title,
      'specialist': specialist,
      'str_number': strNumber,
      'sip_number': sipNumber,
      'practice_location': practiceLocation,
      'alumni': alumni,
      'experience_year': experienceYear,
    };
  }
}
