import 'package:intl/intl.dart';

class Flight {
  final int id;
  final String flightNumber;
  final String from;
  final String to;
  final String airline;
  final String date;
  final String time;
  final double price;
  final DateTime departureTime;
  final DateTime arrivalTime;

  Flight({
    required this.id,
    required this.flightNumber,
    required this.from,
    required this.to,
    required this.airline,
    required this.date,
    required this.time,
    required this.price,
    required this.departureTime,
    required this.arrivalTime,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    // Parse dates from backend
    final departureTime = DateTime.parse(json['departureTime']);
    final arrivalTime = DateTime.parse(json['arrivalTime']);

    // Format date and time for display
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('hh:mm a');

    return Flight(
      id: json['id'] ?? 0,
      flightNumber: json['flightNumber'] ?? '',
      from: json['origin'] ?? '',
      to: json['destination'] ?? '',
      airline: json['aircraftName'] ?? 'Airline',
      date: dateFormat.format(departureTime),
      time: timeFormat.format(departureTime),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      departureTime: departureTime,
      arrivalTime: arrivalTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'flightNumber': flightNumber,
      'origin': from,
      'destination': to,
      'aircraftName': airline,
      'departureTime': departureTime.toIso8601String(),
      'arrivalTime': arrivalTime.toIso8601String(),
      'price': price,
    };
  }
}
