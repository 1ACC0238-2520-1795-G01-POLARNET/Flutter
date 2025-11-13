import 'package:flutter/material.dart';
import 'package:polarnet_flutter/shared/domain/models/equipment.dart';

class EquipmentInventoryCard extends StatelessWidget {
  final Equipment equipment;
  final VoidCallback onTap;

  const EquipmentInventoryCard({
    super.key,
    required this.equipment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: colorScheme.surfaceContainerLow,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del equipo
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: colorScheme.surfaceContainerHighest,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: equipment.thumbnail != null &&
                              equipment.thumbnail!.isNotEmpty
                          ? Image.network(
                              equipment.thumbnail!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.inventory,
                                  size: 40,
                                  color: colorScheme.onSurfaceVariant,
                                );
                              },
                            )
                          : Icon(
                              Icons.inventory,
                              size: 40,
                              color: colorScheme.onSurfaceVariant,
                            ),
                    ),
                  ),
                  // Badge de disponibilidad
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: equipment.available
                            // ignore: deprecated_member_use
                            ? Colors.green.withOpacity(0.9)
                            // ignore: deprecated_member_use
                            : Colors.orange.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 12),

              // Información del equipo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      equipment.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Categoría
                    Row(
                      children: [
                        Icon(
                          Icons.category,
                          size: 14,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          equipment.category,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),

                    // Marca y modelo
                    if (equipment.brand != null || equipment.model != null) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.label,
                            size: 14,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${equipment.brand ?? ''} ${equipment.model ?? ''}'
                                  .trim(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 8),

                    // Precio y estado
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Precio
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Precio/mes',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                            Text(
                              'S/ ${equipment.pricePerMonth.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),

                        // Estado
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: equipment.available
                                // ignore: deprecated_member_use
                                ? Colors.green.withOpacity(0.2)
                                // ignore: deprecated_member_use
                                : Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                equipment.available
                                    ? Icons.check_circle
                                    : Icons.block,
                                size: 14,
                                color: equipment.available
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                equipment.available ? 'Disponible' : 'Ocupado',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: equipment.available
                                          ? Colors.green
                                          : Colors.orange,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
