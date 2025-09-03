import 'package:flutter/material.dart';
import 'package:ticketing_flutter/pages/book_roundtrip.dart';
import 'package:ticketing_flutter/pages/book_multicity.dart';

class BookOneway extends StatefulWidget {
  const BookOneway({super.key});

  @override
  State<BookOneway> createState() => _BookOneway();
}

class _BookOneway extends State<BookOneway> {
  // Controllers for user input boxes
  final TextEditingController box4Controller = TextEditingController();
  final TextEditingController box5Controller = TextEditingController();
  final TextEditingController box6Controller = TextEditingController();
  final TextEditingController box7Controller = TextEditingController();
  final TextEditingController box8Controller = TextEditingController();

  bool _isSearchPressed = false; // 🔹 Track button press state

  void _navigateToPage(String boxName, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        width: 300.0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.flight),
              title: const Text('Book'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Navigating to Home")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.manage_accounts),
              title: const Text('Manage'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Navigating to Contact")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Travel Info'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Navigating to About")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.explore),
              title: const Text('Explore'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Navigating to Home")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Navigating to Home")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Navigating to Home")),
                );
              },
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;
          final boxHeight = 480.0;
          final boxWidth = 330.0;
          final boxTop = (screenHeight / 2) - (boxHeight / 2);
          final screenWidth = MediaQuery.of(context).size.width;
          final boxLeft = (screenWidth - boxWidth) / 2;

          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                      'assets/half.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.blue.shade100,
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 30,
                left: 10,
                child: Builder(
                  builder: (context) {
                    return IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  },
                ),
              ),
              Positioned(
                top: boxTop,
                left: boxLeft,
                child: Container(
                  width: boxWidth,
                  height: boxHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // First row of 3 clickable boxes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Do nothing because we are already on Multi-City page
                              },
                              child: buildClickableBox(
                                "One Way",
                                const Color.fromARGB(
                                  255,
                                  68,
                                  138,
                                  255,
                                ), // highlight it
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _navigateToPage(
                                "Box 2",
                                const BookRoundtrip(),
                              ),
                              child: buildClickableBox(
                                "Roundtrip",
                                Colors.blue.shade200,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _navigateToPage(
                                "Box 3",
                                const BookMulticity(),
                              ),
                              child: buildClickableBox(
                                "Multi-City",
                                Colors.blue.shade200,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Box 4, 5, 6 stacked vertically (user input)
                        Column(
                          children: [
                            buildInputBox("From", box4Controller),
                            const SizedBox(height: 12),
                            buildInputBox("To", box5Controller),
                            const SizedBox(height: 12),
                            buildInputBox("Departure", box6Controller),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Row with Box 7 & 8 (user input)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildInputBox(
                              "Passengers",
                              box7Controller,
                              width: 140,
                            ),
                            buildInputBox("Class", box8Controller, width: 140),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Box 9 clickable (Search Flights)
                        GestureDetector(
                          onTapDown: (_) {
                            setState(() => _isSearchPressed = true);
                          },
                          onTapUp: (_) {
                            setState(() => _isSearchPressed = false);
                            _navigateToPage("Box 9", const Page9());
                          },
                          onTapCancel: () {
                            setState(() => _isSearchPressed = false);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 300,
                            height: 70,
                            decoration: BoxDecoration(
                              color: _isSearchPressed
                                  ? Colors
                                        .blue
                                        .shade900 // Pressed color
                                  : const Color.fromARGB(
                                      255,
                                      68,
                                      138,
                                      255,
                                    ), // Default color
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'Search Flights',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Reusable clickable box
  Widget buildClickableBox(String label, Color color) {
    return Container(
      width: 93,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Reusable input box widget
  Widget buildInputBox(
    String hint,
    TextEditingController controller, {
    double width = 300,
  }) {
    return Container(
      width: width,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: hint, border: InputBorder.none),
      ),
    );
  }
}

// Separate pages for navigation

class Page9 extends StatelessWidget {
  const Page9({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Page 9")),
      body: const Center(child: Text("Welcome to Page 9")),
    );
  }
}
