import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:polarnet_flutter/core/constants/api_constants.dart';
import 'package:polarnet_flutter/features/dashboard/data/models/iot_sensor_dto.dart';

class IoTService {
  final String _baseUrl = '${ApiConstants.supabaseUrl}/rest/v1';
  final String _apiKey = ApiConstants.supabaseAnonKey;

  Future<List<IoTSensorDto>> getSensorsByEquipment(int equipmentId) async {
    final url = Uri.parse(
      '$_baseUrl/iot_sensors?equipment_id=eq.$equipmentId&select=*,iot_readings(*)&iot_readings.order=timestamp.desc&iot_readings.limit=20',
    );

    final response = await http.get(
      url,
      headers: {'apikey': _apiKey, 'Authorization': 'Bearer $_apiKey'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => IoTSensorDto.fromJson(json)).toList();
    } else {
      throw Exception('Error fetching IoT data');
    }
  }

  /// Obtiene el client_id del equipo actualmente alquilado
  /// Consulta la tabla service_requests donde el equipo está activo (status = 'approved' o 'active')
  Future<String?> getActiveClientForEquipment(int equipmentId) async {
    try {
      // Buscar en service_requests con status approved o active
      var url = Uri.parse(
        '$_baseUrl/service_requests?equipment_id=eq.$equipmentId&status=in.(approved,active)&select=client_id,status&limit=1',
      );

      var response = await http.get(
        url,
        headers: {'apikey': _apiKey, 'Authorization': 'Bearer $_apiKey'},
      );

      // ignore: avoid_print
      print('🔍 Buscando cliente para equipo $equipmentId en service_requests');
      // ignore: avoid_print
      print('📡 Response status: ${response.statusCode}');
      // ignore: avoid_print
      print('📦 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final clientId = data.first['client_id']?.toString();
          final status = data.first['status']?.toString();
          // ignore: avoid_print
          print('✅ Cliente encontrado: $clientId (status: $status)');
          return clientId;
        }
      }

      // Si no encontramos con esos status, intentar sin filtro de status
      url = Uri.parse(
        '$_baseUrl/service_requests?equipment_id=eq.$equipmentId&select=client_id,status&order=created_at.desc&limit=1',
      );

      response = await http.get(
        url,
        headers: {'apikey': _apiKey, 'Authorization': 'Bearer $_apiKey'},
      );

      // ignore: avoid_print
      print('🔍 Buscando cliente sin filtro de status');
      // ignore: avoid_print
      print('📦 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final clientId = data.first['client_id']?.toString();
          final status = data.first['status']?.toString();
          // ignore: avoid_print
          print('✅ Cliente encontrado: $clientId (status: $status)');
          return clientId;
        }
      }

      // ignore: avoid_print
      print('⚠️ No se encontró cliente para equipo $equipmentId');
      return null;
    } catch (e) {
      // ignore: avoid_print
      print('❌ Error fetching active client: $e');
      return null;
    }
  }
}
