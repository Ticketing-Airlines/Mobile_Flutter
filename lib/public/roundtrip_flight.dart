import 'package:flutter/material.dart';
import 'package:ticketing_flutter/public/search_flight.dart';
import 'package:ticketing_flutter/public/multi_flight.dart';

class RoundtripFlightsPage extends StatefulWidget {
  const RoundtripFlightsPage({super.key});

  @override
  State<RoundtripFlightsPage> createState() => _RoundtripFlightsPageState();
}

class _RoundtripFlightsPageState extends State<RoundtripFlightsPage> {
  String selectedTripType = "Roundtrip";

  // Trip type options
  final List<String> tripTypes = ["One Way", "Roundtrip", "Multicity"];
  // Mock roundtrip flight data
  final List<Map<String, String>> flights = const [
    {
      "from": "Philippines",
      "to": "Japan",
      "airline": "Philippine Airlines",
      "depart": "2025-09-05 08:30 AM",
      "return": "2025-09-12 10:00 AM",
      "price": "\$650",
    },
    {
      "from": "Philippines",
      "to": "Singapore",
      "airline": "Cebu Pacific",
      "depart": "2025-09-06 12:45 PM",
      "return": "2025-09-10 06:20 PM",
      "price": "\$350",
    },
    {
      "from": "Philippines",
      "to": "USA",
      "airline": "Delta Airlines",
      "depart": "2025-09-07 09:00 PM",
      "return": "2025-09-20 07:45 PM",
      "price": "\$1200",
    },
    {
      "from": "Philippines",
      "to": "Dubai",
      "airline": "Emirates",
      "depart": "2025-09-08 02:15 AM",
      "return": "2025-09-15 01:00 AM",
      "price": "\$950",
    },
    {
      "from": "Philippines",
      "to": "South Korea",
      "airline": "Korean Air",
      "depart": "2025-09-09 06:50 AM",
      "return": "2025-09-16 09:30 AM",
      "price": "\$700",
    },
  ];

  void _navigateToPage(String tripType) {
    Widget page;

    switch (tripType) {
      case "One Way":
        page = const SearchFlightsPage();
        break;
      case "Roundtrip":
        page = const RoundtripFlightsPage();
        break;
      case "Multicity":
        page = const MultiCitySearchFlightsPage();
        break;
      default:
        page = const RoundtripFlightsPage();
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top section: title + dropdown
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title text on the left
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Available Flights",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Choose your option",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),

                // Dropdown on the right
                DropdownButton<String>(
                  value: selectedTripType,
                  underline: Container(), // removes default underline
                  items: tripTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTripType = newValue!;
                    });

                    // Navigate to respective page
                    _navigateToPage(newValue!);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Flights list
          Expanded(
            child: ListView.builder(
              itemCount: flights.length,
              itemBuilder: (context, index) {
                final flight = flights[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: const Icon(
                      Icons.flight_takeoff,
                      color: Colors.blue,
                    ),
                    title: Text("${flight["from"]} ↔ ${flight["to"]}"),
                    subtitle: Text(
                      "${flight["airline"]}\n"
                      "Depart: ${flight["depart"]}\n"
                      "Return: ${flight["return"]}",
                    ),
                    trailing: Text(
                      flight["price"]!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
