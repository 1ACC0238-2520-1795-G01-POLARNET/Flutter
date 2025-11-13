import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:polarnet_flutter/core/constants/api_constants.dart';
import '../models/provider_service_request_dto.dart';

class ProviderHomeService {
  final String _baseUrl = '${ApiConstants.supabaseUrl}/rest/v1';
  final String _apiKey = ApiConstants.supabaseAnonKey;

  // Obtener todas las solicitudes con relaciones (equipment y client)
  Future<List<ProviderServiceRequestDto>> getAllServiceRequests() async {
    try {
      final url = Uri.parse(
        '$_baseUrl/service_requests?select=*,equipment(*),client:users!client_id(*)',
      );

      developer.log(
        '🌐 [ProviderHomeService] GET: $url',
        name: 'PolarNet',
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
        developer.log(
          '✅ [ProviderHomeService] Solicitudes obtenidas: ${data.length}',
          name: 'PolarNet',
        );
        return data
            .map((json) => ProviderServiceRequestDto.fromJson(json))
            .toList();
      }

      developer.log(
        '❌ [ProviderHomeService] Error: ${response.statusCode} - ${response.body}',
        name: 'PolarNet',
      );
      return [];
    } catch (e) {
      developer.log(
        '💥 [ProviderHomeService] Exception: $e',
        name: 'PolarNet',
        error: e,
      );
      throw Exception('Error fetching service requests: $e');
    }
  }

  // Filtrar por status
  Future<List<ProviderServiceRequestDto>> getServiceRequestsByStatus(
    String status,
  ) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/service_requests?status=eq.$status&select=*,equipment(*),client:users!client_id(*)',
      );

      developer.log(
        '🌐 [ProviderHomeService] GET by status [$status]: $url',
        name: 'PolarNet',
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
        developer.log(
          '✅ [ProviderHomeService] Solicitudes por status: ${data.length}',
          name: 'PolarNet',
        );
        return data
            .map((json) => ProviderServiceRequestDto.fromJson(json))
            .toList();
      }

      developer.log(
        '❌ [ProviderHomeService] Error: ${response.statusCode}',
        name: 'PolarNet',
      );
      return [];
    } catch (e) {
      developer.log(
        '💥 [ProviderHomeService] Exception: $e',
        name: 'PolarNet',
        error: e,
      );
      throw Exception('Error fetching service requests by status: $e');
    }
  }

  // Obtener solicitud por ID
  Future<ProviderServiceRequestDto?> getServiceRequestById(int id) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/service_requests?id=eq.$id&select=*,equipment(*),client:users!client_id(*)',
      );

      developer.log(
        '🌐 [ProviderHomeService] GET by ID [$id]: $url',
        name: 'PolarNet',
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
          developer.log(
            '✅ [ProviderHomeService] Solicitud encontrada',
            name: 'PolarNet',
          );
          return ProviderServiceRequestDto.fromJson(data.first);
        }
      }

      developer.log(
        '❌ [ProviderHomeService] Solicitud no encontrada',
        name: 'PolarNet',
      );
      return null;
    } catch (e) {
      developer.log(
        '💥 [ProviderHomeService] Exception: $e',
        name: 'PolarNet',
        error: e,
      );
      throw Exception('Error fetching service request by ID: $e');
    }
  }

  // Actualizar estado de solicitud
  Future<ProviderServiceRequestDto?> updateServiceRequestStatus(
    int id,
    String status,
  ) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/service_requests?id=eq.$id',
      );

      developer.log(
        '🌐 [ProviderHomeService] PATCH status [$status] for ID [$id]',
        name: 'PolarNet',
      );

      final body = jsonEncode({'status': status});

      final response = await http.patch(
        url,
        headers: {
          'apikey': _apiKey,
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'Prefer': 'return=representation',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        if (data.isNotEmpty) {
          developer.log(
            '✅ [ProviderHomeService] Estado actualizado exitosamente',
            name: 'PolarNet',
          );

          final dto = ProviderServiceRequestDto.fromJson(data.first);

          // Si el estado es "completed", crear registro en client_equipment
          if (status == 'completed') {
            await _createClientEquipment(dto);
          }

          return dto;
        }
      }

      developer.log(
        '❌ [ProviderHomeService] Error: ${response.statusCode} - ${response.body}',
        name: 'PolarNet',
      );
      return null;
    } catch (e) {
      developer.log(
        '💥 [ProviderHomeService] Exception: $e',
        name: 'PolarNet',
        error: e,
      );
      throw Exception('Error updating service request status: $e');
    }
  }

  // Crear registro en client_equipment
  Future<void> _createClientEquipment(
    ProviderServiceRequestDto dto,
  ) async {
    try {
      final url = Uri.parse('$_baseUrl/client_equipment');

      developer.log(
        '🌐 [ProviderHomeService] POST client_equipment',
        name: 'PolarNet',
      );

      final body = jsonEncode({
        'client_id': dto.clientId,
        'equipment_id': dto.equipmentId,
        'ownership_type': 'rented',
        'start_date': dto.startDate,
        'end_date': dto.endDate,
        'status': 'active',
        'notes': 'Equipo rentado - Solicitud #${dto.id}',
      });

      final response = await http.post(
        url,
        headers: {
          'apikey': _apiKey,
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'Prefer': 'return=representation',
        },
        body: body,
      );

      if (response.statusCode == 201) {
        developer.log(
          '✅ [ProviderHomeService] Client_equipment creado exitosamente',
          name: 'PolarNet',
        );
      } else {
        developer.log(
          '❌ [ProviderHomeService] Error al crear client_equipment: ${response.statusCode}',
          name: 'PolarNet',
        );
      }
    } catch (e) {
      developer.log(
        '💥 [ProviderHomeService] Excepción al crear client_equipment: $e',
        name: 'PolarNet',
        error: e,
      );
    }
  }

  // Eliminar solicitud
  Future<bool> deleteServiceRequest(int id) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/service_requests?id=eq.$id',
      );

      developer.log(
        '🌐 [ProviderHomeService] DELETE ID [$id]',
        name: 'PolarNet',
      );

      final response = await http.delete(
        url,
        headers: {
          'apikey': _apiKey,
          'Authorization': 'Bearer $_apiKey',
        },
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        developer.log(
          '✅ [ProviderHomeService] Solicitud eliminada exitosamente',
          name: 'PolarNet',
        );
        return true;
      }

      developer.log(
        '❌ [ProviderHomeService] Error: ${response.statusCode}',
        name: 'PolarNet',
      );
      return false;
    } catch (e) {
      developer.log(
        '💥 [ProviderHomeService] Exception: $e',
        name: 'PolarNet',
        error: e,
      );
      throw Exception('Error deleting service request: $e');
    }
  }
}
