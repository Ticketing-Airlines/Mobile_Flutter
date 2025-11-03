import 'package:flutter/material.dart';
import 'package:ticketing_flutter/public/payment.dart';

class BookingSummaryPage extends StatelessWidget {
  final Map<String, dynamic> flight;
  final Map<String, dynamic> bundle;
  final Map<String, dynamic> guest;

  const BookingSummaryPage({
    super.key,
    required this.flight,
    required this.bundle,
    required this.guest,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF000000), Color(0xFF111827), Color(0xFF1E3A8A)],
          ),
        ),
        // ❌ Removed SingleChildScrollView
        // ✅ Use Column + Expanded for fixed layout
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Booking Summary",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 25),

            // Use Expanded so cards fit neatly on screen
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFlightCard(context),
                  _buildConfirmCard(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✈️ Flight Details Card
  Widget _buildFlightCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.3),
            blurRadius: 25,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  flight["from"],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF60A5FA),
                  ),
                ),

                const SizedBox(height: 8),

                Transform.rotate(
                  angle: -0.4, // tilt for flight effect
                  child: const Icon(
                    Icons.flight_takeoff,
                    color: Colors.white,
                    size: 32,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  flight["to"],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF60A5FA),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          Text(
            flight["date"] ?? "",
            style: const TextStyle(color: Colors.white70, fontSize: 15),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.person_outline, color: Colors.white70),
              const SizedBox(width: 8),
              Text(
                "${guest["firstName"]} ${guest["lastName"]}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.card_travel_outlined, color: Colors.white70),
              const SizedBox(width: 8),
              Text(
                bundle["name"],
                style: const TextStyle(color: Colors.white70, fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Seat: Unassigned, Unassigned",
            style: TextStyle(color: Colors.white54),
          ),
          const Divider(height: 32, color: Colors.white24, thickness: 0.8),
          const Text(
            "Taxes and Fees",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          _priceRow("Base Fare", "PHP 3,471.44"),
          _priceRow("Travel Insurance", "PHP 525.00"),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {},
            child: const Text(
              "Show details",
              style: TextStyle(
                color: Colors.lightBlueAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "PHP 3,996.44",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🧾 Confirmation + Button Card
  Widget _buildConfirmCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.25),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(Icons.check_box_outline_blank, color: Colors.white70),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "By clicking 'Continue' I confirm that I have read, understood, "
                  "and accept the Conditions of Carriage.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.5,
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
                  MaterialPageRoute(builder: (context) => const PaymentPage()),
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

  // 💰 Price Row
  Widget _priceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
