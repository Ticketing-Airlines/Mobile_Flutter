import 'package:flutter/material.dart';

class Flight {
  final String flightNo;
  final String airline;
  final String from;
  final String to;
  final String date;
  final String departure; // e.g., "08:00 AM"
  final String arrival; // e.g., "09:30 AM"
  final String duration; // e.g., "1h 30m"
  final String status; // e.g., "On Time"
  final String price; // e.g., "\$350"

  Flight({
    required this.flightNo,
    required this.airline,
    required this.from,
    required this.to,
    required this.date,
    required this.departure,
    required this.arrival,
    required this.duration,
    required this.status,
    required this.price,
  });

  // Convert to Map for search page compatibility
  Map<String, String> toSearchMap() {
    return {
      "from": from,
      "to": to,
      "airline": airline,
      "date": date, // You can add date field to Flight class if needed
      "time": departure,
      "price": price,
    };
  }
}

class FlightService {
  static final FlightService _instance = FlightService._internal();
  factory FlightService() => _instance;
  FlightService._internal();

  final List<Flight> _flights = [];

  List<Flight> get flights => List.unmodifiable(_flights);

  void addFlight(Flight flight) {
    _flights.add(flight);
  }

  void removeFlight(String flightNo) {
    _flights.removeWhere((flight) => flight.flightNo == flightNo);
  }

  List<Map<String, String>> getSearchFlights() {
    return _flights.map((flight) => flight.toSearchMap()).toList();
  }
}
