import 'package:flutter/material.dart';
import 'package:polarnet_flutter/features/client/services/domain/models/service_request.dart';

class ServiceRequestCard extends StatelessWidget {
  final ServiceRequest request;

  const ServiceRequestCard({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final statusInfo = _getStatusInfo(request.status, colorScheme);
    final requestTypeText = _getRequestTypeText(request.requestType);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: colorScheme.surfaceContainerLow,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Tipo y estado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        requestTypeText.toUpperCase(),
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Solicitud #${request.id}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusInfo.containerColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusInfo.icon,
                        size: 16,
                        color: statusInfo.onContainerColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        statusInfo.text,
                        style: textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: statusInfo.onContainerColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(
                // ignore: deprecated_member_use
                color: colorScheme.outlineVariant.withOpacity(0.5),
              ),
            ),

            // Detalles en grid
            Column(
              children: [
                _DetailRow(
                  icon: Icons.devices,
                  label: 'Equipo',
                  value: 'ID: ${request.equipmentId}',
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 10),
                _DetailRow(
                  icon: Icons.attach_money,
                  label: 'Precio Total',
                  value: 'S/ ${request.totalPrice.toStringAsFixed(2)}',
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                if (request.startDate != null) ...[
                  const SizedBox(height: 10),
                  _DetailRow(
                    icon: Icons.event_available,
                    label: 'Fecha Inicio',
                    value: request.startDate!,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                ],
                if (request.endDate != null) ...[
                  const SizedBox(height: 10),
                  _DetailRow(
                    icon: Icons.event,
                    label: 'Fecha Fin',
                    value: request.endDate!,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                ],
              ],
            ),

            // Notas (si existen)
            if (request.notes != null && request.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.sticky_note_2,
                      size: 20,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notas',
                            style: textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            request.notes!,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Acción según estado
            if (request.status.toLowerCase() == 'completed') ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: () {
                    // TODO: Ver detalles
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.visibility, size: 18),
                      const SizedBox(width: 8),
                      const Text('Ver Detalles'),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  _StatusInfo _getStatusInfo(String status, ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'completed':
        return _StatusInfo(
          containerColor: const Color(0xFFD1F4E0),
          onContainerColor: const Color(0xFF1B5E37),
          text: 'Completado',
          icon: Icons.check_circle,
        );
      case 'in_progress':
        return _StatusInfo(
          containerColor: const Color(0xFFCFE4FF),
          onContainerColor: const Color(0xFF004A77),
          text: 'En Proceso',
          icon: Icons.construction,
        );
      case 'pending':
        return _StatusInfo(
          containerColor: const Color(0xFFFFE8CC),
          onContainerColor: const Color(0xFF7A4E00),
          text: 'Pendiente',
          icon: Icons.schedule,
        );
      default:
        return _StatusInfo(
          containerColor: colorScheme.surfaceContainerHighest,
          onContainerColor: colorScheme.onSurfaceVariant,
          text: status,
          icon: Icons.info,
        );
    }
  }

  String _getRequestTypeText(String requestType) {
    switch (requestType.toLowerCase()) {
      case 'maintenance':
        return 'Mantenimiento';
      case 'repair':
        return 'Reparación';
      case 'installation':
        return 'Instalación';
      case 'inspection':
        return 'Inspección';
      case 'rental':
        return 'Alquiler';
      default:
        return requestType;
    }
  }
}

class _StatusInfo {
  final Color containerColor;
  final Color onContainerColor;
  final String text;
  final IconData icon;

  _StatusInfo({
    required this.containerColor,
    required this.onContainerColor,
    required this.text,
    required this.icon,
  });
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 20,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
