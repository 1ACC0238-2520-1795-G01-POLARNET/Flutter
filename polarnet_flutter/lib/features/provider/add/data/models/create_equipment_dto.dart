class CreateEquipmentDto {
  final int providerId;
  final String name;
  final String? brand;
  final String? model;
  final String category;
  final String? description;
  final String? thumbnail;
  final Map<String, String>? specifications;
  final bool available;
  final String? location;
  final double pricePerMonth;
  final double purchasePrice;

  CreateEquipmentDto({
    required this.providerId,
    required this.name,
    this.brand,
    this.model,
    required this.category,
    this.description,
    this.thumbnail,
    this.specifications,
    required this.available,
    this.location,
    required this.pricePerMonth,
    required this.purchasePrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'provider_id': providerId,
      'name': name,
      'brand': brand,
      'model': model,
      'category': category,
      'description': description,
      'thumbnail': thumbnail,
      'specifications': specifications,
      'available': available,
      'location': location,
      'price_per_month': pricePerMonth,
      'purchase_price': purchasePrice,
    };
  }
}
