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
}
