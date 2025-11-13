import 'package:polarnet_flutter/features/client/services/domain/models/service_request.dart';

abstract class ServiceRequestRepository {
  Future<List<ServiceRequest>> getAllServiceRequests();
  Future<List<ServiceRequest>> getServiceRequestsByClient(int clientId);
  Future<void> insert(ServiceRequest request);
  Future<void> delete(ServiceRequest request);
}
