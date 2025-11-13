import 'dart:developer' as developer;

import 'package:polarnet_flutter/features/client/home/data/remote/services/equipment_service.dart';
import 'package:polarnet_flutter/features/client/home/domain/repositories/equipment_repository.dart';

import '../../../../../shared/domain/models/equipment.dart';


class EquipmentRepositoryImpl implements EquipmentRepository {
  final EquipmentService service;

  EquipmentRepositoryImpl(this.service);

  @override
  Future<List<Equipment>> getAllEquipments() async {
    try {
      final dtos = await service.getAllEquipments();
      return dtos
          .map(
            (dto) => Equipment(
              id: dto.id,
              providerId: dto.providerId,
              name: dto.name,
              brand: dto.brand,
              model: dto.model,
              category: dto.category,
              description: dto.description,
              thumbnail: dto.thumbnail,
              specifications: dto.specifications,
              available: dto.available,
              location: dto.location,
              pricePerMonth: dto.pricePerMonth,
              purchasePrice: dto.purchasePrice,
              createdAt: dto.createdAt,
              updatedAt: dto.updatedAt,
            ),
          )
          .toList();
    } catch (e) {
      developer.log('Error fetching equipments: $e');
      return [];
    }
  }
  @override
  Future<Equipment?> getEquipmentById(int id) async {
    try {
      final dto = await service.getEquipmentById(id);
      if (dto == null) return null;
      return Equipment(
        id: dto.id,
        providerId: dto.providerId,
        name: dto.name,
        brand: dto.brand,
        model: dto.model,
        category: dto.category,
        description: dto.description,
        thumbnail: dto.thumbnail,
        specifications: dto.specifications,
        available: dto.available,
        location: dto.location,
        pricePerMonth: dto.pricePerMonth,
        purchasePrice: dto.purchasePrice,
        createdAt: dto.createdAt,
        updatedAt: dto.updatedAt,
      );
    } catch (e) {
      developer.log('Error fetching equipment by id: $e');
      return null;
    }
  }
}
