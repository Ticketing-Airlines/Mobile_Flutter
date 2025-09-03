import 'package:flutter/material.dart';
import 'package:ticketing_flutter/pages/book_oneway.dart';
import 'package:ticketing_flutter/pages/book_roundtrip.dart';
import 'package:ticketing_flutter/pages/book_multicity.dart';
import 'package:ticketing_flutter/pages/search_flight.dart';

const List<String> countries = ["Philippines - Manila", "Japan - Tokyo"];

class Book extends StatefulWidget {
  const Book({super.key});

  @override
  State<Book> createState() => _Book();
}

class _Book extends State<Book> {
  final TextEditingController box4Controller = TextEditingController();
  final TextEditingController box5Controller = TextEditingController();
  final TextEditingController box6Controller = TextEditingController();
  final TextEditingController box7Controller = TextEditingController();
  final TextEditingController box8Controller = TextEditingController();

  int _adults = 1;
  int _children = 0;
  int _infants = 0;
  String _selectedClass = "Economy";

  bool _isSearchPressed = false;

  @override
  void initState() {
    super.initState();
    box7Controller.text = "${_adults + _children + _infants} Passengers";
    box8Controller.text = _selectedClass;
  }

  void _navigateToPage(String boxName, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  void _showPassengerSelector() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildPassengerRow("Adults", _adults, (val) {
                    setState(() => _adults += val);
                  }, min: 1),
                  const Divider(),
                  _buildPassengerRow("Children", _children, (val) {
                    setState(() => _children += val);
                  }),
                  const Divider(),
                  _buildPassengerRow("Infants", _infants, (val) {
                    setState(() => _infants += val);
                  }),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final total = _adults + _children + _infants;
                      box7Controller.text = "$total Passengers";
                      Navigator.pop(context);
                    },
                    child: const Text('Done'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showClassSelector() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildClassOption("Economy"),
              _buildClassOption("Business"),
              _buildClassOption("First Class"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPassengerRow(
    String type,
    int count,
    Function(int) onUpdate, {
    int min = 0,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(type, style: const TextStyle(fontSize: 16)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: count > min ? () => onUpdate(-1) : null,
            ),
            Text(count.toString(), style: const TextStyle(fontSize: 16)),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => onUpdate(1),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildClassOption(String className) {
    return ListTile(
      title: Text(className),
      onTap: () {
        setState(() {
          _selectedClass = className;
          box8Controller.text = _selectedClass;
        });
        Navigator.pop(context);
      },
    );
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  _navigateToPage("Box 1", const BookOneway()),
                              child: buildClickableBox("One-way"),
                            ),
                            GestureDetector(
                              onTap: () => _navigateToPage(
                                "Box 2",
                                const BookRoundtrip(),
                              ),
                              child: buildClickableBox("Roundtrip"),
                            ),
                            GestureDetector(
                              onTap: () => _navigateToPage(
                                "Box 3",
                                const BookMulticity(),
                              ),
                              child: buildClickableBox("Multi-City"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            buildAutocompleteField("From", box4Controller),
                            const SizedBox(height: 12),
                            buildAutocompleteField("To", box5Controller),
                            const SizedBox(height: 12),
                            buildDatePickerField("Departure", box6Controller),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildInputBox(
                              "Passengers",
                              box7Controller,
                              width: 140,
                              readOnly: true,
                            ),
                            buildInputBox(
                              "Class",
                              box8Controller,
                              width: 140,
                              readOnly: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTapDown: (_) {
                            setState(() => _isSearchPressed = true);
                          },
                          onTapUp: (_) {
                            setState(() => _isSearchPressed = false);
                            _navigateToPage("Box 9", const SearchFlightsPage());
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
                                  ? Colors.blue.shade900
                                  : const Color.fromARGB(255, 68, 138, 255),
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

  Widget buildAutocompleteField(String hint, TextEditingController controller) {
    return Container(
      width: 300,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<String>.empty();
          }
          return countries.where(
            (country) => country.toLowerCase().contains(
              textEditingValue.text.toLowerCase(),
            ),
          );
        },
        onSelected: (String selection) {
          controller.text = selection;
        },
        fieldViewBuilder:
            (context, textController, focusNode, onFieldSubmitted) {
              return TextField(
                controller: textController,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                ),
              );
            },
      ),
    );
  }

  Widget buildClickableBox(String label) {
    return Container(
      width: 93,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blue.shade200,
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

  Widget buildInputBox(
    String hint,
    TextEditingController controller, {
    double width = 300,
    bool readOnly = false,
  }) {
    if (readOnly) {
      return GestureDetector(
        onTap: () {
          if (hint == "Passengers") {
            _showPassengerSelector();
          } else if (hint == "Class") {
            _showClassSelector();
          }
        },
        child: Container(
          width: width,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            controller.text.isEmpty ? hint : controller.text,
            style: TextStyle(
              color: controller.text.isEmpty
                  ? Colors.grey.shade600
                  : Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      );
    }
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
        width: 300,
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          controller.text.isEmpty ? hint : controller.text,
          style: TextStyle(
            color: controller.text.isEmpty
                ? Colors.grey.shade600
                : Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

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
