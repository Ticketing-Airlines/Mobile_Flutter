// import 'package:flutter/material.dart';
// import 'package:ticketing_flutter/public/roundtrip_flight.dart';
// import 'package:ticketing_flutter/public/search_flight.dart';

// class MultiCitySearchFlightsPage extends StatefulWidget {
//   const MultiCitySearchFlightsPage({super.key});

//   @override
//   State<MultiCitySearchFlightsPage> createState() =>
//       _MultiCitySearchFlightsPageState();
// }

// class _MultiCitySearchFlightsPageState
//     extends State<MultiCitySearchFlightsPage> {
//   // Default selected option
//   String selectedTripType = "Multicity";

//   // Trip type options
//   final List<String> tripTypes = ["One Way", "Roundtrip", "Multicity"];

//   // Mock multi-city flights data
//   final List<Map<String, dynamic>> multiCityFlights = const [
//     {
//       "airline": "Philippine Airlines",
//       "price": "\$900",
//       "legs": [
//         {
//           "from": "Philippines",
//           "to": "Japan",
//           "date": "2025-09-05",
//           "time": "08:30 AM",
//         },
//         {
//           "from": "Japan",
//           "to": "USA",
//           "date": "2025-09-06",
//           "time": "07:15 PM",
//         },
//       ],
//     },
//     {
//       "airline": "Singapore Airlines",
//       "price": "\$1100",
//       "legs": [
//         {
//           "from": "Philippines",
//           "to": "Singapore",
//           "date": "2025-09-07",
//           "time": "01:00 PM",
//         },
//         {
//           "from": "Singapore",
//           "to": "Australia",
//           "date": "2025-09-08",
//           "time": "09:45 AM",
//         },
//         {
//           "from": "Australia",
//           "to": "New Zealand",
//           "date": "2025-09-09",
//           "time": "06:20 AM",
//         },
//       ],
//     },
//     {
//       "airline": "Emirates",
//       "price": "\$1500",
//       "legs": [
//         {
//           "from": "Philippines",
//           "to": "Dubai",
//           "date": "2025-09-10",
//           "time": "02:00 AM",
//         },
//         {
//           "from": "Dubai",
//           "to": "London",
//           "date": "2025-09-11",
//           "time": "10:30 AM",
//         },
//       ],
//     },
//   ];

//   void _navigateToPage(String tripType) {
//     Widget page;

//     switch (tripType) {
//       case "One Way":
//         page = const SearchFlightsPage();
//         break;
//       case "Roundtrip":
//         page = const RoundtripFlightsPage();
//         break;
//       case "Multicity":
//         page = const MultiCitySearchFlightsPage();
//         break;
//       default:
//         page = const SearchFlightsPage();
//     }

//     Navigator.push(context, MaterialPageRoute(builder: (context) => page));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Top section: title + dropdown
//           Padding(
//             padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Title text on the left
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     Text(
//                       "Available Flights",
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       "Choose your option",
//                       style: TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                   ],
//                 ),

//                 // Dropdown on the right
//                 DropdownButton<String>(
//                   value: selectedTripType,
//                   underline: Container(), // removes default underline
//                   items: tripTypes.map((String type) {
//                     return DropdownMenuItem<String>(
//                       value: type,
//                       child: Text(type),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       selectedTripType = newValue!;
//                     });

//                     // Navigate to respective page
//                     _navigateToPage(newValue!);
//                   },
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 20),

//           // Multi-city flights list
//           Expanded(
//             child: ListView.builder(
//               itemCount: multiCityFlights.length,
//               itemBuilder: (context, index) {
//                 final flight = multiCityFlights[index];
//                 return Card(
//                   margin: const EdgeInsets.all(12),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Airline + Price
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               flight["airline"],
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               flight["price"],
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.green,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),

//                         // Legs
//                         Column(
//                           children: (flight["legs"] as List).map((leg) {
//                             return ListTile(
//                               leading: const Icon(
//                                 Icons.flight_takeoff,
//                                 color: Colors.blue,
//                               ),
//                               title: Text("${leg["from"]} → ${leg["to"]}"),
//                               subtitle: Text(
//                                 "Date: ${leg["date"]} | Time: ${leg["time"]}",
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
