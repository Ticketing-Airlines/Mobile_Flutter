import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  // TODO: Update this with your actual backend URL
  // For local development, use: http://10.0.2.2:5000 (Android emulator)
  // For physical device, use your computer's IP: http://192.168.x.x:5000
  // For production, use your deployed backend URL
  static const String baseUrl = "http://localhost:5000/api";

  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  // Get stored authentication token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Save authentication token
  Future<void> saveToken(String token, int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setInt(_userIdKey, userId);
  }

  // Clear authentication token (logout)
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
  }

  // Get current user ID
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Make authenticated GET request
  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final token = await getToken();
    final defaultHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    return await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: defaultHeaders,
    );
  }

  // Make authenticated POST request
  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final token = await getToken();
    final defaultHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    return await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: defaultHeaders,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  // Make authenticated PUT request
  Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final token = await getToken();
    final defaultHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    return await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: defaultHeaders,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  // Make authenticated DELETE request
  Future<http.Response> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final token = await getToken();
    final defaultHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    return await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: defaultHeaders,
    );
  }

  // Make unauthenticated POST request (for login/register)
  Future<http.Response> postUnauthenticated(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    return await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: body != null ? jsonEncode(body) : null,
    );
  }
}
