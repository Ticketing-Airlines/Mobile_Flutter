import 'dart:convert';
import 'package:ticketing_flutter/services/flight.dart';
import 'package:ticketing_flutter/services/api_client.dart';
import 'package:intl/intl.dart';

class FlightService {
  static final FlightService _instance = FlightService._internal();
  factory FlightService() => _instance;
  FlightService._internal();

  final ApiClient _apiClient = ApiClient();

  /// Get all flights from the backend
  Future<List<Flight>> getAllFlights() async {
    try {
      final response = await _apiClient.get('/flights');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Flight.fromJson(json)).toList();
      } else {
        print(
          "Error fetching flights: ${response.statusCode} - ${response.body}",
        );
        return [];
      }
    } catch (e) {
      print("Exception fetching flights: $e");
      return [];
    }
  }

  /// Get flights filtered by origin, destination, and departure date
  /// Note: Currently filters client-side since backend doesn't have a search endpoint
  Future<List<Flight>> getFlights({
    required String from,
    required String to,
    required String departureDate,
  }) async {
    try {
      // Get all flights from backend
      final allFlights = await getAllFlights();

      // Parse the departure date
      final dateFormat = DateFormat('yyyy-MM-dd');
      DateTime targetDate;
      try {
        targetDate = dateFormat.parse(departureDate);
      } catch (e) {
        print("Error parsing date: $e");
        return [];
      }

      // Filter flights
      return allFlights.where((flight) {
        // Match origin (case-insensitive, partial match)
        final fromMatch =
            flight.from.toLowerCase().contains(from.toLowerCase()) ||
            from.toLowerCase().contains(flight.from.toLowerCase());

        // Match destination (case-insensitive, partial match)
        final toMatch =
            flight.to.toLowerCase().contains(to.toLowerCase()) ||
            to.toLowerCase().contains(flight.to.toLowerCase());

        // Match date (same day)
        final flightDate = DateTime(
          flight.departureTime.year,
          flight.departureTime.month,
          flight.departureTime.day,
        );
        final targetDateOnly = DateTime(
          targetDate.year,
          targetDate.month,
          targetDate.day,
        );
        final dateMatch = flightDate.isAtSameMomentAs(targetDateOnly);

        return fromMatch && toMatch && dateMatch;
      }).toList();
    } catch (e) {
      print("Exception in getFlights: $e");
      return [];
    }
  }

  /// Get a specific flight by ID
  Future<Flight?> getFlightById(int id) async {
    try {
      final response = await _apiClient.get('/flights/$id');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Flight.fromJson(data);
      } else {
        print(
          "Error fetching flight: ${response.statusCode} - ${response.body}",
        );
        return null;
      }
    } catch (e) {
      print("Exception fetching flight: $e");
      return null;
    }
  }

  /// Get flight prices for a specific flight
  /// This would need a FlightPrice endpoint in the backend
  Future<List<Map<String, dynamic>>> getFlightPrices(int flightId) async {
    try {
      final response = await _apiClient.get('/flightprices/flight/$flightId');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        print(
          "Error fetching flight prices: ${response.statusCode} - ${response.body}",
        );
        return [];
      }
    } catch (e) {
      print("Exception fetching flight prices: $e");
      return [];
    }
  }
}
