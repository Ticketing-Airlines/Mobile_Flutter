import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✈️ Airline logo or icon
            const Icon(
              Icons.flight_takeoff,
              color: Colors.blueAccent,
              size: 90,
            ),
            const SizedBox(height: 10),

            const Text(
              "Airlines Ticketing",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Your Journey, Made Easier.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 25),

            // 💬 About section
            _buildSectionTitle("Who We Are"),
            const Text(
              "Airlines Ticketing is a modern flight ticketing platform dedicated to making air travel more accessible, "
              "affordable, and stress-free. Whether you're booking a business trip, family vacation, or spontaneous getaway, "
              "our goal is to make your journey smooth from takeoff to landing.",
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 25),

            // 🌍 Mission
            _buildSectionTitle("Our Mission"),
            const Text(
              "We aim to connect people across destinations by offering reliable booking services, transparent pricing, "
              "and exceptional customer support — all in one easy-to-use app.",
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 25),

            // 🛫 What We Offer
            _buildSectionTitle("What We Offer"),
            _buildFeature(
              Icons.airplane_ticket,
              "Easy & Secure Flight Booking",
              "Book one-way, round-trip, or multi-city flights in just a few taps.",
            ),
            _buildFeature(
              Icons.attach_money,
              "Transparent Pricing",
              "No hidden fees — what you see is what you pay.",
            ),
            _buildFeature(
              Icons.support_agent,
              "24/7 Customer Support",
              "We’re always here to assist you before, during, and after your flight.",
            ),
            _buildFeature(
              Icons.event_available,
              "Flexible Travel Options",
              "Easily modify or cancel bookings when plans change.",
            ),
            const SizedBox(height: 25),

            // 💙 Vision
            _buildSectionTitle("Our Vision"),
            const Text(
              "To become the most trusted digital airline ticketing service — bridging distances, one flight at a time.",
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 40),

            // ✉️ Contact Info
            _buildSectionTitle("Contact Us"),
            const SizedBox(height: 10),
            _buildContactRow(
              Icons.email_outlined,
              "support@airlinesticketing.com",
            ),
            _buildContactRow(Icons.phone_outlined, "+63 900 123 4567"),
            _buildContactRow(
              Icons.location_on_outlined,
              "Makati City, Philippines",
            ),

            const SizedBox(height: 40),
            const Text(
              "© 2025 Airlines Ticketing. All rights reserved.",
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Reusable section title widget
  static Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }

  // 🔹 Feature item with icon
  static Widget _buildFeature(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue, size: 26),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Contact row
  static Widget _buildContactRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
