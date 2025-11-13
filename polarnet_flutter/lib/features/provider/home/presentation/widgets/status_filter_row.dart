import 'package:flutter/material.dart';

class StatusFilterRow extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const StatusFilterRow({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      ('all', 'Todas'),
      ('pending', 'Pendientes'),
      ('in_progress', 'En Progreso'),
      ('completed', 'Completadas'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: filters.map((filter) {
          final key = filter.$1;
          final label = filter.$2;
          final isSelected = selectedFilter == key;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              onSelected: (_) => onFilterSelected(key),
              label: Text(label),
              avatar: isSelected
                  ? const Icon(Icons.check, size: 18)
                  : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
