import 'dart:convert';

class EquipmentDto {
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

  EquipmentDto({
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

  /// Factory para construir desde JSON
  factory EquipmentDto.fromJson(Map<String, dynamic> json) {
    return EquipmentDto(
      id: json['id'] as int,
      providerId: json['provider_id'] as int,
      name: json['name'] as String,
      brand: json['brand'] as String?,
      model: json['model'] as String?,
      category: json['category'] as String,
      description: json['description'] as String?,
      thumbnail: json['thumbnail'] as String?,
      specifications: json['specifications'] != null
          ? Map<String, String>.from(json['specifications'])
          : null,
      available: json['available'] as bool,
      location: json['location'] as String?,
      pricePerMonth: (json['price_per_month'] as num).toDouble(),
      purchasePrice: (json['purchase_price'] as num).toDouble(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  /// Método para convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Copia modificable (como `copyWith` en Kotlin)
  EquipmentDto copyWith({
    int? id,
    int? providerId,
    String? name,
    String? brand,
    String? model,
    String? category,
    String? description,
    String? thumbnail,
    Map<String, String>? specifications,
    bool? available,
    String? location,
    double? pricePerMonth,
    double? purchasePrice,
    String? createdAt,
    String? updatedAt,
  }) {
    return EquipmentDto(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      category: category ?? this.category,
      description: description ?? this.description,
      thumbnail: thumbnail ?? this.thumbnail,
      specifications: specifications ?? this.specifications,
      available: available ?? this.available,
      location: location ?? this.location,
      pricePerMonth: pricePerMonth ?? this.pricePerMonth,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => jsonEncode(toJson());
}
