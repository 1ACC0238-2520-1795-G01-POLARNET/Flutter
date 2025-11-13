import 'package:polarnet_flutter/shared/domain/models/equipment.dart';

class ProviderInventoryState {
  final List<Equipment> allEquipments;
  final String selectedCategory;
  final bool showOnlyAvailable;
  final bool isLoading;
  final String? errorMessage;

  ProviderInventoryState({
    this.allEquipments = const [],
    this.selectedCategory = 'all',
    this.showOnlyAvailable = false,
    this.isLoading = false,
    this.errorMessage,
  });

  List<Equipment> get filteredEquipments {
    var equipments = allEquipments;

    // Filter by category
    if (selectedCategory != 'all') {
      equipments = equipments
          .where((e) => e.category == selectedCategory)
          .toList();
    }

    // Filter by availability
    if (showOnlyAvailable) {
      equipments = equipments.where((e) => e.available).toList();
    }

    return equipments;
  }

  List<String> get categories {
    final categoriesSet = allEquipments.map((e) => e.category).toSet();
    return categoriesSet.toList()..sort();
  }

  ProviderInventoryState copyWith({
    List<Equipment>? allEquipments,
    String? selectedCategory,
    bool? showOnlyAvailable,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProviderInventoryState(
      allEquipments: allEquipments ?? this.allEquipments,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      showOnlyAvailable: showOnlyAvailable ?? this.showOnlyAvailable,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
