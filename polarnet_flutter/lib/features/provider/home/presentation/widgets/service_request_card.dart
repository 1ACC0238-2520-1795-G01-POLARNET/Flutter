import 'package:flutter/material.dart';
import 'package:polarnet_flutter/features/provider/home/domain/models/provider_service_request.dart';

class ServiceRequestCard extends StatelessWidget {
  final ProviderServiceRequest serviceRequest;
  final VoidCallback onClick;

  const ServiceRequestCard({
    super.key,
    required this.serviceRequest,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final (statusColor, statusText, statusIcon) = _getStatusInfo();
    final requestTypeText = _getRequestTypeText();

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: colorScheme.surfaceContainerLow,
      elevation: 2,
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.circular(16),
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
                          'Solicitud #${serviceRequest.id}',
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
                      color: statusColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          statusIcon,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          statusText,
                          style: textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Divider(
                // ignore: deprecated_member_use
                color: colorScheme.outlineVariant.withOpacity(0.5),
              ),
              const SizedBox(height: 12),

              // Información del cliente
              if (serviceRequest.client != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cliente',
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            serviceRequest.client!.companyName ??
                                serviceRequest.client!.fullName,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],

              // Información del equipo
              if (serviceRequest.equipment != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.build,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Equipo',
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            serviceRequest.equipment!.name,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],

              // Fechas
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.event_available,
                          size: 18,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Inicio',
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              serviceRequest.startDate ?? 'Sin fecha',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.event,
                          size: 18,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fin',
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              serviceRequest.endDate ?? 'Sin fecha',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Divider(
                // ignore: deprecated_member_use
                color: colorScheme.outlineVariant.withOpacity(0.5),
              ),
              const SizedBox(height: 12),

              // Precio y botón
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.attach_money,
                        size: 24,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Precio Total',
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            'S/ ${serviceRequest.totalPrice.toStringAsFixed(2)}',
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Botón según estado
                  _buildActionButton(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  (Color, String, IconData) _getStatusInfo() {
    switch (serviceRequest.status.toLowerCase()) {
      case 'completed':
        return (
          const Color(0xFF1B5E37),
          'Completada',
          Icons.check_circle,
        );
      case 'in_progress':
        return (
          const Color(0xFF1565C0),
          'En Progreso',
          Icons.construction,
        );
      case 'pending':
        return (
          const Color(0xFFE65100),
          'Pendiente',
          Icons.schedule,
        );
      case 'cancelled':
        return (
          const Color(0xFFD32F2F),
          'Cancelada',
          Icons.cancel,
        );
      default:
        return (
          Colors.grey,
          serviceRequest.status,
          Icons.info,
        );
    }
  }

  String _getRequestTypeText() {
    switch (serviceRequest.requestType.toLowerCase()) {
      case 'rental':
        return 'Alquiler';
      case 'maintenance':
        return 'Mantenimiento';
      case 'installation':
        return 'Instalación';
      case 'repair':
        return 'Reparación';
      default:
        return serviceRequest.requestType;
    }
  }

  Widget _buildActionButton(BuildContext context) {
    switch (serviceRequest.status.toLowerCase()) {
      case 'pending':
        return FilledButton.tonal(
          onPressed: onClick,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.visibility, size: 18),
              const SizedBox(width: 4),
              Text(
                'Ver',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
        );
      case 'in_progress':
        return FilledButton.tonal(
          onPressed: onClick,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.edit, size: 18),
              const SizedBox(width: 4),
              Text(
                'Gestionar',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
        );
      default:
        return OutlinedButton(
          onPressed: onClick,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info, size: 18),
              const SizedBox(width: 4),
              Text(
                'Detalles',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
        );
    }
  }
}
