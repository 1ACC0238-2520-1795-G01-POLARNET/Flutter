import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as developer;
import '../../../../core/constants/api_constants.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal() {
    developer.log('🏗️ SupabaseService: Constructor llamado', name: 'PolarNet');    
  }

  late final SupabaseClient client;

  Future<void> initialize() async {
    developer.log('🔧 SupabaseService: Iniciando initialize()...', name: 'PolarNet');    
    
    await Supabase.initialize(
      url: ApiConstants.supabaseUrl,
      anonKey: ApiConstants.supabaseAnonKey,
    );
    
    developer.log('🔧 SupabaseService: Supabase.initialize completado', name: 'PolarNet');    
    
    client = Supabase.instance.client;
    
    developer.log('✅ SupabaseService: Cliente asignado', name: 'PolarNet');
    
  }

  SupabaseClient get supabase => client;
}
