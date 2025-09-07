// Airline Admin Dashboard
// Dependencies: fl_chart
// Add to pubspec.yaml:
// dependencies:
//   flutter:
//     sdk: flutter
//   fl_chart: ^0.55.2

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

// -------------------- Entry --------------------
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  // Dummy data
  final List<Flight> _flights = List.generate(
    8,
    (i) => Flight(
      id: 'FL${1000 + i}',
      origin: i % 2 == 0 ? 'MNL' : 'CEB',
      destination: i % 2 == 0 ? 'CEB' : 'MNL',
      departure: DateTime.now().add(Duration(hours: 6 + i * 3)),
      seats: 120,
    ),
  );

  final List<Booking> _bookings = List.generate(
    12,
    (i) => Booking(
      id: 'BK${2000 + i}',
      flightId: 'FL${1000 + (i % 8)}',
      passengerName: 'Passenger ${i + 1}',
      status: i % 3 == 0 ? 'Cancelled' : 'Confirmed',
      amount: 200.0 + (i * 10),
      date: DateTime.now().subtract(Duration(days: i * 2)),
    ),
  );

  final List<UserModel> _users = List.generate(
    6,
    (i) => UserModel(
      id: 'U${300 + i}',
      name: 'User ${i + 1}',
      email: 'user${i + 1}@example.com',
      role: i == 0 ? 'Admin' : 'Agent',
    ),
  );

  List<double> _salesLast7Days = [];

  @override
  void initState() {
    super.initState();
    final rnd = Random();
    _salesLast7Days = List.generate(7, (_) => 100 + rnd.nextDouble() * 400);
  }

  void _onAddFlight() {
    setState(() {
      final idx = _flights.length + 1;
      _flights.add(
        Flight(
          id: 'FL${1000 + idx}',
          origin: idx % 2 == 0 ? 'MNL' : 'DVO',
          destination: idx % 2 == 0 ? 'DVO' : 'MNL',
          departure: DateTime.now().add(Duration(hours: idx * 4)),
          seats: 150,
        ),
      );
    });
  }

  void _refreshAnalytics() {
    final rnd = Random();
    setState(() {
      _salesLast7Days = List.generate(7, (_) => 80 + rnd.nextDouble() * 500);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      FlightsPage(flights: _flights, onAdd: _onAddFlight),
      BookingsPage(bookings: _bookings),
      UsersPage(users: _users),
      AnalyticsPage(sales: _salesLast7Days, onRefresh: _refreshAnalytics),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Airline Admin Dashboard'),
        centerTitle: true,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.flight), label: 'Flights'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Analytics',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _onAddFlight,
              label: const Text('Add Flight'),
              icon: const Icon(Icons.add),
            )
          : null,
    );
  }
}

// -------------------- Models --------------------
class Flight {
  final String id;
  final String origin;
  final String destination;
  final DateTime departure;
  final int seats;

  Flight({
    required this.id,
    required this.origin,
    required this.destination,
    required this.departure,
    required this.seats,
  });
}

class Booking {
  final String id;
  final String flightId;
  final String passengerName;
  final String status;
  final double amount;
  final DateTime date;

  Booking({
    required this.id,
    required this.flightId,
    required this.passengerName,
    required this.status,
    required this.amount,
    required this.date,
  });
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });
}

// -------------------- Flights Page --------------------
class FlightsPage extends StatelessWidget {
  final List<Flight> flights;
  final VoidCallback onAdd;

  const FlightsPage({super.key, required this.flights, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Flights',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add),
                label: const Text('New Flight'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: flights.length,
              itemBuilder: (context, index) {
                final f = flights[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.airplanemode_active),
                    title: Text('${f.origin} → ${f.destination}'),
                    subtitle: Text(
                      'Departs: ${_formatDateTime(f.departure)} • Seats: ${f.seats}',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDateTime(DateTime dt) {
    return '${dt.year}-${_two(dt.month)}-${_two(dt.day)} ${_two(dt.hour)}:${_two(dt.minute)}';
  }

  static String _two(int n) => n.toString().padLeft(2, '0');
}

// -------------------- Bookings Page --------------------
class BookingsPage extends StatelessWidget {
  final List<Booking> bookings;
  const BookingsPage({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bookings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, i) {
                final b = bookings[i];
                return Card(
                  child: ListTile(
                    title: Text(b.passengerName),
                    subtitle: Text(
                      '${b.flightId} • ${b.status} • ${_shortDate(b.date)}',
                    ),
                    trailing: Text('₱${b.amount.toStringAsFixed(2)}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static String _shortDate(DateTime d) => '${d.year}-${d.month}-${d.day}';
}

// -------------------- Users Page --------------------
class UsersPage extends StatelessWidget {
  final List<UserModel> users;
  const UsersPage({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Users',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Role')),
                ],
                rows: users
                    .map(
                      (u) => DataRow(
                        cells: [
                          DataCell(Text(u.id)),
                          DataCell(Text(u.name)),
                          DataCell(Text(u.email)),
                          DataCell(Text(u.role)),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------- Analytics Page --------------------
class AnalyticsPage extends StatelessWidget {
  final List<double> sales;
  final VoidCallback onRefresh;
  const AnalyticsPage({
    super.key,
    required this.sales,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final spots = sales
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Analytics',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(onPressed: onRefresh, icon: const Icon(Icons.refresh)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 240,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, meta) {
                            final idx = v.toInt();
                            final label = [
                              '6d',
                              '5d',
                              '4d',
                              '3d',
                              '2d',
                              '1d',
                              '0d',
                            ];
                            if (idx < 0 || idx >= label.length)
                              return const SizedBox.shrink();
                            return Text(label[idx]);
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    minX: 0,
                    maxX: (sales.length - 1).toDouble(),
                    minY: 0,
                    maxY: (sales.reduce(max)) + 50,
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
