import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ticketing_flutter/public/payment.dart';
import 'package:ticketing_flutter/services/flight.dart';

class BookingSummaryPage extends StatelessWidget {
  final Flight flight;
  final Map<String, dynamic> bundle;
  final List<Map<String, dynamic>> guests;
  final List<String> seatAssignments;
  final double selectedPrice;

  BookingSummaryPage({
    super.key,
    required this.flight,
    required this.bundle,
    required this.guests,
    double? selectedPrice,
  }) : selectedPrice = selectedPrice ?? flight.price,
       seatAssignments = _generateSeats(guests.length);

  // Generate seat numbers randomly
  static List<String> _generateSeats(int count) {
    if (count == 0) return [];
    const seatLetters = ["A", "B", "C", "D", "E", "F"];
    final random = Random();
    final seats = <String>[];

    while (seats.length < count) {
      final row = random.nextInt(40) + 1;
      final letter = seatLetters[random.nextInt(seatLetters.length)];
      final seat = "$row$letter";
      if (!seats.contains(seat)) seats.add(seat);
    }
    return seats;
  }

  int get travelerCount => guests.length;
  double get bundlePerGuest => (bundle["price"] ?? 0).toDouble();

  double get totalFlight => selectedPrice * travelerCount;
  double get totalBundle => bundlePerGuest * travelerCount;
  double get grandTotal => totalFlight + totalBundle;

  String currency(double v) => "PHP ${v.toStringAsFixed(2)}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1F), // Premium navy
      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 45, 18, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Booking Summary",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD369), // gold
              ),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: ListView(
                children: [
                  _flightCard(),
                  const SizedBox(height: 20),
                  _fareCard(),
                  const SizedBox(height: 20),
                  _confirmCard(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✈ Elegant flight details card
  Widget _flightCard() {
    String? firstAdult;
    for (final g in guests) {
      if (g["type"] == "Adult") {
        firstAdult = "${g["title"] ?? ""} ${g["firstName"]} ${g["lastName"]}"
            .trim();
        break;
      }
    }

    return _glassCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                _cityText(flight.from),
                const SizedBox(height: 5),
                const Icon(
                  Icons.flight_takeoff,
                  color: Color(0xFFFFD369),
                  size: 38,
                ),
                const SizedBox(height: 5),
                _cityText(flight.to),
              ],
            ),
          ),

          const SizedBox(height: 18),
          _detail(Icons.airlines, "Airline", flight.airline),
          _detail(Icons.numbers, "Flight No.", flight.flightNumber),
          _detail(Icons.calendar_month, "Date", flight.date),
          _detail(Icons.schedule, "Departure", flight.time),

          const SizedBox(height: 15),
          if (firstAdult != null) _passengerTitle("Passenger", firstAdult),

          const SizedBox(height: 12),
          _passengerTitle("Bundle", bundle["name"]),

          const SizedBox(height: 15),

          const Text(
            "Seat Assignments",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFFFD369),
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ...guests.asMap().entries.map((entry) {
            final idx = entry.key;
            final g = entry.value;
            final seat = seatAssignments[idx];

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(Icons.event_seat, color: Colors.white70, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "${g["title"] ?? ""} ${g["firstName"]} ${g["lastName"]}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    seat,
                    style: const TextStyle(
                      color: Color(0xFFFFD369),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // 💰 Elegant fare summary card
  Widget _fareCard() {
    return _glassCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Fare Summary",
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFFFFD369),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          _fareRow("Flight Fare (${travelerCount} pax)", currency(totalFlight)),
          _fareRow(
            bundle["name"] + " (${travelerCount} pax)",
            bundlePerGuest == 0 ? "Included" : currency(totalBundle),
          ),
          const SizedBox(height: 15),
          const Divider(color: Colors.white24),
          const SizedBox(height: 10),
          _fareRow("TOTAL", currency(grandTotal), bold: true, gold: true),
        ],
      ),
    );
  }

  // 🧾 Confirmation + button
  Widget _confirmCard(BuildContext context) {
    return _glassCard(
      Column(
        children: [
          Row(
            children: const [
              Icon(Icons.check_circle_outline, color: Colors.white70),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "By tapping Continue, you agree to the airline conditions of carriage.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 8,
                shadowColor: Colors.blueAccent.withOpacity(0.5),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentPage(),
                    settings: RouteSettings(arguments: {'total': grandTotal}),
                  ),
                );
              },
              child: const Text(
                "Continue",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🟦 Reusable navy glass card
  Widget _glassCard(Widget child) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20),
        ],
      ),
      child: child,
    );
  }

  // Reusable row styles
  Widget _detail(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white54),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$label: $value",
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cityText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Color(0xFFFFD369),
      ),
    );
  }

  Widget _fareRow(
    String label,
    String price, {
    bool bold = false,
    bool gold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              color: gold ? const Color(0xFFFFD369) : Colors.white,
              fontSize: 16,
              fontWeight: bold ? FontWeight.w900 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _passengerTitle(String label, String value) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: const TextStyle(
            color: Color(0xFFFFD369),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
