import 'package:flutter/material.dart';
import 'package:polarnet_flutter/features/provider/home/domain/models/provider_service_request.dart';

class StatusCard extends StatelessWidget {
  final ProviderServiceRequest serviceRequest;

  const StatusCard({
    super.key,
    required this.serviceRequest,
  });

  @override
  Widget build(BuildContext context) {
    final (statusColor, statusText, statusIcon) = _getStatusInfo();

    return Card(
      // ignore: deprecated_member_use
      color: statusColor.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estado de la Solicitud',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        // ignore: deprecated_member_use
                        color: statusColor.withOpacity(0.8),
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusText.toUpperCase(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                ),
              ],
            ),
            Icon(
              statusIcon,
              size: 48,
              color: statusColor,
            ),
          ],
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
}
