import 'package:flutter/material.dart';
import 'package:polarnet_flutter/core/theme/app_colors.dart';

/// Widget reutilizable para mostrar imágenes de equipos con tamaño uniforme
/// y placeholder de error cuando no hay imagen disponible.
class EquipmentImage extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final double borderRadius;
  final IconData placeholderIcon;
  final bool showErrorIcon;

  const EquipmentImage({
    super.key,
    this.imageUrl,
    this.size = 100,
    this.borderRadius = 12,
    this.placeholderIcon = Icons.inventory_2,
    this.showErrorIcon = true,
  });

  /// Tamaño pequeño para listas compactas
  const EquipmentImage.small({
    super.key,
    this.imageUrl,
    this.placeholderIcon = Icons.inventory_2,
    this.showErrorIcon = true,
  }) : size = 60,
       borderRadius = 8;

  /// Tamaño mediano para cards
  const EquipmentImage.medium({
    super.key,
    this.imageUrl,
    this.placeholderIcon = Icons.inventory_2,
    this.showErrorIcon = true,
  }) : size = 100,
       borderRadius = 12;

  /// Tamaño grande para detalles
  const EquipmentImage.large({
    super.key,
    this.imageUrl,
    this.placeholderIcon = Icons.inventory_2,
    this.showErrorIcon = true,
  }) : size = 150,
       borderRadius = 16;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasValidUrl = imageUrl != null && imageUrl!.isNotEmpty;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: colorScheme.surfaceContainerHighest,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: hasValidUrl
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                width: size,
                height: size,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                      color: AppColors.primary,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return _buildErrorPlaceholder(colorScheme);
                },
              )
            : _buildPlaceholder(colorScheme),
      ),
    );
  }

  Widget _buildPlaceholder(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          placeholderIcon,
          size: size * 0.4,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder(ColorScheme colorScheme) {
    if (!showErrorIcon) {
      return _buildPlaceholder(colorScheme);
    }

    return Container(
      color: colorScheme.errorContainer,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_outlined,
              size: size * 0.3,
              color: colorScheme.onErrorContainer,
            ),
            const SizedBox(height: 4),
            Text(
              'Error',
              style: TextStyle(
                fontSize: size * 0.1,
                color: colorScheme.onErrorContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
