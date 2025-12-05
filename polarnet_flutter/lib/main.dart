import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polarnet_flutter/features/inventory/data/remote/equipment_service.dart';
import 'package:polarnet_flutter/features/inventory/data/repositories/equipment_repository_impl.dart';
import 'package:polarnet_flutter/features/inventory/domain/repositories/equipment_repository.dart';
import 'package:polarnet_flutter/features/dashboard/data/remote/iot_service.dart';
import 'package:polarnet_flutter/features/dashboard/data/repositories/iot_repository_impl.dart';
import 'package:polarnet_flutter/features/dashboard/domain/repositories/iot_repository.dart';
import 'package:polarnet_flutter/features/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:polarnet_flutter/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:polarnet_flutter/features/add/data/remote/add_equipment_service.dart';
import 'package:polarnet_flutter/features/add/data/repositories/add_equipment_repository_impl.dart';
import 'package:polarnet_flutter/features/add/domain/repositories/add_equipment_repository.dart';
import 'package:polarnet_flutter/features/add/presentation/blocs/add_equipment_bloc.dart';
import 'package:polarnet_flutter/features/home/data/remote/provider_home_service.dart';
import 'package:polarnet_flutter/features/home/data/repositories/provider_home_repository_impl.dart';
import 'package:polarnet_flutter/features/home/domain/repositories/provider_home_repository.dart';
import 'package:polarnet_flutter/features/home/presentation/blocs/provider_home_bloc.dart';
import 'package:polarnet_flutter/features/inventory/presentation/blocs/provider_inventory_bloc.dart';
import 'package:polarnet_flutter/features/alerts/data/remote/alert_service.dart';
import 'package:polarnet_flutter/features/alerts/data/repositories/alert_repository_impl.dart';
import 'package:polarnet_flutter/features/alerts/domain/repositories/alert_repository.dart';
import 'package:polarnet_flutter/features/alerts/presentation/blocs/alert_bloc.dart';
import 'package:polarnet_flutter/features/notification/data/remote/notification_service.dart';
import 'package:polarnet_flutter/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:polarnet_flutter/features/notification/domain/repositories/notification_repository.dart';
import 'package:polarnet_flutter/features/notification/presentation/blocs/notification_bloc.dart';
import 'package:polarnet_flutter/main/main_provider_page.dart';
import 'dart:developer' as developer;
import 'core/theme/app_theme.dart';
import 'core/services/supabase_service.dart';
import 'core/services/local_storage_service.dart';
import 'core/database/app_database.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
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
    final alertService = AlertService();
    final notificationService = NotificationService();
    final iotRepository = IoTRepositoryImpl(
      IoTService(),
      alertService,
      notificationService,
    );
    final equipmentRepository = EquipmentRepositoryImpl(EquipmentService());
    final addEquipmentRepository = AddEquipmentRepositoryImpl(
      AddEquipmentService(),
    );
    final providerHomeRepository = ProviderHomeRepositoryImpl(
      ProviderHomeService(),
    );
    final alertRepository = AlertRepositoryImpl(alertService);
    final notificationRepository = NotificationRepositoryImpl(
      notificationService,
    );

    runApp(
      MyApp(
        supabaseService: supabaseService,
        localStorage: localStorage,
        database: database,
        equipmentRepository: equipmentRepository,
        addEquipmentRepository: addEquipmentRepository,
        alertRepository: alertRepository,
        notificationRepository: notificationRepository,
        providerHomeRepository: providerHomeRepository,
        iotRepository: iotRepository,
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
  final IoTRepository iotRepository;
  final EquipmentRepository equipmentRepository;
  final AddEquipmentRepository addEquipmentRepository;
  final ProviderHomeRepository providerHomeRepository;
  final AlertRepository alertRepository;
  final NotificationRepository notificationRepository;

  const MyApp({
    super.key,
    required this.supabaseService,
    required this.localStorage,
    required this.database,
    required this.equipmentRepository,
    required this.addEquipmentRepository,
    required this.providerHomeRepository,
    required this.iotRepository,
    required this.alertRepository,
    required this.notificationRepository,
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
          create: (context) => ProfileBloc(AuthLocalDataSourceImpl(database)),
        ),
        BlocProvider(
          create: (context) => AddEquipmentBloc(addEquipmentRepository),
        ),
        BlocProvider(
          create: (context) => ProviderHomeBloc(providerHomeRepository),
        ),
        BlocProvider(
          create: (context) => ProviderInventoryBloc(equipmentRepository),
        ),
        BlocProvider(create: (context) => IoTBloc(iotRepository)),
        BlocProvider(create: (context) => AlertBloc(alertRepository)),
        BlocProvider(
          create: (context) => NotificationBloc(notificationRepository),
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
                '🏠 [MAIN] Navegando a MainProviderPage',
                name: 'PolarNet',
              );
              return const MainProviderPage();
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
