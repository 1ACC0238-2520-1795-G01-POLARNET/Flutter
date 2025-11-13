import '../models/provider_service_request.dart';

abstract class ProviderHomeRepository {
  Future<List<ProviderServiceRequest>> getAllServiceRequests();
  Future<List<ProviderServiceRequest>> getServiceRequestsByStatus(String status);
  Future<ProviderServiceRequest?> getServiceRequestById(int id);
  Future<bool> updateServiceRequestStatus(int id, String status);
  Future<bool> deleteServiceRequest(int id);
}
