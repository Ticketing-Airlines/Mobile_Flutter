import 'package:flutter/material.dart';
import 'package:ticketing_flutter/services/flight.dart';
import 'package:ticketing_flutter/public/guest_details_page.dart';

class FlightBundlesPage extends StatelessWidget {
  final Flight flight;

  FlightBundlesPage({super.key, required this.flight});
  final List<Map<String, dynamic>> bundles = [
    {
      "name": "GO Basic",
      "price": 0,
      "details": [
        "1pc hand-carry bag (Max 7kg)",
        "Random seat (assigned upon check-in)",
      ],
      "buttonText": "I'm okay with fare only",
    },
    {
      "name": "GO Easy",
      "price": 2240,
      "details": [
        "1pc hand-carry bag (Max 7kg)",
        "1pc checked baggage (Max 20kg)",
        "Preferred seat",
      ],
      "buttonText": "I want cheaper bags & seats",
    },
    {
      "name": "GO Flexi",
      "price": 3800,
      "details": [
        "1pc hand-carry bag (Max 7kg)",
        "1pc checked baggage (Max 20kg)",
        "Preferred seat",
        "CEB Flexi — Convert booking into Travel Fund",
      ],
      "buttonText": "I need flexible travel plans",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 💡 Remove AppBar
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(
        0xFFE3F2FD,
      ), // 🌈 Background color for bundle page
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Choose Your Bundle",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Select the best option for your trip",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              // 🧩 Bundle cards
              Expanded(
                child: ListView.builder(
                  itemCount: bundles.length,
                  itemBuilder: (context, index) {
                    final bundle = bundles[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bundle["name"],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 6),
                          if (bundle["price"] != 0)
                            Text(
                              "+ PHP ${bundle["price"]}.00 / guest",
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: bundle["details"]
                                .map<Widget>(
                                  (d) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 3,
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle_outline,
                                          size: 18,
                                          color: Colors.blue,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            d,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GuestDetailsPage(
                                      flight: flight,
                                      bundle: bundle,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                bundle["buttonText"],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
