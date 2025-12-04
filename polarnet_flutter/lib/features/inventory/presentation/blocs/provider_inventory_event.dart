abstract class ProviderInventoryEvent {}

class LoadProviderEquipments extends ProviderInventoryEvent {
  final int providerId;

  LoadProviderEquipments(this.providerId);
}

class FilterByCategory extends ProviderInventoryEvent {
  final String category;

  FilterByCategory(this.category);
}

class ToggleAvailabilityFilter extends ProviderInventoryEvent {}

class RefreshProviderEquipments extends ProviderInventoryEvent {
  final int providerId;

  RefreshProviderEquipments(this.providerId);
}
