import 'package:flutter/material.dart';

class BookingConfirmationPage extends StatelessWidget {
  final String from;
  final String to;
  final String departureDate;
  final int adults;
  final int children;
  final int infants;
  final String travelClass;
  final double totalPrice;
  final String paymentMethod;

  const BookingConfirmationPage({
    super.key,
    required this.from,
    required this.to,
    required this.departureDate,
    required this.adults,
    required this.children,
    required this.infants,
    required this.travelClass,
    required this.totalPrice,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Confirmation"),
        backgroundColor: const Color(0xFF1E3A8A),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Your Booking Receipt",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Flight Info
              _buildSectionTitle("Flight Details"),
              _buildInfoRow("From", from),
              _buildInfoRow("To", to),
              _buildInfoRow("Departure Date", departureDate),

              const SizedBox(height: 20),

              // Passenger Info
              _buildSectionTitle("Passengers"),
              _buildInfoRow("Adults", adults.toString()),
              _buildInfoRow("Children", children.toString()),
              _buildInfoRow("Infants", infants.toString()),

              const SizedBox(height: 20),

              // Class
              _buildSectionTitle("Travel Class"),
              _buildInfoRow("Class", travelClass),

              const SizedBox(height: 20),

              // Payment Info
              _buildSectionTitle("Payment"),
              _buildInfoRow("Payment Method", paymentMethod),
              _buildInfoRow("Total Price", "₱${totalPrice.toStringAsFixed(2)}"),

              const SizedBox(height: 40),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text(
                    "Done",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E3A8A),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
