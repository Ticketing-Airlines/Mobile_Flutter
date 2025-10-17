import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xFFF3F4F6), // light gray background
      appBar: AppBar(
        backgroundColor: const Color(0xFF0288D1), // Cebu Pacific blue
        title: const Text("Booking Summary"),
        centerTitle: true,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // White card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${flight["from"]} – ${flight["to"]}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0288D1),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    flight["date"] ?? "",
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "${guest["firstName"]} ${guest["lastName"]}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    bundle["name"],
                    style: const TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Seat: Unassigned, Unassigned",
                    style: TextStyle(color: Colors.black54),
                  ),
                  const Divider(height: 32, thickness: 1.2),
                  const Text(
                    "Taxes and Fees",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _priceRow("Base Fare", "PHP 3,471.44"),
                  _priceRow("Travel Insurance", "PHP 525.00"),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {}, // can show detailed breakdown
                    child: const Text(
                      "Show details",
                      style: TextStyle(
                        color: Color(0xFF0288D1),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Total bar
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF176), // yellow bar
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "PHP 3,996.44",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Confirmation checkbox + button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.check_box_outline_blank),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "By clicking 'Continue' I confirm that I have read, understood, "
                          "and accept the Conditions of Carriage",
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0288D1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black87)),
          Text(value, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}
