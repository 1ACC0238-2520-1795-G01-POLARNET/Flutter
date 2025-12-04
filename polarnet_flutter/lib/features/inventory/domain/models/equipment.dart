class Equipment {
  final int id;
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
  final String? createdAt;
  final String? updatedAt;

  Equipment({
    required this.id,
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
    this.createdAt,
    this.updatedAt,
  });
}
