import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:polarnet_flutter/core/theme/app_colors.dart';
import 'package:polarnet_flutter/features/alerts/domain/models/alert.dart';
import 'package:polarnet_flutter/features/alerts/presentation/blocs/alert_bloc.dart';
import 'package:polarnet_flutter/features/alerts/presentation/blocs/alert_event.dart';
import 'package:polarnet_flutter/features/alerts/presentation/blocs/alert_state.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AlertBloc>().add(LoadAlerts());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
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
            child: BlocBuilder<AlertBloc, AlertState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alertas',
                              style: textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '${state.allAlerts.length} en total',
                              style: textTheme.bodyMedium?.copyWith(
                                // ignore: deprecated_member_use
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        if (state.unacknowledgedCount > 0)
                          IconButton(
                            icon: const Icon(
                              Icons.done_all,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () => _showAcknowledgeAllDialog(context),
                            tooltip: 'Marcar todas',
                          ),
                        IconButton(
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () =>
                              context.read<AlertBloc>().add(LoadAlerts()),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          // Filtros y contenido
          Expanded(
            child: Column(
              children: [
                _buildFilters(),
                Expanded(
                  child: BlocBuilder<AlertBloc, AlertState>(
                    builder: (context, state) {
                      if (state.status == AlertStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.status == AlertStatus.error) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 16),
                              Text(state.errorMessage ?? 'Error desconocido'),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () =>
                                    context.read<AlertBloc>().add(LoadAlerts()),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Reintentar'),
                              ),
                            ],
                          ),
                        );
                      }

                      final alerts = state.filteredAlerts;

                      if (alerts.isEmpty) {
                        return _buildEmptyState(state);
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<AlertBloc>().add(LoadAlerts());
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: alerts.length,
                          itemBuilder: (context, index) {
                            return _AlertCard(
                              alert: alerts[index],
                              onAcknowledge: () {
                                context.read<AlertBloc>().add(
                                  AcknowledgeAlert(alerts[index].id),
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return BlocBuilder<AlertBloc, AlertState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Stats row
              Row(
                children: [
                  _buildStatCard(
                    'Total',
                    state.allAlerts.length.toString(),
                    Colors.blue,
                    Icons.notifications,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    'Pendientes',
                    state.unacknowledgedCount.toString(),
                    Colors.orange,
                    Icons.pending,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    'Críticas',
                    state.criticalCount.toString(),
                    Colors.red,
                    Icons.warning,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('Todas'),
                      selected: state.severityFilter == null,
                      onSelected: (_) {
                        context.read<AlertBloc>().add(
                          FilterAlertsBySeverity(null),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildSeverityChip(
                      'critical',
                      'Críticas',
                      Colors.red,
                      state,
                    ),
                    const SizedBox(width: 8),
                    _buildSeverityChip(
                      'high',
                      'Altas',
                      Colors.deepOrange,
                      state,
                    ),
                    const SizedBox(width: 8),
                    _buildSeverityChip(
                      'medium',
                      'Medias',
                      Colors.orange,
                      state,
                    ),
                    const SizedBox(width: 8),
                    _buildSeverityChip('low', 'Bajas', Colors.blue, state),
                    const SizedBox(width: 16),
                    FilterChip(
                      label: Text(
                        state.showAcknowledged
                            ? 'Ocultar revisadas'
                            : 'Mostrar revisadas',
                      ),
                      selected: !state.showAcknowledged,
                      onSelected: (_) {
                        context.read<AlertBloc>().add(ToggleShowAcknowledged());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeverityChip(
    String severity,
    String label,
    Color color,
    AlertState state,
  ) {
    return FilterChip(
      label: Text(label),
      selected: state.severityFilter == severity,
      // ignore: deprecated_member_use
      selectedColor: color.withOpacity(0.2),
      checkmarkColor: color,
      onSelected: (_) {
        context.read<AlertBloc>().add(
          FilterAlertsBySeverity(
            state.severityFilter == severity ? null : severity,
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(AlertState state) {
    String message;
    if (state.allAlerts.isEmpty) {
      message = '¡Sin alertas! Todo está funcionando correctamente.';
    } else if (!state.showAcknowledged) {
      message = 'No hay alertas pendientes de revisar.';
    } else {
      message = 'No hay alertas que coincidan con los filtros.';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 80, color: Colors.green[300]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showAcknowledgeAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Marcar todas como revisadas'),
        content: const Text(
          '¿Estás seguro de que deseas marcar todas las alertas como revisadas?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AlertBloc>().add(AcknowledgeAllAlerts());
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final Alert alert;
  final VoidCallback onAcknowledge;

  const _AlertCard({required this.alert, required this.onAcknowledge});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: alert.isAcknowledged
            ? null
            : Border(left: BorderSide(color: alert.severityColor, width: 4)),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showAlertDetails(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: alert.severityColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        alert.typeIcon,
                        color: alert.severityColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                alert.typeName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildSeverityBadge(),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatTimestamp(alert.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!alert.isAcknowledged)
                      IconButton(
                        icon: const Icon(Icons.check_circle_outline),
                        color: AppColors.primary,
                        onPressed: onAcknowledge,
                        tooltip: 'Marcar como revisada',
                      )
                    else
                      Icon(Icons.check_circle, color: Colors.grey[400]),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  alert.message,
                  style: TextStyle(
                    fontSize: 14,
                    color: alert.isAcknowledged
                        ? Colors.grey[500]
                        : AppColors.textPrimary,
                  ),
                ),
                if (alert.minAllowed != null || alert.maxAllowed != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Rango permitido: ${alert.minAllowed ?? '-'} - ${alert.maxAllowed ?? '-'}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSeverityBadge() {
    String label;
    switch (alert.severity) {
      case 'critical':
        label = 'Crítica';
        break;
      case 'high':
        label = 'Alta';
        break;
      case 'medium':
        label = 'Media';
        break;
      default:
        label = 'Baja';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: alert.severityColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: alert.severityColor,
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} horas';
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(timestamp);
    }
  }

  void _showAlertDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: alert.severityColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    alert.typeIcon,
                    color: alert.severityColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert.typeName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat(
                          'dd/MM/yyyy HH:mm:ss',
                        ).format(alert.timestamp),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                _buildSeverityBadge(),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailRow('Valor detectado', '${alert.value}'),
            if (alert.minAllowed != null)
              _buildDetailRow('Mínimo permitido', '${alert.minAllowed}'),
            if (alert.maxAllowed != null)
              _buildDetailRow('Máximo permitido', '${alert.maxAllowed}'),
            _buildDetailRow(
              'Estado',
              alert.isAcknowledged ? 'Revisada' : 'Pendiente',
            ),
            const SizedBox(height: 16),
            const Text(
              'Mensaje',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(alert.message),
            const SizedBox(height: 24),
            if (!alert.isAcknowledged)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    onAcknowledge();
                    Navigator.of(ctx).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.check),
                  label: const Text(
                    'Marcar como revisada',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
