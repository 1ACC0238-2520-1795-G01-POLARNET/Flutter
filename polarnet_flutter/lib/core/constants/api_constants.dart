class ApiConstants {
  // Supabase Configuration
  static const String supabaseUrl = 'https://ivbtkzjqjjblwcokutkk.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml2YnRrempxampibHdjb2t1dGtrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk3ODU5MDQsImV4cCI6MjA3NTM2MTkwNH0.pWyezcw8v9rwFfeSlhIBcqcN3isZvOMhCvrf83HggsA';
  
  // API Endpoints - Supabase Tables
  static const String usersTable = 'users';
  static const String equipmentTable = 'equipment';
  static const String serviceRequestsTable = 'service_requests';
  static const String clientEquipmentTable = 'client_equipment';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

