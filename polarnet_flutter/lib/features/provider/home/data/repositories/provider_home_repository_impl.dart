import 'dart:developer' as developer;
import 'package:polarnet_flutter/features/provider/home/data/remote/provider_home_service.dart';
import 'package:polarnet_flutter/features/provider/home/domain/models/provider_service_request.dart';
import 'package:polarnet_flutter/features/provider/home/domain/repositories/provider_home_repository.dart';

class ProviderHomeRepositoryImpl implements ProviderHomeRepository {
  final ProviderHomeService _service;

  ProviderHomeRepositoryImpl(this._service);

  @override
  Future<List<ProviderServiceRequest>> getAllServiceRequests() async {
    try {
      developer.log(
        '📦 [ProviderHomeRepository] Getting all service requests',
        name: 'PolarNet',
      );

      final dtos = await _service.getAllServiceRequests();
      final requests = dtos.map((dto) => dto.toDomain()).toList();

      developer.log(
        '✅ [ProviderHomeRepository] ${requests.length} requests obtained',
        name: 'PolarNet',
      );

      return requests;
    } catch (e) {
      developer.log(
        '💥 [ProviderHomeRepository] Exception: $e',
        name: 'PolarNet',
        error: e,
      );
      return [];
    }
  }

  @override
  Future<List<ProviderServiceRequest>> getServiceRequestsByStatus(
    String status,
  ) async {
    try {
      developer.log(
        '📦 [ProviderHomeRepository] Getting requests by status: $status',
        name: 'PolarNet',
      );

      final dtos = await _service.getServiceRequestsByStatus(status);
      final requests = dtos.map((dto) => dto.toDomain()).toList();

      developer.log(
        '✅ [ProviderHomeRepository] ${requests.length} requests obtained',
        name: 'PolarNet',
      );

      return requests;
    } catch (e) {
      developer.log(
        '💥 [ProviderHomeRepository] Exception: $e',
        name: 'PolarNet',
        error: e,
      );
      return [];
    }
  }

  @override
  Future<ProviderServiceRequest?> getServiceRequestById(int id) async {
    try {
      developer.log(
        '📦 [ProviderHomeRepository] Getting request by ID: $id',
        name: 'PolarNet',
      );

      final dto = await _service.getServiceRequestById(id);
      if (dto != null) {
        developer.log(
          '✅ [ProviderHomeRepository] Request found',
          name: 'PolarNet',
        );
        return dto.toDomain();
      }

      developer.log(
        '❌ [ProviderHomeRepository] Request not found',
        name: 'PolarNet',
      );
      return null;
    } catch (e) {
      developer.log(
        '💥 [ProviderHomeRepository] Exception: $e',
        name: 'PolarNet',
        error: e,
      );
      return null;
    }
  }

  @override
  Future<bool> updateServiceRequestStatus(int id, String status) async {
    try {
      developer.log(
        '📦 [ProviderHomeRepository] Updating status for ID $id to $status',
        name: 'PolarNet',
      );

      final dto = await _service.updateServiceRequestStatus(id, status);
      if (dto != null) {
        developer.log(
          '✅ [ProviderHomeRepository] Status updated successfully',
          name: 'PolarNet',
        );
        return true;
      }

      developer.log(
        '❌ [ProviderHomeRepository] Failed to update status',
        name: 'PolarNet',
      );
      return false;
    } catch (e) {
      developer.log(
        '💥 [ProviderHomeRepository] Exception: $e',
        name: 'PolarNet',
        error: e,
      );
      return false;
    }
  }

  @override
  Future<bool> deleteServiceRequest(int id) async {
    try {
      developer.log(
        '📦 [ProviderHomeRepository] Deleting request ID: $id',
        name: 'PolarNet',
      );

      final success = await _service.deleteServiceRequest(id);

      if (success) {
        developer.log(
          '✅ [ProviderHomeRepository] Request deleted successfully',
          name: 'PolarNet',
        );
      } else {
        developer.log(
          '❌ [ProviderHomeRepository] Failed to delete request',
          name: 'PolarNet',
        );
      }

      return success;
    } catch (e) {
      developer.log(
        '💥 [ProviderHomeRepository] Exception: $e',
        name: 'PolarNet',
        error: e,
      );
      return false;
    }
  }
}
