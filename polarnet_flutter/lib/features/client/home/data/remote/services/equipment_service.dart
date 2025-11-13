import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:polarnet_flutter/core/constants/api_constants.dart';
import '../models/equipment_dto.dart';

class EquipmentService {
  // Base URL compuesta con Supabase REST API
  final String _baseUrl = '${ApiConstants.supabaseUrl}/rest/v1';
  final String _apiKey = ApiConstants.supabaseAnonKey;

  Future<List<EquipmentDto>> getAllEquipments() async {
    final url = Uri.parse('$_baseUrl/${ApiConstants.equipmentTable}?select=*');

    final response = await http.get(
      url,
      headers: {
        'apikey': _apiKey,
        'Authorization': 'Bearer $_apiKey',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => EquipmentDto.fromJson(e)).toList();
    } else {
      throw Exception(
        'Error ${response.statusCode}: ${response.reasonPhrase}',
      );
    }
  }

  Future<EquipmentDto?> getEquipmentById(int id) async {
    final url = Uri.parse(
      '$_baseUrl/${ApiConstants.equipmentTable}?id=eq.$id&select=*',
    );

    final response = await http.get(
      url,
      headers: {
        'apikey': _apiKey,
        'Authorization': 'Bearer $_apiKey',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      if (jsonList.isNotEmpty) {
        return EquipmentDto.fromJson(jsonList.first);
      }
      return null;
    } else {
      throw Exception(
        'Error ${response.statusCode}: ${response.reasonPhrase}',
      );
    }
  }
}
