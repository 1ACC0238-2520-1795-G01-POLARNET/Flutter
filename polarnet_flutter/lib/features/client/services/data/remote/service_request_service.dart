import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:polarnet_flutter/core/constants/api_constants.dart';
import 'package:polarnet_flutter/features/client/services/data/models/service_request_dto.dart';

class ServiceRequestService {
  final String _baseUrl = '${ApiConstants.supabaseUrl}/rest/v1';
  final String _apiKey = ApiConstants.supabaseAnonKey;

  Future<List<ServiceRequestDto>> getAllServiceRequests({
    String select = '*',
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/service_requests?select=$select');
      
      final response = await http.get(
        url,
        headers: {
          'apikey': _apiKey,
          'Authorization': 'Bearer $_apiKey',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        return data.map((json) => ServiceRequestDto.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      throw Exception('Error fetching service requests: $e');
    }
  }

  Future<List<ServiceRequestDto>> getServiceRequestsByClient(
    int clientId, {
    String select = '*',
  }) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/service_requests?client_id=eq.$clientId&select=$select',
      );
      
      final response = await http.get(
        url,
        headers: {
          'apikey': _apiKey,
          'Authorization': 'Bearer $_apiKey',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        return data.map((json) => ServiceRequestDto.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      throw Exception('Error fetching service requests by client: $e');
    }
  }

  Future<ServiceRequestDto?> getServiceRequestById(
    int id, {
    String select = '*',
  }) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/service_requests?id=eq.$id&select=$select',
      );
      
      final response = await http.get(
        url,
        headers: {
          'apikey': _apiKey,
          'Authorization': 'Bearer $_apiKey',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        if (data.isNotEmpty) {
          return ServiceRequestDto.fromJson(data.first);
        }
      }

      return null;
    } catch (e) {
      throw Exception('Error fetching service request by id: $e');
    }
  }
}
