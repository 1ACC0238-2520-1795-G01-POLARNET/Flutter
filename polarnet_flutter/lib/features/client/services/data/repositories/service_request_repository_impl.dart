import 'package:polarnet_flutter/features/client/services/data/remote/service_request_service.dart';
import 'package:polarnet_flutter/features/client/services/domain/models/service_request.dart';
import 'package:polarnet_flutter/features/client/services/domain/repositories/service_request_repository.dart';

class ServiceRequestRepositoryImpl implements ServiceRequestRepository {
  final ServiceRequestService _service;

  ServiceRequestRepositoryImpl(this._service);

  @override
  Future<List<ServiceRequest>> getAllServiceRequests() async {
    try {
      final dtos = await _service.getAllServiceRequests();
      return dtos.map((dto) => dto.toDomain()).toList();
    } catch (e) {
      throw Exception('Error getting all service requests: $e');
    }
  }

  @override
  Future<List<ServiceRequest>> getServiceRequestsByClient(int clientId) async {
    try {
      final dtos = await _service.getServiceRequestsByClient(clientId);
      return dtos.map((dto) => dto.toDomain()).toList();
    } catch (e) {
      throw Exception('Error getting service requests by client: $e');
    }
  }

  @override
  Future<void> insert(ServiceRequest request) async {
    // TODO: Implementar cuando se necesite crear solicitudes
    throw UnimplementedError('Insert not implemented yet');
  }

  @override
  Future<void> delete(ServiceRequest request) async {
    // TODO: Implementar cuando se necesite eliminar solicitudes
    throw UnimplementedError('Delete not implemented yet');
  }
}
