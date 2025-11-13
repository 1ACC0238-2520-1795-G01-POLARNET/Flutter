import 'package:equatable/equatable.dart';

abstract class AddEquipmentEvent extends Equatable {
  const AddEquipmentEvent();

  @override
  List<Object?> get props => [];
}

class AddEquipment extends AddEquipmentEvent {
  final int providerId;
  final String name;
  final String? brand;
  final String? model;
  final String category;
  final String? description;
  final String? thumbnail;
  final double pricePerMonth;
  final double purchasePrice;
  final String? location;
  final bool available;

  const AddEquipment({
    required this.providerId,
    required this.name,
    this.brand,
    this.model,
    required this.category,
    this.description,
    this.thumbnail,
    required this.pricePerMonth,
    required this.purchasePrice,
    this.location,
    required this.available,
  });

  @override
  List<Object?> get props => [
        providerId,
        name,
        brand,
        model,
        category,
        description,
        thumbnail,
        pricePerMonth,
        purchasePrice,
        location,
        available,
      ];
}

class ResetAddEquipment extends AddEquipmentEvent {
  const ResetAddEquipment();
}
