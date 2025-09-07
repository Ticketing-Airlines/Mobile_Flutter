import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController gmailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? selectedGender;
  DateTime? selectedBirthDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Registration")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Create an Account",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Full Name
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Gmail
            TextField(
              controller: gmailController,
              decoration: const InputDecoration(
                labelText: "Gmail",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),

            // Address
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: "Address",
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Age
            TextField(
              controller: ageController,
              decoration: const InputDecoration(
                labelText: "Age",
                prefixIcon: Icon(Icons.cake),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),

            // Gender (Dropdown)
            DropdownButtonFormField<String>(
              value: selectedGender,
              decoration: const InputDecoration(
                labelText: "Gender",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.people),
              ),
              items: ["Male", "Female", "Other"].map((gender) {
                return DropdownMenuItem(value: gender, child: Text(gender));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                });
              },
            ),
            const SizedBox(height: 15),

            // Birthdate (Date Picker)
            TextField(
              readOnly: true,
              controller: TextEditingController(
                text: selectedBirthDate == null
                    ? ""
                    : "${selectedBirthDate!.year}-${selectedBirthDate!.month.toString().padLeft(2, '0')}-${selectedBirthDate!.day.toString().padLeft(2, '0')}",
              ),
              decoration: const InputDecoration(
                labelText: "Birthdate",
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedBirthDate = pickedDate;
                  });
                }
              },
            ),
            const SizedBox(height: 15),

            // Contact Number
            TextField(
              controller: contactController,
              decoration: const InputDecoration(
                labelText: "Contact Number",
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 15),

            // Create Password
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Create Password",
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Confirm Password
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Confirm Password",
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            // Register Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String fullName = fullNameController.text;
                  String gmail = gmailController.text;
                  String address = addressController.text;
                  String age = ageController.text;
                  String contact = contactController.text;
                  String password = passwordController.text;
                  String confirmPassword = confirmPasswordController.text;

                  if (password != confirmPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Passwords do not match")),
                    );
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Registered: $fullName ($gmail), Age: $age, Gender: $selectedGender",
                      ),
                    ),
                  );
                },
                child: const Text("Register"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
