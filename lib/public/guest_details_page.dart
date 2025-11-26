import 'package:flutter/material.dart';
import 'package:ticketing_flutter/public/booking_summary.dart';
import 'package:ticketing_flutter/services/flight.dart';

class GuestDetailsPage extends StatefulWidget {
  final Flight flight;
  final Map<String, dynamic> bundle;
  final int adults;
  final int children;
  final int infants;

  const GuestDetailsPage({
    super.key,
    required this.flight,
    required this.bundle,
    required this.adults,
    required this.children,
    required this.infants,
  });

  @override
  State<GuestDetailsPage> createState() => _GuestDetailsPageState();
}

enum _PassengerType { adult, child, infant }

class _PassengerDescriptor {
  const _PassengerDescriptor({required this.type, required this.index});

  final _PassengerType type;
  final int index;

  String get typeLabel {
    switch (type) {
      case _PassengerType.adult:
        return "Adult";
      case _PassengerType.child:
        return "Child";
      case _PassengerType.infant:
        return "Infant";
    }
  }

  String get displayLabel => "$typeLabel ${index + 1}";

  String? get ageHint {
    switch (type) {
      case _PassengerType.adult:
        return "12+ years";
      case _PassengerType.child:
        return "2-11 years";
      case _PassengerType.infant:
        return "Under 2 years";
    }
  }
}

class _GuestFormModel {
  String? selectedTitle;
  DateTime? dob;
  int? age;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    nationalityController.dispose();
    mobileNumberController.dispose();
    emailController.dispose();
    ageController.dispose();
  }
}

class _GuestDetailsPageState extends State<GuestDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  late final List<_PassengerDescriptor> _passengers;
  late final List<_GuestFormModel> _guestForms;
  bool _isPrivatePolicyChecked = false;
  double? _selectedPrice;
  String? _selectedClass;

  @override
  void initState() {
    super.initState();
    _passengers = _buildPassengers();
    _guestForms = List.generate(_passengers.length, (_) => _GuestFormModel());
  }

  List<_PassengerDescriptor> _buildPassengers() {
    final passengers = <_PassengerDescriptor>[];

    for (var i = 0; i < widget.adults; i++) {
      passengers.add(
        _PassengerDescriptor(type: _PassengerType.adult, index: i),
      );
    }
    for (var i = 0; i < widget.children; i++) {
      passengers.add(
        _PassengerDescriptor(type: _PassengerType.child, index: i),
      );
    }
    for (var i = 0; i < widget.infants; i++) {
      passengers.add(
        _PassengerDescriptor(type: _PassengerType.infant, index: i),
      );
    }

    if (passengers.isEmpty) {
      passengers.add(
        const _PassengerDescriptor(type: _PassengerType.adult, index: 0),
      );
    }

    return passengers;
  }

  InputDecoration buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade300),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Future<void> _pickDob(int index) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        final form = _guestForms[index];
        form.dob = picked;
        form.age = _calculateAge(picked); // ← compute age
        form.ageController.text =
            form.age?.toString() ?? ""; // ← update controller so UI refreshes
      });
    }
  }

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    // Read selectedPrice and selectedClass from RouteSettings.arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      if (_selectedPrice == null) {
        final raw = args['selectedPrice'];
        if (raw is double) _selectedPrice = raw;
        if (raw is int) _selectedPrice = raw.toDouble();
      }
      if (_selectedClass == null && args['selectedClass'] != null) {
        _selectedClass = args['selectedClass'] as String;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
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
                const SizedBox(height: 4),
                Text(
                  "${widget.flight.airline} | ${widget.flight.date} ${widget.flight.time}",
                  style: const TextStyle(fontSize: 15, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  "Flight ${widget.flight.flightNumber}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                const Text(
                  "Guest Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 16),
                ...List.generate(
                  _passengers.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildGuestSection(index),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: _isPrivatePolicyChecked,
                      onChanged: (value) =>
                          setState(() => _isPrivatePolicyChecked = value!),
                    ),
                    const Expanded(
                      child: Text("I agree to the private policy"),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Continue button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGuestSection(int index) {
    final passenger = _passengers[index];
    final form = _guestForms[index];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            passenger.displayLabel,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A),
            ),
          ),
          if (passenger.ageHint != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                passenger.ageHint!,
                style: const TextStyle(color: Colors.black54),
              ),
            ),
          const SizedBox(height: 12),
          if (passenger.type == _PassengerType.adult) ...[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonFormField<String>(
                value: form.selectedTitle,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                ),
                items: ["Mr", "Ms", "Mrs"].map((title) {
                  return DropdownMenuItem(value: title, child: Text(title));
                }).toList(),
                onChanged: (value) {
                  setState(() => form.selectedTitle = value);
                },
                validator: (value) {
                  if (value == null) {
                    return "Select a title";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
          TextFormField(
            controller: form.firstNameController,
            decoration: buildInputDecoration("First Name"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter first name";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: form.lastNameController,
            decoration: buildInputDecoration("Last Name"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter last name";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => _pickDob(index),
            child: InputDecorator(
              decoration: buildInputDecoration("Date of Birth"),
              child: Text(
                form.dob == null
                    ? "Select Date"
                    : "${form.dob!.day}/${form.dob!.month}/${form.dob!.year}",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: form.ageController,
            decoration: buildInputDecoration("Age"),
            enabled: false,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: form.nationalityController,
            decoration: buildInputDecoration("Nationality"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter nationality";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          if (passenger.type == _PassengerType.adult) ...[
            TextFormField(
              controller: form.mobileNumberController,
              decoration: buildInputDecoration("Mobile Number"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter mobile number";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: form.emailController,
              decoration: buildInputDecoration("Email"),
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains('@')) {
                  return "Please enter a valid email";
                }
                return null;
              },
            ),
          ],
        ],
      ),
    );
  }

  void _handleSubmit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    if (!_isPrivatePolicyChecked) {
      _showSnackBar("Please agree to the private policy before continuing");
      return;
    }

    final missingDobIndex = _guestForms.indexWhere(
      (form) => form.dob == null || form.age == null,
    );
    if (missingDobIndex != -1) {
      final passenger = _passengers[missingDobIndex];
      _showSnackBar("Please select ${passenger.displayLabel}'s date of birth");
      return;
    }

    final guests = List.generate(_guestForms.length, (index) {
      final passenger = _passengers[index];
      final form = _guestForms[index];
      final guest = {
        "type": passenger.typeLabel,
        "label": passenger.displayLabel,
        "firstName": form.firstNameController.text,
        "lastName": form.lastNameController.text,
        "dob": "${form.dob!.day}/${form.dob!.month}/${form.dob!.year}",
        "nationality": form.nationalityController.text,
        "age": form.age,
      };
      if (passenger.type == _PassengerType.adult) {
        guest["title"] = form.selectedTitle;
        guest["mobileNumber"] = form.mobileNumberController.text;
        guest["email"] = form.emailController.text;
      }
      return guest;
    });

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            BookingSummaryPage(
              flight: widget.flight,
              bundle: widget.bundle,
              guests: guests,
              selectedPrice: _selectedPrice ?? widget.flight.price,
              selectedClass: _selectedClass,
            ),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    for (final form in _guestForms) {
      form.dispose();
    }
    super.dispose();
  }
}
