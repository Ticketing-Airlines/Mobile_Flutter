import 'package:flutter/material.dart';
import 'package:ticketing_flutter/services/flight_service.dart';
import 'package:ticketing_flutter/services/flight.dart';
import 'package:ticketing_flutter/public/home.dart';
import 'package:ticketing_flutter/public/bundle.dart';

class SearchFlightsPage extends StatefulWidget {
  final String from;
  final String to;
  final String departureDate;
  final int adults;
  final int children;
  final int infants;

  const SearchFlightsPage({
    super.key,
    required this.from,
    required this.to,
    required this.departureDate,
    required this.adults,
    required this.children,
    required this.infants,
  });

  @override
  State<SearchFlightsPage> createState() => _SearchFlightsPageState();
}

class _SearchFlightsPageState extends State<SearchFlightsPage> {
  String selectedTripType = "One Way";
  final List<String> tripTypes = ["One Way", "Roundtrip", "Multicity"];
  late Future<List<Flight>> _flightsFuture;
  double? _perPassengerPrice;
  String _selectedClass = "Economy"; // default travel class

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
          adults: widget.adults,
          children: widget.children,
          infants: widget.infants,
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
          adults: widget.adults,
          children: widget.children,
          infants: widget.infants,
        );
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Read arguments passed via RouteSettings.arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      if (_perPassengerPrice == null) {
        final raw = args['selectedPrice'];
        if (raw is double) _perPassengerPrice = raw;
        if (raw is int) _perPassengerPrice = raw.toDouble();
      }
      if (args['selectedClass'] != null) {
        _selectedClass = args['selectedClass'] as String;
      }
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Available Flights + Trip Type
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

          // Travel Class Selector

          // Flight List
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
                      child: InkWell(
                        splashColor: const Color.fromARGB(
                          255,
                          20,
                          92,
                          151,
                        ).withAlpha(80),
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      FlightBundlesPage(
                                        flight: flight,
                                        adults: widget.adults,
                                        children: widget.children,
                                        infants: widget.infants,
                                      ),
                              settings: RouteSettings(
                                arguments: {
                                  'selectedPrice': _perPassengerPrice,
                                  'selectedClass': _selectedClass,
                                },
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: const Icon(
                            Icons.flight_takeoff,
                            color: Colors.blue,
                          ),
                          title: Text("${flight.from} →\n${flight.to}"),
                          subtitle: Text(
                            "Flight ${flight.flightNumber} · ${flight.airline}\n"
                            "Date: ${flight.date}  Time: ${flight.time}",
                          ),
                          isThreeLine: true,
                        ),
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
