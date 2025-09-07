import 'package:flutter/material.dart';
import 'package:ticketing_flutter/public/roundtrip_flight.dart';
import 'package:ticketing_flutter/public/multi_flight.dart';
// Import your other pages here

class SearchFlightsPage extends StatefulWidget {
  const SearchFlightsPage({super.key});

  @override
  State<SearchFlightsPage> createState() => _SearchFlightsPage();
}

class _SearchFlightsPage extends State<SearchFlightsPage> {
  // Default selected option
  String selectedTripType = "One Way";

  // Trip type options
  final List<String> tripTypes = ["One Way", "Roundtrip", "Multicity"];

  // Mock flight data (5 flights)
  final List<Map<String, String>> flights = const [
    {
      "from": "Philippines",
      "to": "Japan",
      "airline": "Philippine Airlines",
      "date": "2025-09-05",
      "time": "08:30 AM",
      "price": "\$350",
    },
    {
      "from": "Philippines",
      "to": "Singapore",
      "airline": "Cebu Pacific",
      "date": "2025-09-06",
      "time": "12:45 PM",
      "price": "\$200",
    },
    {
      "from": "Philippines",
      "to": "USA",
      "airline": "Delta Airlines",
      "date": "2025-09-07",
      "time": "09:00 PM",
      "price": "\$800",
    },
    {
      "from": "Philippines",
      "to": "Dubai",
      "airline": "Emirates",
      "date": "2025-09-08",
      "time": "02:15 AM",
      "price": "\$600",
    },
    {
      "from": "Philippines",
      "to": "South Korea",
      "airline": "Korean Air",
      "date": "2025-09-09",
      "time": "06:50 AM",
      "price": "\$400",
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
        page = const SearchFlightsPage();
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
                    title: Text("${flight["from"]} → ${flight["to"]}"),
                    subtitle: Text(
                      "${flight["airline"]}\nDate: ${flight["date"]}  Time: ${flight["time"]}",
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
