import 'dart:convert';
import 'package:ticketing_flutter/services/api_client.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final ApiClient _apiClient = ApiClient();

  /// Register a new user
  /// Returns true if successful, false otherwise
  Future<bool> registerUser(Map<String, dynamic> userData) async {
    try {
      // Map Flutter app fields to backend DTO
      final requestBody = {
        "FirstName": userData["firstName"],
        "MiddleName": userData["middleName"],
        "LastName": userData["lastName"],
        "Email": userData["email"],
        "PhoneNumber": userData["contactNumber"],
        "Password": userData["password"],
        "DateOfBirth": userData["birthdate"], // Format: "YYYY-MM-DD"
        "Gender": userData["gender"],
      };

      final response = await _apiClient.postUnauthenticated(
        '/users/register',
        body: requestBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Registration successful
        return true;
      } else {
        // Registration failed
        print("Registration Error: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Registration Exception: $e");
      return false;
    }
  }

  /// Login user
  /// Returns LoginResponse if successful, null otherwise
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      final requestBody = {"Email": email, "Password": password};

      final response = await _apiClient.postUnauthenticated(
        '/auth/login',
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Save token and user ID
        if (responseData['token'] != null && responseData['userId'] != null) {
          await _apiClient.saveToken(
            responseData['token'],
            responseData['userId'],
          );
        }

        return responseData;
      } else {
        print("Login Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Login Exception: $e");
      return null;
    }
  }

  /// Logout user
  Future<void> logout() async {
    await _apiClient.clearToken();
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _apiClient.isLoggedIn();
  }

  /// Get current user information
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final userId = await _apiClient.getUserId();
      if (userId == null) return null;

      final response = await _apiClient.get('/users/$userId');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print("Get User Exception: $e");
      return null;
    }
  }
}
