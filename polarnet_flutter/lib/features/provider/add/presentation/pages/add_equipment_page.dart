import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polarnet_flutter/core/theme/app_colors.dart';
import 'package:polarnet_flutter/features/provider/add/presentation/blocs/add_equipment_bloc.dart';
import 'package:polarnet_flutter/features/provider/add/presentation/blocs/add_equipment_event.dart';
import 'package:polarnet_flutter/features/provider/add/presentation/blocs/add_equipment_state.dart';

class AddEquipmentPage extends StatefulWidget {
  final int providerId;
  final VoidCallback? onEquipmentAdded;

  const AddEquipmentPage({
    super.key,
    required this.providerId,
    this.onEquipmentAdded,
  });

  @override
  State<AddEquipmentPage> createState() => _AddEquipmentPageState();
}

class _AddEquipmentPageState extends State<AddEquipmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _thumbnailController = TextEditingController();
  final _pricePerMonthController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _locationController = TextEditingController();

  String _selectedCategory = 'Excavadoras';
  bool _available = true;

  final List<String> _categories = [
    'Excavadoras',
    'Retroexcavadoras',
    'Cargadores',
    'Motoniveladoras',
    'Compactadoras',
    'Grúas',
    'Otros',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _descriptionController.dispose();
    _thumbnailController.dispose();
    _pricePerMonthController.dispose();
    _purchasePriceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AddEquipmentBloc>().add(
            AddEquipment(
              providerId: widget.providerId,
              name: _nameController.text.trim(),
              brand: _brandController.text.trim().isEmpty
                  ? null
                  : _brandController.text.trim(),
              model: _modelController.text.trim().isEmpty
                  ? null
                  : _modelController.text.trim(),
              category: _selectedCategory,
              description: _descriptionController.text.trim().isEmpty
                  ? null
                  : _descriptionController.text.trim(),
              thumbnail: _thumbnailController.text.trim().isEmpty
                  ? null
                  : _thumbnailController.text.trim(),
              pricePerMonth: double.parse(_pricePerMonthController.text),
              purchasePrice: double.parse(_purchasePriceController.text),
              location: _locationController.text.trim().isEmpty
                  ? null
                  : _locationController.text.trim(),
              available: _available,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<AddEquipmentBloc, AddEquipmentState>(
      listener: (context, state) {
        if (state.status == AddEquipmentStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage ?? 'Equipo agregado'),
              backgroundColor: Colors.green,
            ),
          );
          widget.onEquipmentAdded?.call();
          Navigator.pop(context, true);
        } else if (state.status == AddEquipmentStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Error al agregar equipo'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            // Header con gradiente
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primaryDark,
                    AppColors.primary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 48,
                bottom: 32,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.add_circle,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Agregar Equipo',
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Completa la información del equipo',
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Formulario
            Expanded(
              child: BlocBuilder<AddEquipmentBloc, AddEquipmentState>(
                builder: (context, state) {
                  final isLoading = state.status == AddEquipmentStatus.loading;

                  return Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sección: Información Básica
                          _SectionHeader(
                            icon: Icons.info,
                            title: 'Información Básica',
                            colorScheme: colorScheme,
                            textTheme: textTheme,
                          ),
                          const SizedBox(height: 16),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            color: colorScheme.surfaceContainerLow,
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      labelText: 'Nombre del equipo *',
                                      prefixIcon: const Icon(Icons.build),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    enabled: !isLoading,
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return 'El nombre es obligatorio';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _brandController,
                                    decoration: InputDecoration(
                                      labelText: 'Marca',
                                      prefixIcon: const Icon(Icons.label),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    enabled: !isLoading,
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _modelController,
                                    decoration: InputDecoration(
                                      labelText: 'Modelo',
                                      prefixIcon: const Icon(Icons.model_training),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    enabled: !isLoading,
                                  ),
                                  const SizedBox(height: 16),
                                  DropdownButtonFormField<String>(
                                    initialValue: _selectedCategory,
                                    decoration: InputDecoration(
                                      labelText: 'Categoría *',
                                      prefixIcon: const Icon(Icons.category),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    items: _categories.map((category) {
                                      return DropdownMenuItem(
                                        value: category,
                                        child: Text(category),
                                      );
                                    }).toList(),
                                    onChanged: isLoading
                                        ? null
                                        : (value) {
                                            if (value != null) {
                                              setState(() {
                                                _selectedCategory = value;
                                              });
                                            }
                                          },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _descriptionController,
                                    decoration: InputDecoration(
                                      labelText: 'Descripción',
                                      prefixIcon: const Icon(Icons.description),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      alignLabelWithHint: true,
                                    ),
                                    maxLines: 5,
                                    enabled: !isLoading,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Sección: Precios
                          _SectionHeader(
                            icon: Icons.attach_money,
                            title: 'Precios',
                            colorScheme: colorScheme,
                            textTheme: textTheme,
                          ),
                          const SizedBox(height: 16),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            color: colorScheme.surfaceContainerLow,
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _pricePerMonthController,
                                    decoration: InputDecoration(
                                      labelText: 'Precio por mes *',
                                      prefixIcon: const Icon(Icons.calendar_month),
                                      prefixText: 'S/ ',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}'),
                                      ),
                                    ],
                                    enabled: !isLoading,
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return 'El precio por mes es obligatorio';
                                      }
                                      if (double.tryParse(value) == null) {
                                        return 'Ingrese un precio válido';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _purchasePriceController,
                                    decoration: InputDecoration(
                                      labelText: 'Precio de compra *',
                                      prefixIcon: const Icon(Icons.shopping_cart),
                                      prefixText: 'S/ ',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}'),
                                      ),
                                    ],
                                    enabled: !isLoading,
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return 'El precio de compra es obligatorio';
                                      }
                                      if (double.tryParse(value) == null) {
                                        return 'Ingrese un precio válido';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Sección: Detalles Adicionales
                          _SectionHeader(
                            icon: Icons.more_horiz,
                            title: 'Detalles Adicionales',
                            colorScheme: colorScheme,
                            textTheme: textTheme,
                          ),
                          const SizedBox(height: 16),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            color: colorScheme.surfaceContainerLow,
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _thumbnailController,
                                    decoration: InputDecoration(
                                      labelText: 'URL de imagen',
                                      prefixIcon: const Icon(Icons.image),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    enabled: !isLoading,
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _locationController,
                                    decoration: InputDecoration(
                                      labelText: 'Ubicación',
                                      prefixIcon: const Icon(Icons.location_on),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    enabled: !isLoading,
                                  ),
                                  const SizedBox(height: 16),
                                  // Disponibilidad
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: _available
                                          ? const Color(0xFFD1F4E0).withValues(alpha: 0.3)
                                          : colorScheme.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _available
                                            ? const Color(0xFF1B5E37).withValues(alpha: 0.5)
                                            : colorScheme.outline.withValues(alpha: 0.5),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          _available ? Icons.check_circle : Icons.cancel,
                                          color: _available
                                              ? const Color(0xFF1B5E37)
                                              : colorScheme.onSurfaceVariant,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Disponibilidad',
                                                style: textTheme.bodyMedium?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                _available
                                                    ? 'Disponible para alquiler'
                                                    : 'No disponible',
                                                style: textTheme.bodySmall?.copyWith(
                                                  color: colorScheme.onSurfaceVariant,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Switch(
                                          value: _available,
                                          onChanged: isLoading
                                              ? null
                                              : (value) {
                                                  setState(() {
                                                    _available = value;
                                                  });
                                                },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Nota de campos obligatorios
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFCFE4FF).withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info, size: 20, color: Color(0xFF004A77)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Los campos marcados con * son obligatorios',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF004A77),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Botón guardar
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _submitForm,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.check_circle, size: 24),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Agregar Equipo',
                                          style: textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: colorScheme.primary, size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
