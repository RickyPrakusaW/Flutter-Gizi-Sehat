import '../models/user_model.dart';

class RoleService {
  // Mock current user for dev/demo purposes until Auth is fully integrated
  static UserModel? _currentUser;

  static void setUser(UserModel user) {
    _currentUser = user;
  }

  static UserModel? get currentUser => _currentUser;

  static bool get isDoctor => _currentUser?.role == UserRole.doctor;
  static bool get isParent => _currentUser?.role == UserRole.parent;
  static bool get isKader => _currentUser?.role == UserRole.kader;
  static bool get isAdmin => _currentUser?.role == UserRole.admin;

  static List<String> getAccessibleFeatures(UserRole role) {
    switch (role) {
      case UserRole.parent:
        return [
          'growth_tracking',
          'nutrition_schedule',
          'marketplace',
          'consultation',
        ];
      case UserRole.doctor:
        return ['patient_list', 'consultation_chat', 'prescription'];
      case UserRole.kader:
        return ['community_dashboard', 'input_data'];
      case UserRole.admin:
        return ['all'];
    }
  }
}
