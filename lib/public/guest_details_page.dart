import 'package:flutter/material.dart';
import 'package:ticketing_flutter/public/booking_summary.dart';
import 'package:ticketing_flutter/services/flight.dart';

class GuestDetailsPage extends StatefulWidget {
  final Flight flight;
  final Map<String, dynamic> bundle; // Define bundle as Map<String, dynamic>

  const GuestDetailsPage({
    super.key,
    required this.flight,
    required this.bundle,
  });

  @override
  State<GuestDetailsPage> createState() => _GuestDetailsPageState();
}

class _GuestDetailsPageState extends State<GuestDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedTitle;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  DateTime? _selectedDob;
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isPrivatePolicyChecked = false;

  InputDecoration buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      filled: true,
      fillColor: Colors.grey.shade200,
    );
  }

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDob = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFDBEAFE),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "${widget.flight.from} → ${widget.flight.to}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF1E3A8A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${widget.flight.airline} | ${widget.flight.date} ${widget.flight.time}",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Price: ${widget.flight.price}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Divider(height: 32, thickness: 1),
                    Text(
                      "Guest Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Title",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                        items: ["Mr", "Ms", "Mrs"].map((title) {
                          return DropdownMenuItem(
                            value: title,
                            child: Text(title),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedTitle = value);
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Please select a title";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: buildInputDecoration("First Name"),
                      controller: _firstNameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your first name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: buildInputDecoration("Last Name"),
                      controller: _lastNameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your last name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    InkWell(
                      onTap: _pickDob,
                      child: InputDecorator(
                        decoration: buildInputDecoration("Date of Birth"),
                        child: Text(
                          _selectedDob == null
                              ? "Select Date"
                              : "${_selectedDob!.day}/${_selectedDob!.month}/${_selectedDob!.year}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: buildInputDecoration("Nationality"),
                      controller: _nationalityController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your nationality";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: buildInputDecoration("Mobile Number"),
                      controller: _mobileNumberController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your mobile number";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: buildInputDecoration("Email"),
                      controller: _emailController,
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _isPrivatePolicyChecked,
                          onChanged: (value) {
                            setState(() => _isPrivatePolicyChecked = value!);
                          },
                        ),
                        Text("I agree to the private policy"),
                      ],
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 0.5,
                    ), // reduce the height to move the button up

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 32,
                        ), // adjust height and width
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            _isPrivatePolicyChecked) {
                          final guest = {
                            "title": _selectedTitle,
                            "firstName": _firstNameController.text,
                            "lastName": _lastNameController.text,
                            "dob":
                                "${_selectedDob!.day}/${_selectedDob!.month}/${_selectedDob!.year}",
                            "nationality": _nationalityController.text,
                            "mobileNumber": _mobileNumberController.text,
                            "email": _emailController.text,
                          };

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingSummaryPage(
                                flight: {
                                  'from': widget.flight.from,
                                  'to': widget.flight.to,
                                  'airline': widget.flight.airline,
                                  'date': widget.flight.date,
                                  'time': widget.flight.time,
                                  'price': widget.flight.price.toString(),
                                },
                                bundle: widget.bundle,
                                guest: guest,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Please fill in all fields and agree to the private policy",
                              ),
                            ),
                          );
                        }
                      },
                      child: Text("Continue"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
