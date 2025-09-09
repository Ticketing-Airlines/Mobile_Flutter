import 'package:flutter/material.dart';
import 'package:ticketing_flutter/public/home.dart';

void main() {
  runApp(const MyApp());
}

// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airline Admin Dashboard',
      theme: ThemeData(primarySwatch: Colors.grey, useMaterial3: true),
      home: const FlightsPage(),
    );
  }
}

class FlightsPage extends StatefulWidget {
  const FlightsPage({super.key});

  @override
  State<FlightsPage> createState() => _FlightsPage();
}

class _FlightsPage extends State<FlightsPage> {
  int _selectedIndex = 0;
  bool _showPassengers = false; // toggle for passengers table

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1 || index == 2 || index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flights")),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            // --- Main Flights Table ---
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                horizontalMargin: 10,
                dataRowMinHeight: 36,
                dataRowMaxHeight: 44,
                columns: const [
                  DataColumn(label: Text("Flight No.")),
                  DataColumn(label: Text("Airline")),
                  DataColumn(label: Text("From - To")),
                  DataColumn(label: Text("Departure")),
                  DataColumn(label: Text("Arrival")),
                  DataColumn(label: Text("Duration")),
                  DataColumn(label: Text("Status")),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showPassengers = !_showPassengers;
                            });
                          },
                          child: const Text(
                            "PR123",
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      const DataCell(Text("Philippine Airlines")),
                      const DataCell(Text("MNL - CEB")),
                      const DataCell(Text("08:00 AM")),
                      const DataCell(Text("09:30 AM")),
                      const DataCell(Text("1h 30m")),
                      const DataCell(Text("On Time")),
                    ],
                  ),
                ],
              ),
            ),

            // --- Passengers Table (toggle) ---
            if (_showPassengers) ...[
              const SizedBox(height: 20),
              const Text(
                "Passenger List",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  horizontalMargin: 10,
                  dataRowMinHeight: 36,
                  dataRowMaxHeight: 44,
                  columns: const [
                    DataColumn(label: Text("Name")),
                    DataColumn(label: Text("Booking Ref")),
                    DataColumn(label: Text("Seat No")),
                    DataColumn(label: Text("Class")),
                    DataColumn(label: Text("Status")),
                    DataColumn(label: Text("Payment")),
                    DataColumn(label: Text("Contact Info")),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text("Juan Dela Cruz")),
                        DataCell(Text("REF123")),
                        DataCell(Text("12A")),
                        DataCell(Text("Economy")),
                        DataCell(Text("Checked In")),
                        DataCell(Text("Paid")),
                        DataCell(Text("+63 912 345 6789")),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text("Maria Santos")),
                        DataCell(Text("REF124")),
                        DataCell(Text("12B")),
                        DataCell(Text("Economy")),
                        DataCell(Text("Booked")),
                        DataCell(Text("Unpaid")),
                        DataCell(Text("+63 917 555 4321")),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.flight), label: 'Flights'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Users'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Bookings'),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
