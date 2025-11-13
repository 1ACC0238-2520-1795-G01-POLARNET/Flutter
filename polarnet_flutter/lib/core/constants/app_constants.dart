class AppConstants {
  // App Info
  static const String appName = 'PolarNet';
  static const String appVersion = '1.0.0';
  
  // User Types
  static const String userTypeClient = 'client';
  static const String userTypeProvider = 'provider';
  
  // Service Request Types
  static const String requestTypeRental = 'rental';
  static const String requestTypeMaintenance = 'maintenance';
  static const String requestTypeInstallation = 'installation';
  
  // Service Request Status
  static const String statusPending = 'pending';
  static const String statusInProgress = 'in_progress';
  static const String statusCompleted = 'completed';
  static const String statusCancelled = 'cancelled';
  
  // Local Storage Keys
  static const String keyUserId = 'user_id';
  static const String keyUserType = 'user_type';
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyIsLoggedIn = 'is_logged_in';
}
