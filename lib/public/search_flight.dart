import 'package:flutter/material.dart';
import 'package:ticketing_flutter/services/flight.dart';
import 'package:ticketing_flutter/services/search_flight.dart' as search_data;
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
  double? _selectedTotalPrice;
  String _selectedClass = "Economy"; // default travel class

  @override
  void initState() {
    super.initState();
    _flightsFuture = _loadFlights();
  }

  String _normalizeDate(String value) {
    final parsed = DateTime.tryParse(value.trim());
    if (parsed == null) return value.trim().toLowerCase();
    final month = parsed.month.toString().padLeft(2, '0');
    final day = parsed.day.toString().padLeft(2, '0');
    return '${parsed.year}-$month-$day';
  }

  Future<List<Flight>> _loadFlights() async {
    await Future.delayed(const Duration(milliseconds: 350));
    final routeMatches = search_data.sharedMockFlights.where((flight) {
      final fromMatch =
          flight.from.toLowerCase().contains(widget.from.toLowerCase()) ||
          widget.from.toLowerCase().contains(flight.from.toLowerCase());

      final toMatch =
          flight.to.toLowerCase().contains(widget.to.toLowerCase()) ||
          widget.to.toLowerCase().contains(flight.to.toLowerCase());

      return fromMatch && toMatch;
    }).toList();

    final targetDate = _normalizeDate(widget.departureDate);
    final dateMatches = routeMatches
        .where((flight) => _normalizeDate(flight.date) == targetDate)
        .toList();

    // Only show flights that match both route and selected date exactly.
    return dateMatches;
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

  Widget _buildTripTypePicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: DropdownButton<String>(
        value: selectedTripType,
        underline: const SizedBox.shrink(),
        iconEnabledColor: const Color(0xFF1E3A8A),
        items: tripTypes.map((String type) {
          return DropdownMenuItem<String>(value: type, child: Text(type));
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue == null) return;
          setState(() => selectedTripType = newValue);
          _navigateToPage(newValue);
        },
      ),
    );
  }

  Widget _buildFlightCard(Flight flight) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        splashColor: const Color(0xFFBFDBFE),
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
              pageBuilder: (context, animation, secondaryAnimation) =>
                  FlightBundlesPage(
                    flight: flight,
                    adults: widget.adults,
                    children: widget.children,
                    infants: widget.infants,
                  ),
              settings: RouteSettings(
                arguments: {
                  'selectedPrice': _selectedTotalPrice,
                  'selectedClass': _selectedClass,
                },
              ),
            ),
          );
        },
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 6,
          ),
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFDBEAFE),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.flight_takeoff, color: Color(0xFF1E3A8A)),
          ),
          title: Text(
            "${flight.from} -> ${flight.to}",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          subtitle: Text(
            "Flight ${flight.flightNumber} · ${flight.airline}\n"
            "Date: ${flight.date}  Time: ${flight.time}",
            style: const TextStyle(color: Color(0xFF475569)),
          ),
          isThreeLine: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Read arguments passed via RouteSettings.arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      if (_selectedTotalPrice == null) {
        final raw = args['selectedPrice'];
        if (raw is double) _selectedTotalPrice = raw;
        if (raw is int) _selectedTotalPrice = raw.toDouble();
      }
      if (args['selectedClass'] != null) {
        _selectedClass = args['selectedClass'] as String;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF1E3A8A),
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Available Flights + Trip Type
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Available Flights",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Choose your option",
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
                _buildTripTypePicker(),
              ],
            ),
          ),

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
                    return _buildFlightCard(flight);
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
