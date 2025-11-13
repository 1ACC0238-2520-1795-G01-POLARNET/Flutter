import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import 'package:polarnet_flutter/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:polarnet_flutter/features/auth/presentation/blocs/auth_state.dart';
import 'package:polarnet_flutter/features/client/home/presentation/blocs/equipment_bloc.dart';
import 'package:polarnet_flutter/features/client/home/presentation/blocs/equipment_event.dart';
import 'package:polarnet_flutter/features/client/home/presentation/blocs/equipment_state.dart';
import 'package:polarnet_flutter/features/client/home/presentation/pages/equipment_detail.dart';
import 'package:polarnet_flutter/features/client/home/presentation/widgets/equipment_card.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  State<ClientHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<ClientHomePage> {
  @override
  void initState() {
    super.initState();
    
    // Usar PostFrameCallback para evitar acceso al context antes de que esté listo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        try {
          context.read<EquipmentBloc>().add(LoadEquipments());
        } catch (e, stack) {
          developer.log(
            '❌ [CLIENT HOME] Error al cargar equipos: $e',
            name: 'PolarNet',
            error: e,
            stackTrace: stack,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipos Disponibles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<EquipmentBloc, EquipmentState>(
        builder: (context, state) {
          if (state.status == EquipmentStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == EquipmentStatus.failure) {
            return Center(
              child: Text('Error: ${state.error ?? "Error al cargar equipos"}'),
            );
          }

          if (state.equipments.isEmpty) {
            developer.log(
              '📭 [CLIENT HOME] No hay equipos disponibles',
              name: 'PolarNet',
            );
            return const Center(child: Text('No hay equipos disponibles.'));
          }

          developer.log(
            '✅ [CLIENT HOME] Mostrando ${state.equipments.length} equipos',
            name: 'PolarNet',
          );
          
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              itemCount: state.equipments.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final equipment = state.equipments[index];
                return EquipmentCard(
                  equipment: equipment,
                  onTap: () {
                    developer.log(
                      '👆 [CLIENT HOME] Tap en equipo: ${equipment.name} (ID: ${equipment.id})',
                      name: 'PolarNet',
                    );
                    
                    // Obtener el usuario actual del AuthBloc
                    final authState = context.read<AuthBloc>().state;
                    if (authState is AuthAuthenticated) {
                      developer.log(
                        '🚀 [CLIENT HOME] Navegando a detalle - ClientId: ${authState.user.id}',
                        name: 'PolarNet',
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EquipmentDetailPage(
                            equipment: equipment,
                            clientId: authState.user.id ?? 0,
                          ),
                        ),
                      );
                    } else {
                      developer.log(
                        '⚠️ [CLIENT HOME] Usuario no autenticado',
                        name: 'PolarNet',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Debes iniciar sesión'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
