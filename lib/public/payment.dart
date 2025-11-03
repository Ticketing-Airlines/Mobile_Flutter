import 'package:flutter/material.dart';
import 'package:ticketing_flutter/public/booking_information.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF000000), Color(0xFF111827), Color(0xFF1E3A8A)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 70, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🧾 Page Title
              const Text(
                "Payment",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 25),

              // 💳 Card Information Section
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Card Information",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    _buildTextField(
                      label: "Cardholder Name",
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      label: "Card Number",
                      icon: Icons.credit_card,
                    ),
                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: "Expiry Date",
                            icon: Icons.calendar_today,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            label: "CVV",
                            icon: Icons.lock_outline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 🏦 Payment Summary
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white24),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                child: Column(
                  children: const [
                    _SummaryRow(label: "Base Fare", value: "PHP 3,471.44"),
                    _SummaryRow(label: "Travel Insurance", value: "PHP 525.00"),
                    Divider(color: Colors.white24, height: 20),
                    _SummaryRow(
                      label: "Total",
                      value: "PHP 3,996.44",
                      bold: true,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // 🟦 Pay Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 10,
                    shadowColor: Colors.blueAccent.withOpacity(0.5),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookingConfirmationPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Pay Now",
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
        ),
      ),
    );
  }

  // Custom Text Field Widget
  Widget _buildTextField({required String label, required IconData icon}) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.blueAccent,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
