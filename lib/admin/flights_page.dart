import 'package:flutter/material.dart';
import 'package:ticketing_flutter/public/home.dart';
import 'package:ticketing_flutter/services/flight_service.dart';

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
  final FlightService _flightService = FlightService();

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

  void _deleteFlight(String flightNo, String airline) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete Flight'),
          content: Text(
            'Are you sure you want to delete flight $flightNo ($airline)?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _flightService.removeFlight(flightNo);
                });
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Flight $flightNo deleted successfully'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget buildDatePickerField(String hint, TextEditingController controller) {
    return GestureDetector(
      onTap: () async {
        DateTime today = DateTime.now();
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: today,
          firstDate: today,
          lastDate: DateTime(today.year + 2),
        );

        if (pickedDate != null) {
          String formattedDate =
              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
          controller.text = formattedDate;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                controller.text.isEmpty ? hint : controller.text,
                style: TextStyle(
                  color: controller.text.isEmpty ? Colors.grey : Colors.black,
                ),
              ),
            ),
            const Icon(Icons.calendar_today, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _openAddFlightDialog() {
    final formKey = GlobalKey<FormState>();
    final flightNoCtrl = TextEditingController();
    final airlineCtrl = TextEditingController();
    final fromCtrl = TextEditingController();
    final toCtrl = TextEditingController();
    final dateCtrl = TextEditingController();
    final departureCtrl = TextEditingController();
    final arrivalCtrl = TextEditingController();
    final durationCtrl = TextEditingController();
    final statusCtrl = TextEditingController();
    final priceCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add Flight'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: flightNoCtrl,
                    decoration: const InputDecoration(labelText: 'Flight No.'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: airlineCtrl,
                    decoration: const InputDecoration(labelText: 'Airline'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: fromCtrl,
                          decoration: const InputDecoration(
                            labelText: 'From (IATA)',
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Required'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: toCtrl,
                          decoration: const InputDecoration(
                            labelText: 'To (IATA)',
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Required'
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  buildDatePickerField("Select Date", dateCtrl),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: departureCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Departure (e.g., 08:00 AM)',
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Required'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: arrivalCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Arrival (e.g., 09:30 AM)',
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Required'
                              : null,
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: durationCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Duration (e.g., 1h 30m)',
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: statusCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Status (e.g., On Time)',
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: priceCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Price (e.g., \$350)',
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() != true) return;
                if (dateCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a date'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                final newFlight = Flight(
                  flightNo: flightNoCtrl.text.trim(),
                  airline: airlineCtrl.text.trim(),
                  from: fromCtrl.text.trim().toUpperCase(),
                  to: toCtrl.text.trim().toUpperCase(),
                  date: dateCtrl.text.trim(),
                  departure: departureCtrl.text.trim(),
                  arrival: arrivalCtrl.text.trim(),
                  duration: durationCtrl.text.trim(),
                  status: statusCtrl.text.trim(),
                  price: priceCtrl.text.trim(),
                );
                setState(() {
                  _flightService.addFlight(newFlight);
                });
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Flight ${newFlight.flightNo} added successfully',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
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
                  DataColumn(label: Text("Date")),
                  DataColumn(label: Text("Departure")),
                  DataColumn(label: Text("Arrival")),
                  DataColumn(label: Text("Duration")),
                  DataColumn(label: Text("Status")),
                  DataColumn(label: Text("Price")),
                  DataColumn(label: Text("Actions")),
                ],
                rows: _flightService.flights.map((f) {
                  return DataRow(
                    cells: [
                      DataCell(
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showPassengers = !_showPassengers;
                            });
                          },
                          child: Text(
                            f.flightNo,
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      DataCell(Text(f.airline)),
                      DataCell(Text("${f.from} - ${f.to}")),
                      DataCell(Text(f.date)),
                      DataCell(Text(f.departure)),
                      DataCell(Text(f.arrival)),
                      DataCell(Text(f.duration)),
                      DataCell(Text(f.status)),
                      DataCell(Text(f.price)),
                      DataCell(
                        IconButton(
                          onPressed: () => _deleteFlight(f.flightNo, f.airline),
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Delete Flight',
                        ),
                      ),
                    ],
                  );
                }).toList(),
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

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddFlightDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Flight'),
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
