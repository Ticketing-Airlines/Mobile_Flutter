import 'package:flutter/material.dart';
import 'package:ticketing_flutter/public/roundtrip_flight.dart';
import 'package:ticketing_flutter/public/multi_flight.dart';
import 'package:ticketing_flutter/services/flight_service.dart';
import 'package:ticketing_flutter/public/guest_details_page.dart';
import 'package:ticketing_flutter/services/flight.dart';
import 'package:ticketing_flutter/public/home.dart';
import 'package:ticketing_flutter/public/bundle.dart';

class SearchFlightsPage extends StatefulWidget {
  final String from;
  final String to;
  final String departureDate;

  const SearchFlightsPage({
    super.key,
    required this.from,
    required this.to,
    required this.departureDate,
  });

  @override
  State<SearchFlightsPage> createState() => _SearchFlightsPageState();
}

class _SearchFlightsPageState extends State<SearchFlightsPage> {
  String selectedTripType = "One Way";
  final List<String> tripTypes = ["One Way", "Roundtrip", "Multicity"];
  late Future<List<Flight>> _flightsFuture;

  @override
  void initState() {
    super.initState();
    _flightsFuture = _loadFlights();
  }

  Future<List<Flight>> _loadFlights() async {
    final flightService = FlightService();
    return flightService.getFlights(
      from: widget.from,
      to: widget.to,
      departureDate: widget.departureDate,
    );
  }

  void _navigateToPage(String tripType) {
    Widget page;

    switch (tripType) {
      case "One Way":
        page = SearchFlightsPage(
          from: widget.from,
          to: widget.to,
          departureDate: widget.departureDate,
        );
        break;
      case "Roundtrip":
        page = const Home();
        break;
      case "Multicity":
        page = const Home();
        break;
      default:
        page = SearchFlightsPage(
          from: widget.from,
          to: widget.to,
          departureDate: widget.departureDate,
        );
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                DropdownButton<String>(
                  value: selectedTripType,
                  underline: Container(),
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
                    _navigateToPage(newValue!);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<Flight>>(
              future: _flightsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No flights available"));
                }

                final flights = snapshot.data!;
                return ListView.builder(
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
                        title: Text("${flight.from} → ${flight.to}"),
                        subtitle: Text(
                          "${flight.airline}\nDate: ${flight.date}  Time: ${flight.time}",
                        ),
                        trailing: Text(
                          "₱${flight.price}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        isThreeLine: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FlightBundlesPage(flight: flight),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
