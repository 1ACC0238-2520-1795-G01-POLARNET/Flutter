import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:polarnet_flutter/core/constants/api_constants.dart';
import '../models/client_equipment_dto.dart';

class ClientEquipmentService {
  final String _baseUrl = '${ApiConstants.supabaseUrl}/rest/v1';
  final String _apiKey = ApiConstants.supabaseAnonKey;

  /// Obtener todos los equipos de todos los clientes
  Future<List<ClientEquipmentDto>> getAllClientEquipments() async {
    final url = Uri.parse(
      '$_baseUrl/client_equipment?select=*,equipment(*)',
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
      return jsonList.map((e) => ClientEquipmentDto.fromJson(e)).toList();
    } else {
      throw Exception(
        'Error ${response.statusCode}: ${response.reasonPhrase}',
      );
    }
  }

  /// Obtener los equipos de un cliente específico
  Future<List<ClientEquipmentDto>> getClientEquipmentsByClientId(
    int clientId,
  ) async {
    final url = Uri.parse(
      '$_baseUrl/client_equipment?client_id=eq.$clientId&select=*,equipment(*)',
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
      return jsonList.map((e) => ClientEquipmentDto.fromJson(e)).toList();
    } else {
      throw Exception(
        'Error ${response.statusCode}: ${response.reasonPhrase}',
      );
    }
  }

  /// Obtener un registro específico por ID
  Future<ClientEquipmentDto?> getClientEquipmentById(int id) async {
    final url = Uri.parse(
      '$_baseUrl/client_equipment?id=eq.$id&select=*,equipment(*)',
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
        return ClientEquipmentDto.fromJson(jsonList.first);
      }
      return null;
    } else {
      throw Exception(
        'Error ${response.statusCode}: ${response.reasonPhrase}',
      );
    }
  }

  /// Insertar un nuevo registro
  Future<void> insertClientEquipment(ClientEquipmentDto dto) async {
    final url = Uri.parse('$_baseUrl/client_equipment');

    final response = await http.post(
      url,
      headers: {
        'apikey': _apiKey,
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      body: jsonEncode(dto.toJson()),
    );

    if (response.statusCode != 201 && response.statusCode != 204) {
      throw Exception(
        'Error ${response.statusCode}: ${response.reasonPhrase}',
      );
    }
  }

  /// Eliminar un registro
  Future<void> deleteClientEquipment(int id) async {
    final url = Uri.parse('$_baseUrl/client_equipment?id=eq.$id');

    final response = await http.delete(
      url,
      headers: {
        'apikey': _apiKey,
        'Authorization': 'Bearer $_apiKey',
      },
    );

    if (response.statusCode != 204) {
      throw Exception(
        'Error ${response.statusCode}: ${response.reasonPhrase}',
      );
    }
  }
}
