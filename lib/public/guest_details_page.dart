import 'package:flutter/material.dart';
import 'package:ticketing_flutter/public/booking_summary.dart';

class GuestDetailsPage extends StatefulWidget {
  final Map<String, dynamic> flight;

  const GuestDetailsPage({super.key, required this.flight});

  @override
  State<GuestDetailsPage> createState() => _GuestDetailsPageState();
}

class _GuestDetailsPageState extends State<GuestDetailsPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController passportController = TextEditingController();

  String? selectedTitle;
  String? selectedGender;
  DateTime? selectedDob;
  DateTime? passportExpiryDate;

  // Date Pickers
  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => selectedDob = picked);
  }

  Future<void> _pickPassportExpiry() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) setState(() => passportExpiryDate = picked);
  }

  void _proceedToBooking() {
    if (selectedTitle == null ||
        firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        selectedDob == null ||
        selectedGender == null ||
        contactController.text.isEmpty ||
        emailController.text.isEmpty ||
        nationalityController.text.isEmpty ||
        passportController.text.isEmpty ||
        passportExpiryDate == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: const Color(0xFF1E3A8A),
          content: const SizedBox(
            width: 350,
            child: Text(
              "Please fill in all guest details.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "OK",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    final guest = {
      "title": selectedTitle ?? "",
      "firstName": firstNameController.text,
      "middleName": middleNameController.text,
      "lastName": lastNameController.text,
      "dob": "${selectedDob!.day}/${selectedDob!.month}/${selectedDob!.year}",
      "gender": selectedGender ?? "",
      "nationality": nationalityController.text,
      "passport": passportController.text,
      "passportExpiry":
          "${passportExpiryDate!.day}/${passportExpiryDate!.month}/${passportExpiryDate!.year}",
      "contact": contactController.text,
      "email": emailController.text,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingSummaryPage(flight: widget.flight, guest: guest),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flight = widget.flight;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
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
                  color: const Color(0xFFDBEAFE),
                  width: double.infinity,
                ),
              ),
            ],
          ),
          // Centered card with form
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    const Text(
                      "Guest Details",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    // Flight summary
                    Text(
                      "${flight["from"]} → ${flight["to"]}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF1E3A8A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${flight["airline"]} | ${flight["date"]} ${flight["time"]}",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Price: ${flight["price"]}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Divider(height: 32, thickness: 1),
                    // Form fields (single column)
                    DropdownButtonFormField<String>(
                      value: selectedTitle,
                      decoration: const InputDecoration(
                        labelText: "Title",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      items: ["Mr", "Ms", "Mrs"].map((title) {
                        return DropdownMenuItem(
                          value: title,
                          child: Text(title),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => selectedTitle = value);
                      },
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: selectedGender,
                      decoration: const InputDecoration(
                        labelText: "Gender",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.wc),
                      ),
                      items: ["Male", "Female"].map((gender) {
                        return DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => selectedGender = value);
                      },
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        labelText: "First Name",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.badge),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: middleNameController,
                      decoration: const InputDecoration(
                        labelText: "Middle Name (optional)",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.badge),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        labelText: "Last Name",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.badge),
                      ),
                    ),
                    const SizedBox(height: 15),
                    InkWell(
                      onTap: _pickDob,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: "Date of Birth",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.cake),
                        ),
                        child: Text(
                          selectedDob == null
                              ? "Select Date"
                              : "${selectedDob!.day}/${selectedDob!.month}/${selectedDob!.year}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: nationalityController,
                      decoration: const InputDecoration(
                        labelText: "Nationality",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.flag),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: passportController,
                      decoration: const InputDecoration(
                        labelText: "Passport Number",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.book),
                      ),
                    ),
                    const SizedBox(height: 15),
                    InkWell(
                      onTap: _pickPassportExpiry,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: "Passport Expiry",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.date_range),
                        ),
                        child: Text(
                          passportExpiryDate == null
                              ? "Select Date"
                              : "${passportExpiryDate!.day}/${passportExpiryDate!.month}/${passportExpiryDate!.year}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: contactController,
                      decoration: const InputDecoration(
                        labelText: "Contact Number",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: "Email Address",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
                        onPressed: _proceedToBooking,
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
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
      ),
    );
  }
}
