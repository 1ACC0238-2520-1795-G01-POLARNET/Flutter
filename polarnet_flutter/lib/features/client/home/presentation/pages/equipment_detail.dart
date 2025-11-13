import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:polarnet_flutter/shared/domain/models/equipment.dart';

class EquipmentDetailPage extends StatefulWidget {
  final Equipment equipment;
  final int clientId;

  const EquipmentDetailPage({
    super.key,
    required this.equipment,
    required this.clientId,
  });

  @override
  State<EquipmentDetailPage> createState() => _EquipmentDetailPageState();
}

class _EquipmentDetailPageState extends State<EquipmentDetailPage> {
  int _rentalMonths = 1;
  bool _isLoading = false;

  void _confirmRental() {
    developer.log('====================================', name: 'EquipmentDetail');
    developer.log('CONFIRMANDO RENTA', name: 'EquipmentDetail');
    developer.log('====================================', name: 'EquipmentDetail');
    developer.log('ClientId: ${widget.clientId}', name: 'EquipmentDetail');
    developer.log('EquipmentId: ${widget.equipment.id}', name: 'EquipmentDetail');
    developer.log('Equipo: ${widget.equipment.name}', name: 'EquipmentDetail');
    developer.log('Meses: $_rentalMonths', name: 'EquipmentDetail');
    developer.log('Precio/mes: ${widget.equipment.pricePerMonth}', name: 'EquipmentDetail');
    developer.log('Total: ${widget.equipment.pricePerMonth * _rentalMonths}', name: 'EquipmentDetail');

    setState(() {
      _isLoading = true;
    });

    // TODO: Implementar llamada al ViewModel/BLoC para crear la renta
    // viewModel.createRentalRequest(...)

    // Simular delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Renta creada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar con imagen
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              style: IconButton.styleFrom(
                // ignore: deprecated_member_use
                backgroundColor: colorScheme.surface.withOpacity(0.9),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.equipment.thumbnail ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.image_not_supported,
                          size: 80,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      );
                    },
                  ),
                  // Gradiente overlay
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            // ignore: deprecated_member_use
                            colorScheme.surface.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Contenido
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre y precio
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.equipment.name,
                              style: textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Disponible',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Precio/mes',
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                            Text(
                              'S/ ${widget.equipment.pricePerMonth.toStringAsFixed(2)}',
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Duración de renta
                  _buildRentalDurationCard(colorScheme, textTheme),

                  const SizedBox(height: 16),

                  // Detalles del producto
                  _buildProductDetailsCard(colorScheme, textTheme),

                  const SizedBox(height: 16),

                  // Resumen de renta
                  _buildRentalSummaryCard(colorScheme, textTheme),

                  const SizedBox(height: 100), // Espacio para el FAB
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showRentalDialog,
        icon: const Icon(Icons.calendar_month),
        label: const Text(
          'Rentar Equipo',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildRentalDurationCard(ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Duración de Renta',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'S/ ${widget.equipment.pricePerMonth.toStringAsFixed(2)}/mes',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                // Botón decrementar
                FilledButton.tonal(
                  onPressed: _rentalMonths > 1
                      ? () => setState(() => _rentalMonths--)
                      : null,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(40, 40),
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Icon(Icons.remove, size: 20),
                ),
                const SizedBox(width: 12),
                // Contador
                Container(
                  width: 80,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$_rentalMonths',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _rentalMonths == 1 ? 'mes' : 'meses',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Botón incrementar
                FilledButton(
                  onPressed: () => setState(() => _rentalMonths++),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(40, 40),
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Icon(Icons.add, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetailsCard(ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detalles del Producto',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              Icons.category,
              'Categoría',
              widget.equipment.category,
              colorScheme,
              textTheme,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              Icons.inventory,
              'Stock',
              widget.equipment.available ? 'Disponible' : 'No disponible',
              colorScheme,
              textTheme,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              Icons.local_shipping,
              'Ubicación',
              widget.equipment.location ?? 'Lima, Perú',
              colorScheme,
              textTheme,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              Icons.verified,
              'Marca',
              widget.equipment.brand ?? 'N/A',
              colorScheme,
              textTheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRentalSummaryCard(ColorScheme colorScheme, TextTheme textTheme) {
    final total = widget.equipment.pricePerMonth * _rentalMonths;

    return Card(
      color: colorScheme.tertiaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen de Renta',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onTertiaryContainer,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Precio por mes',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onTertiaryContainer,
                  ),
                ),
                Text(
                  'S/ ${widget.equipment.pricePerMonth.toStringAsFixed(2)}',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onTertiaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Duración',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onTertiaryContainer,
                  ),
                ),
                Text(
                  '$_rentalMonths ${_rentalMonths == 1 ? "mes" : "meses"}',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onTertiaryContainer,
                  ),
                ),
              ],
            ),
            Divider(
              height: 24,
              // ignore: deprecated_member_use
              color: colorScheme.onTertiaryContainer.withOpacity(0.3),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total a Pagar',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onTertiaryContainer,
                      ),
                    ),
                    Text(
                      'Por $_rentalMonths ${_rentalMonths == 1 ? "mes" : "meses"}',
                      style: textTheme.bodySmall?.copyWith(
                        // ignore: deprecated_member_use
                        color: colorScheme.onTertiaryContainer.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                Text(
                  'S/ ${total.toStringAsFixed(2)}',
                  style: textTheme.headlineMedium?.copyWith(
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

  // Diálogo de confirmación
  void _showRentalDialog() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final total = widget.equipment.pricePerMonth * _rentalMonths;

    showDialog(
      context: context,
      barrierDismissible: !_isLoading,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          icon: Icon(
            Icons.calendar_month,
            color: colorScheme.primary,
            size: 32,
          ),
          title: const Text(
            'Confirmar Renta',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.equipment.name,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              // Selector de meses
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Duración:', style: textTheme.bodyMedium),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: _isLoading || _rentalMonths <= 1
                            ? null
                            : () {
                                setState(() => _rentalMonths--);
                                setDialogState(() {});
                              },
                      ),
                      Container(
                        constraints: const BoxConstraints(minWidth: 60),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$_rentalMonths ${_rentalMonths == 1 ? "mes" : "meses"}',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _isLoading
                            ? null
                            : () {
                                setState(() => _rentalMonths++);
                                setDialogState(() {});
                              },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Resumen
              Card(
                color: colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Precio/mes:',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                          Text(
                            'S/ ${widget.equipment.pricePerMonth.toStringAsFixed(2)}',
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        height: 16,
                        // ignore: deprecated_member_use
                        color: colorScheme.onPrimaryContainer.withOpacity(0.3),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Total:',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                          Text(
                            'S/ ${total.toStringAsFixed(2)}',
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: _isLoading
                  ? null
                  : () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      Navigator.pop(context);
                      _confirmRental();
                    },
              child: _isLoading
                  ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('Procesando...'),
                      ],
                    )
                  : const Text('Confirmar Renta'),
            ),
          ],
        ),
      ),
    );
  }
}
