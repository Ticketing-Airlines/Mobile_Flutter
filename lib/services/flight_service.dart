import 'package:ticketing_flutter/services/flight.dart';

class FlightService {
  List<Flight> getFlights({
    required String from,
    required String to,
    required String departureDate,
  }) {
    List<Flight> flights = [
      Flight(
        flightNumber: "PR123",
        from: "Philippines - Manila",
        to: "Philippines - Cebu",
        airline: "Philippine Airlines",
        date: "2025-12-20",
        time: "08:00 AM",
        // price removed (mock data only)
      ),
      Flight(
        flightNumber: "KE678",
        from: "Philippines - Cebu",
        to: "South Korea - Seoul",
        airline: "Korean Air",
        date: "2025-10-22",
        time: "02:00 PM",
        // price removed (mock data only)
      ),
      Flight(
        flightNumber: "DL905",
        from: "Japan - Tokyo",
        to: "Japan - Osaka",
        airline: "Delta Airlines",
        date: "2025-10-29",
        time: "10:00 PM",
        // price removed (mock data only)
      ),
      // Add more flights here...
    ];

    return flights
        .where(
          (flight) =>
              flight.from == from &&
              flight.to == to &&
              flight.date == departureDate,
        )
        .toList();
  }
}
