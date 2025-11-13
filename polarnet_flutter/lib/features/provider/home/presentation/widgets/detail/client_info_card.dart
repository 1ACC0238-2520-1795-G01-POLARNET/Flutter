import 'package:flutter/material.dart';
import 'package:polarnet_flutter/features/provider/home/domain/models/provider_service_request.dart';
import 'info_row.dart';

class ClientInfoCard extends StatelessWidget {
  final ProviderServiceRequest serviceRequest;

  const ClientInfoCard({
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
              'Información del Cliente',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            if (serviceRequest.client != null) ...[
              InfoRow(
                icon: Icons.person,
                label: 'Nombre',
                value: serviceRequest.client!.fullName,
              ),
              const SizedBox(height: 12),
              InfoRow(
                icon: Icons.business,
                label: 'Empresa',
                value: serviceRequest.client!.companyName ?? 'N/A',
              ),
              const SizedBox(height: 12),
              InfoRow(
                icon: Icons.email,
                label: 'Email',
                value: serviceRequest.client!.email,
              ),
              const SizedBox(height: 12),
              InfoRow(
                icon: Icons.phone,
                label: 'Teléfono',
                value: serviceRequest.client!.phone ?? 'N/A',
              ),
              const SizedBox(height: 12),
              InfoRow(
                icon: Icons.location_on,
                label: 'Ubicación',
                value: serviceRequest.client!.location ?? 'N/A',
              ),
            ] else
              Text(
                'Información no disponible',
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
