import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:polarnet_flutter/core/constants/api_constants.dart';
import 'package:polarnet_flutter/features/alerts/data/models/alert_dto.dart';

class AlertService {
  final String _baseUrl = '${ApiConstants.supabaseUrl}/rest/v1';
  final String _apiKey = ApiConstants.supabaseAnonKey;

  Future<List<AlertDto>> getAlerts() async {
    final url = Uri.parse('$_baseUrl/alerts?select=*&order=timestamp.desc');

    final response = await http.get(
      url,
      headers: {'apikey': _apiKey, 'Authorization': 'Bearer $_apiKey'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => AlertDto.fromJson(e)).toList();
    } else {
      throw Exception('Error fetching alerts: ${response.statusCode}');
    }
  }

  Future<List<AlertDto>> getAlertsByProviderId(String providerId) async {
    final url = Uri.parse(
      '$_baseUrl/alerts?provider_id=eq.$providerId&select=*&order=timestamp.desc',
    );

    final response = await http.get(
      url,
      headers: {'apikey': _apiKey, 'Authorization': 'Bearer $_apiKey'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => AlertDto.fromJson(e)).toList();
    } else {
      throw Exception('Error fetching alerts: ${response.statusCode}');
    }
  }

  Future<void> createAlert(AlertDto alert) async {
    final url = Uri.parse('$_baseUrl/alerts');

    final response = await http.post(
      url,
      headers: {
        'apikey': _apiKey,
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      body: jsonEncode(alert.toJson()),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(
        'Error creating alert: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<void> acknowledgeAlert(String alertId) async {
    final url = Uri.parse('$_baseUrl/alerts?id=eq.$alertId');

    final response = await http.patch(
      url,
      headers: {
        'apikey': _apiKey,
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'is_acknowledged': true}),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error acknowledging alert: ${response.statusCode}');
    }
  }

  Future<void> acknowledgeAllAlerts() async {
    final url = Uri.parse('$_baseUrl/alerts?is_acknowledged=eq.false');

    final response = await http.patch(
      url,
      headers: {
        'apikey': _apiKey,
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'is_acknowledged': true}),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error acknowledging all alerts: ${response.statusCode}');
    }
  }
}
