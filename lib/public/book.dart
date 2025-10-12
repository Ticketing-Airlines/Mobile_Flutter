import 'package:flutter/material.dart';
import 'package:ticketing_flutter/public/book_oneway.dart';
import 'package:ticketing_flutter/public/book_roundtrip.dart';
import 'package:ticketing_flutter/public/book_multicity.dart';
import 'package:ticketing_flutter/public/search_flight.dart';
import 'package:ticketing_flutter/auth/login.dart';
import 'package:ticketing_flutter/services/countries.dart';
import 'package:ticketing_flutter/public/flight_booking_page.dart';
import 'dart:async';

class Book extends StatefulWidget {
  const Book({super.key});

  @override
  State<Book> createState() => _Book();
}

class _Book extends State<Book> {
  final TextEditingController box4Controller = TextEditingController();
  final TextEditingController box5Controller = TextEditingController();
  final TextEditingController box6Controller = TextEditingController();
  int _selectedPrice = 10000;
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

    // auto-sliding info bar setup
  }

  // New function to centralize price calculation
  void _calculatePrice() {
    // Only calculate if a date has been picked
    if (box6Controller.text.isNotEmpty) {
      DateTime today = DateTime.now();
      DateTime pickedDate = DateTime.parse(box6Controller.text);
      int daysDiff = pickedDate.difference(today).inDays;

      // Base price logic (from buildDatePickerField)
      int basePrice = 10000 - (daysDiff * 100);
      if (basePrice < 2000) basePrice = 2000;

      // Class multiplier logic (from _buildClassOption)
      double multiplier = 1.0;
      if (_selectedClass == "Business") {
        multiplier = 3.0;
      } else if (_selectedClass == "First Class") {
        multiplier = 6.0;
      }

      // Recalculate and set the new selected price
      _selectedPrice =
          ((basePrice * _adults +
                      (basePrice * 0.75 * _children).round() +
                      (basePrice * 0.10 * _infants).round()) *
                  multiplier)
              .round();
    }
  }

  void _navigateToPage(String boxName, Widget page) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
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
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 35),
                    child: ElevatedButton(
                      onPressed: () {
                        final total = _adults + _children + _infants;
                        box7Controller.text = "$total Passengers";

                        // Update the main state and calculate the new price
                        this.setState(() {
                          _calculatePrice();
                        });

                        Navigator.pop(context);
                      },
                      child: const Text('Done'),
                    ),
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
          padding: const EdgeInsets.only(
            top: 12,
            left: 20,
            right: 20,
            bottom: 50,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildClassOption("Economy"),
              const Divider(),
              _buildClassOption("Business"),
              const Divider(),
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
          // Recalculate price based on class
          _calculatePrice();
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
        backgroundColor: const Color(0xFF111827),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF000000),
                      Color(0xFF111827),
                      Color(0xFF1E3A8A),
                    ],
                  ),
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.flight, color: Colors.white),
              title: const Text('Book', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FlightBookingPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.manage_accounts, color: Colors.white),
              title: const Text(
                'Manage',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.white),
              title: const Text(
                'Travel Info',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.explore, color: Colors.white),
              title: const Text(
                'Explore',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: const Text('About', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.login, color: Colors.white),
              title: const Text('Login', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;
          final boxHeight = 500.0;
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
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF000000),
                            Color(0xFF111827),
                            Color(0xFF1E3A8A),
                          ],
                        ),
                      ),
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
                        // 🔹 Updated Search Button
                        GestureDetector(
                          onTapDown: (_) {
                            setState(() => _isSearchPressed = true);
                          },
                          onTapUp: (_) {
                            setState(() => _isSearchPressed = false);

                            // Validation: Check if all required fields are filled
                            if (box4Controller.text.isEmpty ||
                                box5Controller.text.isEmpty ||
                                box6Controller.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please fill in all required fields',
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 3),
                                ),
                              );
                              return;
                            }

                            // Validate that both country and city are selected for From/To fields
                            bool isFromValid = box4Controller.text.contains(
                              " - ",
                            );
                            bool isToValid = box5Controller.text.contains(
                              " - ",
                            );

                            if (!isFromValid || !isToValid) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please select a city'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 3),
                                ),
                              );
                              return;
                            }

                            _navigateToPage("Box 9", const SearchFlightsPage());
                          },
                          onTapCancel: () {
                            setState(() => _isSearchPressed = false);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: double.infinity, // w-full
                            height: 56, // h-14
                            decoration: BoxDecoration(
                              color: _isSearchPressed
                                  ? const Color.fromARGB(
                                      255,
                                      53,
                                      56,
                                      58,
                                    ) // Slightly darker when pressed
                                  : const Color.fromARGB(
                                      255,
                                      5,
                                      23,
                                      37,
                                    ), // Same as lower drawer half
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Search Flights',
                                  style: TextStyle(
                                    color: Colors
                                        .white, // Black text for visibility
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: boxTop - 45, // 40 pixels above the box
                left: boxLeft,
                child: SizedBox(
                  width: boxWidth,
                  child: Center(
                    child: Text(
                      'Where do you want to fly?',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 129, 150, 207),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 49, // adjust as you like
                left: 0,
                right: 0,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.copyright,
                        size: 20,
                        color: Color.fromARGB(179, 7, 7, 7),
                      ),
                      SizedBox(width: 6),
                      Text(
                        '2025 Airlines Ticketing. All Rights Reserved',
                        style: TextStyle(
                          color: Color.fromARGB(179, 26, 25, 25),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // BELOW the main white box
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
      child: RawAutocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          String input = textEditingValue.text.toLowerCase();
          List<String> options = [];

          // Check if the input is a country name (exact match)
          bool isExactCountry = countries1.contains(textEditingValue.text);
          if (isExactCountry) {
            // User has selected a country, show cities for that country
            String countryName = textEditingValue.text;
            if (countryCities.containsKey(countryName)) {
              List<String> cities = countryCities[countryName]!;
              for (String city in cities) {
                options.add(city); // Just show city names, not "Country - City"
              }

              // Exclude the option selected in the other field
              if (controller == box4Controller &&
                  box5Controller.text.isNotEmpty) {
                options = options
                    .where((c) => c != box5Controller.text)
                    .toList();
              } else if (controller == box5Controller &&
                  box4Controller.text.isNotEmpty) {
                options = options
                    .where((c) => c != box4Controller.text)
                    .toList();
              }

              return options;
            }
          }

          // If input is empty or not an exact country match, show countries
          List<String> countryOptions = List<String>.from(countries1);

          // Exclude the option selected in the other field
          if (controller == box4Controller && box5Controller.text.isNotEmpty) {
            countryOptions = countryOptions
                .where((c) => c != box5Controller.text)
                .toList();
          } else if (controller == box5Controller &&
              box4Controller.text.isNotEmpty) {
            countryOptions = countryOptions
                .where((c) => c != box4Controller.text)
                .toList();
          }

          return countryOptions;
        },
        fieldViewBuilder:
            (context, textEditingController, focusNode, onFieldSubmitted) {
              // Update the controller when this widget is first built
              if (controller.text.isNotEmpty) {
                textEditingController.text = controller.text;
              }

              return TextField(
                controller: textEditingController,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                ),
                onTap: () {
                  // This will force the options to show immediately when field is tapped
                  textEditingController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: textEditingController.text.length,
                  );
                  // Trigger the options to show by simulating a change
                  focusNode.requestFocus();
                },
                onChanged: (value) {
                  controller.text = value;
                },
              );
            },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4.0,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 200,
                  maxWidth: 300,
                ),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String option = options.elementAt(index);
                    return InkWell(
                      onTap: () {
                        if (countryCities.containsKey(option)) {
                          // If it's a country, show its cities in the dropdown
                          setState(() {
                            // Replace the current text with the selected country
                            controller.text = option;
                          });

                          // Update the autocomplete field’s options to that country's cities
                          Future.delayed(const Duration(milliseconds: 100), () {
                            FocusScope.of(context).requestFocus(
                              FocusNode(),
                            ); // close current dropdown
                            Future.delayed(
                              const Duration(milliseconds: 100),
                              () {
                                // reopen autocomplete with city options
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SimpleDialog(
                                      title: Text("Select City in $option"),
                                      children: countryCities[option]!.map((
                                        city,
                                      ) {
                                        return SimpleDialogOption(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            setState(() {
                                              controller.text =
                                                  "$option - $city";
                                            });
                                          },
                                          child: Text(city),
                                        );
                                      }).toList(),
                                    );
                                  },
                                );
                              },
                            );
                          });
                        } else {
                          // If it's already a city, just select it
                          onSelected(option);
                          controller.text = option;
                        }
                      },

                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(option),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
        onSelected: (String selection) {
          controller.text = selection;
          setState(() {}); // Refresh the other field's options
        },
      ),
    );
  }

  Widget buildAutocompleteField2(
    String hint,
    TextEditingController controller,
  ) {
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
          List<String> options = List<String>.from(countries1);
          if (textEditingValue.text == '') {
            return options;
          }

          // Exclude the option selected in the other field
          if (controller == box4Controller && box5Controller.text.isNotEmpty) {
            options = options.where((c) => c != box5Controller.text).toList();
          } else if (controller == box5Controller &&
              box4Controller.text.isNotEmpty) {
            options = options.where((c) => c != box4Controller.text).toList();
          }

          return options.where(
            (option) => option.toLowerCase().contains(
              textEditingValue.text.toLowerCase(),
            ),
          );
        },
        onSelected: (String selection) {
          controller.text = selection;
          setState(() {}); // Refresh the other field's options
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
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
            color: Colors.black,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
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

              // Calculate price based on date and current passengers/class
              setState(() {
                _calculatePrice();
              });
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
        ),
        // Only show price if a date has been selected
        if (controller.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 8),
            child: Text(
              'Total Price: ₱$_selectedPrice',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
          ),
      ],
    );
  }
}
