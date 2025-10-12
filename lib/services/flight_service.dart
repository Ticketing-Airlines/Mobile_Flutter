import 'dart:convert';
import 'package:http/http.dart' as http;

class FlightService {
  // Replace with your backend's base URL
  final String _baseUrl = "http://localhost:5000/api";

  // Fetch available flights
  Future<List<Map<String, dynamic>>> getAvailableFlights() async {
    final response = await http.get(
      Uri.parse("$_baseUrl/flights/available-flights"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((flight) => Map<String, dynamic>.from(flight)).toList();
    } else {
      throw Exception("Failed to load flights: ${response.statusCode}");
    }
  }
}
