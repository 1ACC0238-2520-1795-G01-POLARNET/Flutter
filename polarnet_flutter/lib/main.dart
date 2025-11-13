import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polarnet_flutter/features/client/home/data/remote/services/equipment_service.dart';
import 'package:polarnet_flutter/features/client/home/data/repositories/equipment_repository_impl.dart';
import 'package:polarnet_flutter/features/client/home/domain/repositories/equipment_repository.dart';
import 'package:polarnet_flutter/features/client/home/presentation/blocs/equipment_bloc.dart';
import 'package:polarnet_flutter/features/client/equipments/data/remote/services/client_equipment_service.dart';
import 'package:polarnet_flutter/features/client/equipments/data/repositories/client_equipment_repository_impl.dart';
import 'package:polarnet_flutter/features/client/equipments/domain/repositories/client_equipment_repository.dart';
import 'package:polarnet_flutter/features/client/equipments/presentation/blocs/client_equipment_bloc.dart';
import 'package:polarnet_flutter/features/client/services/data/remote/service_request_service.dart';
import 'package:polarnet_flutter/features/client/services/data/repositories/service_request_repository_impl.dart';
import 'package:polarnet_flutter/features/client/services/domain/repositories/service_request_repository.dart';
import 'package:polarnet_flutter/features/client/services/presentation/blocs/service_request_bloc.dart';
import 'package:polarnet_flutter/shared/profile/presentation/blocs/profile_bloc.dart';
import 'package:polarnet_flutter/features/provider/add/data/remote/add_equipment_service.dart';
import 'package:polarnet_flutter/features/provider/add/data/repositories/add_equipment_repository_impl.dart';
import 'package:polarnet_flutter/features/provider/add/domain/repositories/add_equipment_repository.dart';
import 'package:polarnet_flutter/features/provider/add/presentation/blocs/add_equipment_bloc.dart';
import 'package:polarnet_flutter/features/provider/home/data/remote/provider_home_service.dart';
import 'package:polarnet_flutter/features/provider/home/data/repositories/provider_home_repository_impl.dart';
import 'package:polarnet_flutter/features/provider/home/domain/repositories/provider_home_repository.dart';
import 'package:polarnet_flutter/features/provider/home/presentation/blocs/provider_home_bloc.dart';
import 'package:polarnet_flutter/features/provider/inventory/presentation/blocs/provider_inventory_bloc.dart';
import 'package:polarnet_flutter/main/main_client_page.dart';
import 'package:polarnet_flutter/main/main_provider_page.dart';
import 'dart:developer' as developer;
import 'core/theme/app_theme.dart';
import 'core/services/supabase_service.dart';
import 'core/services/local_storage_service.dart';
import 'core/database/app_database.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/domain/models/user_role.dart';
import 'features/auth/presentation/blocs/auth_bloc.dart';
import 'features/auth/presentation/blocs/auth_event.dart';
import 'features/auth/presentation/blocs/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    developer.log('🔴 FLUTTER ERROR: ${details.exception}', name: 'PolarNet');
    developer.log('🔴 STACK TRACE: ${details.stack}', name: 'PolarNet');
  };

  try {
    developer.log('🚀 Iniciando aplicación PolarNet...', name: 'PolarNet');

    // Initialize services
    developer.log('📡 Inicializando Supabase...', name: 'PolarNet');

    final supabaseService = SupabaseService();
    await supabaseService.initialize();
    developer.log('✅ Supabase inicializado', name: 'PolarNet');

    developer.log('💾 Inicializando LocalStorage...', name: 'PolarNet');

    final localStorage = LocalStorageService();
    await localStorage.initialize();
    developer.log('✅ LocalStorage inicializado', name: 'PolarNet');

    final database = AppDatabase();
    developer.log('✅ Database inicializado', name: 'PolarNet');

    developer.log('🎯 Lanzando app...', name: 'PolarNet');

    final equipmentReository = EquipmentRepositoryImpl(EquipmentService());
    final clientEquipmentRepository = ClientEquipmentRepositoryImpl(
      ClientEquipmentService(),
    );
    final serviceRequestRepository = ServiceRequestRepositoryImpl(
      ServiceRequestService(),
    );
    final addEquipmentRepository = AddEquipmentRepositoryImpl(
      AddEquipmentService(),
    );
    final providerHomeRepository = ProviderHomeRepositoryImpl(
      ProviderHomeService(),
    );

    runApp(
      MyApp(
        supabaseService: supabaseService,
        localStorage: localStorage,
        database: database,
        equipmentRepository: equipmentReository,
        clientEquipmentRepository: clientEquipmentRepository,
        serviceRequestRepository: serviceRequestRepository,
        addEquipmentRepository: addEquipmentRepository,
        providerHomeRepository: providerHomeRepository,
      ),
    );
  } catch (e, stackTrace) {
    developer.log(
      '🔴 ERROR CRÍTICO EN MAIN: $e',
      name: 'PolarNet',
      error: e,
      stackTrace: stackTrace,
    );

    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Error al inicializar la aplicación',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    e.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final SupabaseService supabaseService;
  final LocalStorageService localStorage;
  final AppDatabase database;
  final EquipmentRepository equipmentRepository;
  final ClientEquipmentRepository clientEquipmentRepository;
  final ServiceRequestRepository serviceRequestRepository;
  final AddEquipmentRepository addEquipmentRepository;
  final ProviderHomeRepository providerHomeRepository;

  const MyApp({
    super.key,
    required this.supabaseService,
    required this.localStorage,
    required this.database,
    required this.equipmentRepository,
    required this.clientEquipmentRepository,
    required this.serviceRequestRepository,
    required this.addEquipmentRepository,
    required this.providerHomeRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final bloc = AuthBloc(
              remoteDataSource: AuthRemoteDataSourceImpl(supabaseService),
              localDataSource: AuthLocalDataSourceImpl(database),
              localStorage: localStorage,
            );

            bloc.add(CheckAuthStatusEvent());
            return bloc;
          },
        ),
        BlocProvider(
          create: (context) => EquipmentBloc(repository: equipmentRepository),
        ),
        BlocProvider(
          create: (context) => ClientEquipmentBloc(
            repository: clientEquipmentRepository,
          ),
        ),
        BlocProvider(
          create: (context) => ServiceRequestBloc(
            serviceRequestRepository,
          ),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(
            AuthLocalDataSourceImpl(database),
          ),
        ),
        BlocProvider(
          create: (context) => AddEquipmentBloc(
            addEquipmentRepository,
          ),
        ),
        BlocProvider(
          create: (context) => ProviderHomeBloc(
            providerHomeRepository,
          ),
        ),
        BlocProvider(
          create: (context) => ProviderInventoryBloc(
            equipmentRepository,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'PolarNet',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            developer.log(
              '🏠 [MAIN] BlocBuilder - Estado actual: ${state.runtimeType}',
              name: 'PolarNet',
            );

            if (state is AuthLoading || state is AuthInitial) {
              developer.log(
                '⏳ [MAIN] Mostrando CircularProgressIndicator',
                name: 'PolarNet',
              );
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (state is AuthAuthenticated) {
              developer.log(
                '✅ [MAIN] Usuario autenticado: ${state.user.email}',
                name: 'PolarNet',
              );
              developer.log(
                '👤 [MAIN] Rol del usuario: ${state.user.role}',
                name: 'PolarNet',
              );
              
              if (state.user.role == UserRole.client) {
                developer.log(
                  '🏠 [MAIN] Navegando a MainClientPage',
                  name: 'PolarNet',
                );
                return const MainClientPage();
              } else if (state.user.role == UserRole.provider) {
                developer.log(
                  '🏠 [MAIN] Navegando a MainProviderPage',
                  name: 'PolarNet',
                );
                return const MainProviderPage();
              } else {
                developer.log(
                  '⚠️ [MAIN] Rol desconocido: ${state.user.role}',
                  name: 'PolarNet',
                );
              }
            }

            if (state is AuthError) {
              developer.log(
                '❌ [MAIN] Error de autenticación: ${state.message}',
                name: 'PolarNet',
              );
            }

            developer.log(
              '🔙 [MAIN] Mostrando LoginPage (estado: ${state.runtimeType})',
              name: 'PolarNet',
            );
            return const LoginPage();
          },
        ),
      ),
    );
  }
}
