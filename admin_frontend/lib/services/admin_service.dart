import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'admin_service.g.dart';

@riverpod
AdminService adminService(Ref ref) => AdminService();

class AdminService {
  final String baseUrl = "http://localhost:8000/admin";

  Future<Map<String, dynamic>> fetchDashboardData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('admin_token');

    final response = await http.get(
      Uri.parse("$baseUrl/dashboard-stats"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load dashboard. Status: ${response.statusCode}");
    }
  }

  Future<bool> adminLogin(String username, String password) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/login"), // Corrected from /token to /login
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username, 
        'password': password
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('admin_token', data['access_token']);
      return true;
    }
    return false;
  } catch (e) {
    print("Login Error: $e");
    return false;
  }
}

Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('admin_token');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('admin_token');
  }

  Future<Map<String, dynamic>> fetchAdminDashboardData() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('admin_token');

  final response = await http.get(
    Uri.parse("$baseUrl/dashboard-stats"),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception("Failed to load dashboard data");
  }
}

Future<Map<String, dynamic>> fetchFeedbackAnalytics() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('admin_token');

  final response = await http.get(
    Uri.parse("$baseUrl/feedback-analytics"),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception("Failed to load feedback analytics. Status: ${response.statusCode}");
  }
}

}