import 'package:flutter/material.dart';
import 'package:ticketing_flutter/services/flight.dart';
import 'guest_details_page.dart';

class FlightBundlesPage extends StatefulWidget {
  final Flight flight;
  final int adults;
  final int children;
  final int infants;
  // optional: keep existing constructor, no change required here if using ModalRoute
  const FlightBundlesPage({
    super.key,
    required this.flight,
    required this.adults,
    required this.children,
    required this.infants,
  });

  @override
  State<FlightBundlesPage> createState() => _FlightBundlesPageState();
}

class _FlightBundlesPageState extends State<FlightBundlesPage> {
  double? _perPassengerPrice;

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
  void initState() {
    super.initState();
    // don't read ModalRoute here (may be null); read in build instead
  }

  @override
  Widget build(BuildContext context) {
    // Read forwarded per-passenger price (book -> search -> bundle) once
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && _perPassengerPrice == null) {
      final raw = args['selectedPrice'];
      if (raw is double) _perPassengerPrice = raw;
      if (raw is int) _perPassengerPrice = raw.toDouble();
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 🌈 Gradient background
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF000000), Color(0xFF1E3A8A)],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Color(0xFFBBDEFB),
                  width: double.infinity,
                ),
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🌟 Header
                  const Text(
                    "Choose Your Bundle",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Select the best option for your trip",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  // 🧩 Bundles — scrollable and closer to header
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: bundles
                            .map(
                              (bundle) => Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.12),
                                      spreadRadius: 1,
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
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
                                        color: Color(0xFF1E3A8A),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    if (bundle["price"] != 0)
                                      Text(
                                        "+ PHP ${bundle["price"]}.00 / guest",
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    const SizedBox(height: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: bundle["details"]
                                          .map<Widget>(
                                            (d) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 2,
                                                  ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          final double forwardedPrice =
                                              _perPassengerPrice ??
                                              widget.flight.price;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  GuestDetailsPage(
                                                    flight: widget.flight,
                                                    bundle: bundle,
                                                    adults: widget.adults,
                                                    children: widget.children,
                                                    infants: widget.infants,
                                                  ),
                                              settings: RouteSettings(
                                                arguments: {
                                                  'selectedPrice':
                                                      forwardedPrice,
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF1E3A8A,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
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
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
