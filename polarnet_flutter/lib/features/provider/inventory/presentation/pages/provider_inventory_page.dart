import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polarnet_flutter/features/provider/inventory/presentation/blocs/provider_inventory_bloc.dart';
import 'package:polarnet_flutter/features/provider/inventory/presentation/blocs/provider_inventory_event.dart';
import 'package:polarnet_flutter/features/provider/inventory/presentation/blocs/provider_inventory_state.dart';
import 'package:polarnet_flutter/features/provider/inventory/presentation/widgets/equipment_inventory_card.dart';
import 'package:polarnet_flutter/features/provider/inventory/presentation/widgets/quick_stat_card.dart';

class ProviderInventoryPage extends StatefulWidget {
  final int providerId;

  const ProviderInventoryPage({
    super.key,
    required this.providerId,
  });

  @override
  State<ProviderInventoryPage> createState() => _ProviderInventoryPageState();
}

class _ProviderInventoryPageState extends State<ProviderInventoryPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<ProviderInventoryBloc>()
        .add(LoadProviderEquipments(widget.providerId));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<ProviderInventoryBloc, ProviderInventoryState>(
      builder: (context, state) {
        final equipments = state.filteredEquipments;
        final categories = state.categories;

        return Column(
          children: [
            // Header con gradiente
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primaryContainer,
                    colorScheme.tertiary,
                  ],
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.inventory,
                        color: colorScheme.onPrimary,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mi Inventario',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onPrimary,
                                ),
                          ),
                          Text(
                            '${equipments.length} equipos totales',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  // ignore: deprecated_member_use
                                  color: colorScheme.onPrimary.withOpacity(0.9),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      context
                          .read<ProviderInventoryBloc>()
                          .add(RefreshProviderEquipments(widget.providerId));
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: colorScheme.onPrimary,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            // Filtros
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filtro de disponibilidad
                  Material(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: state.showOnlyAvailable
                            // ignore: deprecated_member_use
                            ? Colors.green.withOpacity(0.5)
                            // ignore: deprecated_member_use
                            : colorScheme.outline.withOpacity(0.5),
                      ),
                    ),
                    color: state.showOnlyAvailable
                        // ignore: deprecated_member_use
                        ? Colors.green.withOpacity(0.1)
                        : colorScheme.surfaceContainerHighest,
                    child: InkWell(
                      onTap: () {
                        context
                            .read<ProviderInventoryBloc>()
                            .add(ToggleAvailabilityFilter());
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  state.showOnlyAvailable
                                      ? Icons.check_circle
                                      : Icons.filter_alt,
                                  color: state.showOnlyAvailable
                                      ? Colors.green
                                      : colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Mostrar solo disponibles',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                            Switch(
                              value: state.showOnlyAvailable,
                              onChanged: (_) {
                                context
                                    .read<ProviderInventoryBloc>()
                                    .add(ToggleAvailabilityFilter());
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Filtro por categorías
                  if (categories.isNotEmpty) ...[
                    Text(
                      'Categorías',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterChip(
                            selected: state.selectedCategory == 'all',
                            onSelected: (_) {
                              context
                                  .read<ProviderInventoryBloc>()
                                  .add(FilterByCategory('all'));
                            },
                            label: const Text('Todas'),
                            avatar: state.selectedCategory == 'all'
                                ? const Icon(Icons.check, size: 18)
                                : null,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ...categories.map((category) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: FilterChip(
                                selected: state.selectedCategory == category,
                                onSelected: (_) {
                                  context
                                      .read<ProviderInventoryBloc>()
                                      .add(FilterByCategory(category));
                                },
                                label: Text(category),
                                avatar: state.selectedCategory == category
                                    ? const Icon(Icons.check, size: 18)
                                    : null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            Divider(
              // ignore: deprecated_member_use
              color: colorScheme.outlineVariant.withOpacity(0.5),
            ),

            // Contenido
            Expanded(
              child: _buildContent(context, state, equipments),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    ProviderInventoryState state,
    List<dynamic> equipments,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    if (state.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Cargando inventario...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }

    if (state.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error al cargar',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.error,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                state.errorMessage!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  context
                      .read<ProviderInventoryBloc>()
                      .add(RefreshProviderEquipments(widget.providerId));
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (equipments.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_2,
                size: 72,
                // ignore: deprecated_member_use
                color: colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                state.selectedCategory != 'all' || state.showOnlyAvailable
                    ? 'No hay equipos con estos filtros'
                    : 'No hay equipos registrados',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                state.selectedCategory != 'all' || state.showOnlyAvailable
                    ? 'Intenta ajustar los filtros'
                    : 'Agrega equipos desde el botón \'+\'',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      // ignore: deprecated_member_use
                      color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                    ),
              ),
            ],
          ),
        ),
      );
    }

    final availableCount = equipments.where((e) => e.available).length;
    final unavailableCount = equipments.length - availableCount;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Estadísticas rápidas
        if (availableCount > 0 || unavailableCount > 0) ...[
          Row(
            children: [
              if (availableCount > 0)
                Expanded(
                  child: QuickStatCard(
                    label: 'Disponibles',
                    count: availableCount,
                    icon: Icons.check_circle,
                    // ignore: deprecated_member_use
                    backgroundColor: Colors.green.withOpacity(0.2),
                    iconColor: Colors.green,
                  ),
                ),
              if (availableCount > 0 && unavailableCount > 0)
                const SizedBox(width: 12),
              if (unavailableCount > 0)
                Expanded(
                  child: QuickStatCard(
                    label: 'No disponibles',
                    count: unavailableCount,
                    icon: Icons.cancel,
                    // ignore: deprecated_member_use
                    backgroundColor: Colors.orange.withOpacity(0.2),
                    iconColor: Colors.orange,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],

        // Lista de equipos
        ...equipments.map((equipment) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: EquipmentInventoryCard(
              equipment: equipment,
              onTap: () {
                // TODO: Navigate to equipment detail
              },
            ),
          );
        }),
      ],
    );
  }
}
