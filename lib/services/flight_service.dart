import 'package:ticketing_flutter/services/flight.dart';

class FlightService {
  List<Flight> getFlights({
    required String from,
    required String to,
    required String departureDate,
  }) {
    List<Flight> flights = [
      Flight(
        from: "Philippines - Manila",
        to: "Philippines - Cebu",
        airline: "Philippine Airlines",
        date: "2025-10-20",
        time: "08:00 AM",
        price: 25000,
      ),
      Flight(
        from: "Philippines - Cebu",
        to: "South Korea - Seoul",
        airline: "Korean Air",
        date: "2025-10-22",
        time: "02:00 PM",
        price: 30000,
      ),
      Flight(
        from: "Japan - Tokyo",
        to: "Japan - Osaka",
        airline: "Delta Airlines",
        date: "2025-10-25",
        time: "10:00 PM",
        price: 40000,
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
