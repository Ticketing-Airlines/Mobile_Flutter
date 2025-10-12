import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final String _baseUrl =
      "http://your-backend-url/api"; // Replace with your backend URL

  Future<bool> registerUser(Map<String, dynamic> userData) async {
    final url = Uri.parse("$_baseUrl/users/register");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 201) {
        // Registration successful
        return true;
      } else {
        // Registration failed
        print("Error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }
}
