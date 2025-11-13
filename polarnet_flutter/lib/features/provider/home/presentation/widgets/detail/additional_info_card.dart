import 'package:flutter/material.dart';
import 'package:polarnet_flutter/features/provider/home/domain/models/provider_service_request.dart';
import 'info_row.dart';

class AdditionalInfoCard extends StatelessWidget {
  final ProviderServiceRequest serviceRequest;

  const AdditionalInfoCard({
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
              'Información Adicional',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            if (serviceRequest.description != null) ...[
              InfoRow(
                icon: Icons.description,
                label: 'Descripción',
                value: serviceRequest.description!,
              ),
              const SizedBox(height: 12),
            ],
            if (serviceRequest.notes != null) ...[
              InfoRow(
                icon: Icons.notes,
                label: 'Notas',
                value: serviceRequest.notes!,
              ),
              const SizedBox(height: 12),
            ],
            if (serviceRequest.createdAt != null) ...[
              InfoRow(
                icon: Icons.schedule,
                label: 'Fecha de Creación',
                value: serviceRequest.createdAt!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
