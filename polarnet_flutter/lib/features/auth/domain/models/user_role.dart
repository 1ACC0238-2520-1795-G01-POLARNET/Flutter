enum UserRole { provider, client }

extension UserRolex on UserRole {
  static UserRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'provider':
        return UserRole.provider;
      case 'client':
      default:
        return UserRole.client;
    }
  }

  String get name {
    switch (this) {
      case UserRole.provider:
        return 'provider';
      case UserRole.client:
        return 'client';
    }
  }
}
