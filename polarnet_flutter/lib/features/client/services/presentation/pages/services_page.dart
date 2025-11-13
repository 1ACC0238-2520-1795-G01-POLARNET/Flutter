import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polarnet_flutter/core/theme/app_colors.dart';
import 'package:polarnet_flutter/features/client/services/presentation/blocs/service_request_bloc.dart';
import 'package:polarnet_flutter/features/client/services/presentation/blocs/service_request_event.dart';
import 'package:polarnet_flutter/features/client/services/presentation/blocs/service_request_state.dart';
import 'package:polarnet_flutter/features/client/services/presentation/widgets/service_request_card.dart';

class ServicesPage extends StatefulWidget {
  final int clientId;

  const ServicesPage({
    super.key,
    required this.clientId,
  });

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadServiceRequests();
      }
    });
  }

  void _loadServiceRequests() {
    context.read<ServiceRequestBloc>().add(
          LoadServiceRequests(widget.clientId),
        );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: BlocBuilder<ServiceRequestBloc, ServiceRequestState>(
        builder: (context, state) {
          final serviceRequests = state.serviceRequests;

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
                          Icons.build,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mis Servicios',
                              style: textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '${serviceRequests.length} solicitudes',
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
                        Icons.refresh,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: _loadServiceRequests,
                    ),
                  ],
                ),
              ),

              // Contenido
              Expanded(
                child: _buildContent(state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(ServiceRequestState state) {
    if (state.status == ServiceRequestStatus.loading) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(),
            ),
            const SizedBox(height: 16),
            Text(
              'Cargando servicios...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }

    if (state.status == ServiceRequestStatus.failure) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
            ),
            Text(
              state.error ?? 'Error desconocido',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadServiceRequests,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (state.serviceRequests.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment,
              size: 72,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  // ignore: deprecated_member_use
                  .withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay servicios',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Aún no tienes solicitudes de servicio',
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

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Estadísticas rápidas
        _buildStatistics(state.serviceRequests),
        const SizedBox(height: 12),

        // Lista de solicitudes
        ...state.serviceRequests.map(
          (request) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ServiceRequestCard(request: request),
          ),
        ),
      ],
    );
  }

  Widget _buildStatistics(List serviceRequests) {
    final completedCount =
        serviceRequests.where((r) => r.status.toLowerCase() == 'completed').length;
    final pendingCount =
        serviceRequests.where((r) => r.status.toLowerCase() == 'pending').length;
    final inProgressCount =
        serviceRequests.where((r) => r.status.toLowerCase() == 'in_progress').length;

    final stats = <Widget>[];

    if (completedCount > 0) {
      stats.add(
        Expanded(
          child: _StatChip(
            label: 'Completados',
            count: completedCount,
            color: const Color(0xFFD1F4E0),
            onColor: const Color(0xFF1B5E37),
          ),
        ),
      );
    }

    if (inProgressCount > 0) {
      stats.add(
        Expanded(
          child: _StatChip(
            label: 'En Proceso',
            count: inProgressCount,
            color: const Color(0xFFCFE4FF),
            onColor: const Color(0xFF004A77),
          ),
        ),
      );
    }

    if (pendingCount > 0) {
      stats.add(
        Expanded(
          child: _StatChip(
            label: 'Pendientes',
            count: pendingCount,
            color: const Color(0xFFFFE8CC),
            onColor: const Color(0xFF7A4E00),
          ),
        ),
      );
    }

    if (stats.isEmpty) return const SizedBox.shrink();

    return Row(
      children: stats
          .map((stat) => [stat, const SizedBox(width: 12)])
          .expand((x) => x)
          .toList()
        ..removeLast(),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final Color onColor;

  const _StatChip({
    required this.label,
    required this.count,
    required this.color,
    required this.onColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: onColor,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  // ignore: deprecated_member_use
                  color: onColor.withOpacity(0.8),
                ),
          ),
        ],
      ),
    );
  }
}
