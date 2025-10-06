import 'package:flutter/material.dart';

class BookingSummaryPage extends StatelessWidget {
  final Map<String, String> flight;
  final Map<String, String> guest;

  const BookingSummaryPage({
    super.key,
    required this.flight,
    required this.guest,
  });

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0D1B2A), // dark navy dialog
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SizedBox(
          width: 700, // <-- Make the dialog wider here
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle, color: Colors.greenAccent, size: 70),
              SizedBox(height: 16),
              Text(
                "Booking Confirmed!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Your booking has been successfully saved.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A), // dark blue background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B263B), // darker navy
        title: const Text(
          'Booking Summary',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Flight Details Card
            Card(
              color: const Color(0xFF1B263B), // dark card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "✈️ Flight Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _detailText("From", flight["from"]),
                    _detailText("To", flight["to"]),
                    _detailText("Airline", flight["airline"]),
                    _detailText("Date", flight["date"]),
                    _detailText("Time", flight["time"]),
                    _detailText(
                      "Price",
                      flight["price"],
                      highlight: Colors.greenAccent,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Passenger Details Card
            Card(
              color: const Color(0xFF1B263B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "🧍 Passenger Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _detailText("Title", guest["title"]),
                    _detailText(
                      "Name",
                      "${guest["firstName"] ?? ""} "
                          "${guest["middleName"] ?? ""} "
                          "${guest["lastName"] ?? ""}",
                    ),
                    _detailText("Date of Birth", guest["dob"]),
                    _detailText("Gender", guest["gender"]),
                    _detailText("Nationality", guest["nationality"]),
                    _detailText("Passport No.", guest["passport"]),
                    _detailText("Passport Expiry", guest["passportExpiry"]),
                    _detailText("Contact", guest["contact"]),
                    _detailText("Email", guest["email"]),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                onPressed: () => _showConfirmationDialog(context),
                child: const Text(
                  "Confirm Booking",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for details with consistent style
  Widget _detailText(String label, String? value, {Color? highlight}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        "$label: ${value ?? "-"}",
        style: TextStyle(
          fontSize: 16,
          color: highlight ?? Colors.white,
          fontWeight: highlight != null ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
