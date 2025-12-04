import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:polarnet_flutter/core/constants/api_constants.dart';
import 'package:polarnet_flutter/features/add/data/models/create_equipment_dto.dart';
import 'package:polarnet_flutter/features/inventory/data/models/equipment_dto.dart';

class AddEquipmentService {
  final String _baseUrl = '${ApiConstants.supabaseUrl}/rest/v1';
  final String _apiKey = ApiConstants.supabaseAnonKey;

  Future<EquipmentDto?> createEquipment(CreateEquipmentDto equipment) async {
    try {
      final url = Uri.parse('$_baseUrl/equipment');

      final response = await http.post(
        url,
        headers: {
          'apikey': _apiKey,
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'Prefer': 'return=representation',
        },
        body: jsonEncode(equipment.toJson()),
      );

      if (response.statusCode == 201) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        if (data.isNotEmpty) {
          return EquipmentDto.fromJson(data.first);
        }
      }

      return null;
    } catch (e) {
      throw Exception('Error creating equipment: $e');
    }
  }
}
