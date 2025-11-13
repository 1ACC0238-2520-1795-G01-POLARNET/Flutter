import 'package:flutter/material.dart';
import 'package:polarnet_flutter/features/provider/home/domain/models/provider_service_request.dart';
import 'info_row.dart';

class EquipmentInfoCard extends StatelessWidget {
  final ProviderServiceRequest serviceRequest;

  const EquipmentInfoCard({
    super.key,
    required this.serviceRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Equipo Solicitado',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            if (serviceRequest.equipment != null) ...[
              InfoRow(
                icon: Icons.inventory,
                label: 'Nombre',
                value: serviceRequest.equipment!.name,
              ),
              const SizedBox(height: 12),
              InfoRow(
                icon: Icons.category,
                label: 'Categoría',
                value: serviceRequest.equipment!.category,
              ),
              if (serviceRequest.equipment!.brand != null) ...[
                const SizedBox(height: 12),
                InfoRow(
                  icon: Icons.label,
                  label: 'Marca',
                  value: serviceRequest.equipment!.brand!,
                ),
              ],
              if (serviceRequest.equipment!.model != null) ...[
                const SizedBox(height: 12),
                InfoRow(
                  icon: Icons.info,
                  label: 'Modelo',
                  value: serviceRequest.equipment!.model!,
                ),
              ],
            ] else
              Text(
                'Información del equipo no disponible',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
          ],
        ),
      ),
    );
  }
}
