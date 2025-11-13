import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polarnet_flutter/features/client/equipments/presentation/blocs/client_equipment_bloc.dart';
import 'package:polarnet_flutter/features/client/equipments/presentation/blocs/client_equipment_event.dart';
import 'package:polarnet_flutter/features/client/equipments/presentation/blocs/client_equipment_state.dart';
import 'package:polarnet_flutter/features/client/equipments/presentation/widgets/client_equipment_card.dart';
import 'package:polarnet_flutter/shared/domain/models/equipment.dart';
import 'package:polarnet_flutter/core/theme/app_colors.dart';

class ClientEquipmentsPage extends StatefulWidget {
  final int clientId;
  final Function(Equipment equipment, int clientId) onTapEquipmentCard;

  const ClientEquipmentsPage({
    super.key,
    required this.clientId,
    required this.onTapEquipmentCard,
  });

  @override
  State<ClientEquipmentsPage> createState() => _ClientEquipmentsPageState();
}

class _ClientEquipmentsPageState extends State<ClientEquipmentsPage> {
  @override
  void initState() {
    super.initState();
    
    // Recargar equipos cada vez que la pantalla se muestra
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadEquipments();
      }
    });
  }

  void _loadEquipments() {
    if (widget.clientId > 0) {
      context.read<ClientEquipmentBloc>().add(
            LoadClientEquipments(widget.clientId),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: BlocBuilder<ClientEquipmentBloc, ClientEquipmentState>(
        builder: (context, state) {
          final equipments = state.equipments;

          return Column(
            children: [
              // Header con gradiente
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark,
                      AppColors.primary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 48,
                  bottom: 32,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.devices_other,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mis Equipos',
                              style: textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '${equipments.length} equipos monitoreados',
                              style: textTheme.bodyMedium?.copyWith(
                                // ignore: deprecated_member_use
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        // TODO: Navegar a notificaciones
                      },
                    ),
                  ],
                ),
              ),

              // Contenido principal
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),

                      // Banner informativo
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: colorScheme.secondaryContainer,
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Gestión de Equipos',
                                      style: textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.onSecondaryContainer,
                                      ),
                                    ),
                                    Text(
                                      'Consulta tus equipos activos',
                                      style: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSecondaryContainer
                                            // ignore: deprecated_member_use
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              FilledButton.tonal(
                                onPressed: _loadEquipments,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.refresh, size: 18),
                                    const SizedBox(width: 4),
                                    const Text('Actualizar'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Encabezado de lista
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Equipos',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          if (equipments.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${equipments.length}',
                                style: textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Lista de equipos
                      Expanded(
                        child: _buildEquipmentsList(state),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEquipmentsList(ClientEquipmentState state) {
    if (state.status == ClientEquipmentStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == ClientEquipmentStatus.failure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: ${state.error ?? "Desconocido"}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadEquipments,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    final equipments = state.equipments;

    if (equipments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Column(
          children: [
            Icon(
              Icons.devices_other,
              size: 64,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  // ignore: deprecated_member_use
                  .withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay equipos registrados',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Agrega tu primer equipo para comenzar',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant
                        // ignore: deprecated_member_use
                        .withOpacity(0.7),
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: equipments.length,
      itemBuilder: (context, index) {
        final clientEquipment = equipments[index];
        final equipment = clientEquipment.equipment;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ClientEquipmentCard(
            clientEquipment: clientEquipment,
            onTap: () {
              if (equipment != null) {
                widget.onTapEquipmentCard(equipment, widget.clientId);
              }
            },
          ),
        );
      },
    );
  }
}
