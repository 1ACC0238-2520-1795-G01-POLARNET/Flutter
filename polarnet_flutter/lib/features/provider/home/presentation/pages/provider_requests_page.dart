import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polarnet_flutter/core/theme/app_colors.dart';
import 'package:polarnet_flutter/features/provider/home/presentation/blocs/provider_home_bloc.dart';
import 'package:polarnet_flutter/features/provider/home/presentation/blocs/provider_home_event.dart';
import 'package:polarnet_flutter/features/provider/home/presentation/blocs/provider_home_state.dart';
import 'package:polarnet_flutter/features/provider/home/presentation/widgets/service_request_card.dart';
import 'package:polarnet_flutter/features/provider/home/presentation/widgets/status_filter_row.dart';
import 'package:polarnet_flutter/features/provider/home/presentation/widgets/quick_stat_card.dart';
import 'package:polarnet_flutter/features/provider/home/presentation/pages/service_request_detail_page.dart';

class ProviderRequestsPage extends StatefulWidget {
  const ProviderRequestsPage({super.key});

  @override
  State<ProviderRequestsPage> createState() => _ProviderRequestsPageState();
}

class _ProviderRequestsPageState extends State<ProviderRequestsPage> {
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    // Cargar solicitudes al iniciar
    context.read<ProviderHomeBloc>().add(const LoadAllServiceRequests());
  }

  void _filterByStatus(String filter) {
    setState(() {
      _selectedFilter = filter;
    });

    if (filter == 'all') {
      context.read<ProviderHomeBloc>().add(const LoadAllServiceRequests());
    } else {
      context
          .read<ProviderHomeBloc>()
          .add(LoadServiceRequestsByStatus(filter));
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<ProviderHomeBloc, ProviderHomeState>(
      listener: (context, state) {
        if (state is ProviderHomeActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      builder: (context, state) {
        final requests = state is ProviderHomeLoaded
            ? state.requests
            : state is ProviderHomeActionSuccess
                ? state.requests
                : [];
        final isLoading = state is ProviderHomeLoading;
        final errorMessage =
            state is ProviderHomeError ? state.message : null;

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
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 32,
                bottom: 32,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.assignment,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Solicitudes',
                            style: textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${requests.length} en total',
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
                    onPressed: () {
                      context
                          .read<ProviderHomeBloc>()
                          .add(const RefreshServiceRequests());
                    },
                  ),
                ],
              ),
            ),

            // Filtros de estado
            StatusFilterRow(
              selectedFilter: _selectedFilter,
              onFilterSelected: _filterByStatus,
            ),

            // Estadísticas rápidas
            if (requests.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    if (requests
                        .where((r) => r.status == 'pending')
                        .isNotEmpty)
                      Expanded(
                        child: QuickStatCard(
                          label: 'Pendientes',
                          count: requests
                              .where((r) => r.status == 'pending')
                              .length,
                          color: const Color(0xFFFFF3E0),
                          onColor: const Color(0xFFE65100),
                        ),
                      ),
                    if (requests
                        .where((r) => r.status == 'pending')
                        .isNotEmpty)
                      const SizedBox(width: 8),
                    if (requests
                        .where((r) => r.status == 'in_progress')
                        .isNotEmpty)
                      Expanded(
                        child: QuickStatCard(
                          label: 'En Progreso',
                          count: requests
                              .where((r) => r.status == 'in_progress')
                              .length,
                          color: const Color(0xFFE3F2FD),
                          onColor: const Color(0xFF1565C0),
                        ),
                      ),
                    if (requests
                        .where((r) => r.status == 'in_progress')
                        .isNotEmpty)
                      const SizedBox(width: 8),
                    if (requests
                        .where((r) => r.status == 'completed')
                        .isNotEmpty)
                      Expanded(
                        child: QuickStatCard(
                          label: 'Completadas',
                          count: requests
                              .where((r) => r.status == 'completed')
                              .length,
                          color: const Color(0xFFE8F5E9),
                          onColor: const Color(0xFF1B5E37),
                        ),
                      ),
                  ],
                ),
              ),

            // Contenido
            Expanded(
              child: Builder(
                builder: (context) {
                  if (isLoading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Cargando solicitudes...',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (errorMessage != null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error al cargar',
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.red.shade400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              errorMessage,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                context
                                    .read<ProviderHomeBloc>()
                                    .add(const LoadAllServiceRequests());
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (requests.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.assignment_late,
                              size: 72,
                              color: colorScheme.onSurfaceVariant
                                  // ignore: deprecated_member_use
                                  .withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No hay solicitudes',
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _selectedFilter == 'all'
                                  ? 'Aún no tienes solicitudes de servicio'
                                  : 'No hay solicitudes con este estado',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant
                                    // ignore: deprecated_member_use
                                    .withOpacity(0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: requests.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return ServiceRequestCard(
                        serviceRequest: requests[index],
                        onClick: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServiceRequestDetailPage(
                                serviceRequest: requests[index],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
