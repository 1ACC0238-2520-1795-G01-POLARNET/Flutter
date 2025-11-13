import 'package:flutter/material.dart';
import 'package:polarnet_flutter/features/provider/home/domain/models/provider_service_request.dart';

class RequestDetailsCard extends StatelessWidget {
  final ProviderServiceRequest serviceRequest;

  const RequestDetailsCard({
    super.key,
    required this.serviceRequest,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.tertiaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detalles de la Solicitud',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onTertiaryContainer,
                  ),
            ),
            const SizedBox(height: 12),
            Divider(
              // ignore: deprecated_member_use
              color: colorScheme.onTertiaryContainer.withOpacity(0.3),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Fecha Inicio:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onTertiaryContainer,
                      ),
                ),
                Text(
                  serviceRequest.startDate ?? 'N/A',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onTertiaryContainer,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Fecha Fin:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onTertiaryContainer,
                      ),
                ),
                Text(
                  serviceRequest.endDate ?? 'N/A',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onTertiaryContainer,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(
              // ignore: deprecated_member_use
              color: colorScheme.onTertiaryContainer.withOpacity(0.3),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Precio Total:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onTertiaryContainer,
                      ),
                ),
                Text(
                  'S/ ${serviceRequest.totalPrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onTertiaryContainer,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
