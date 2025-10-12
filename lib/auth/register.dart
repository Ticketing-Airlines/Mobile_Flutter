import 'package:flutter/material.dart';
import 'package:ticketing_flutter/auth/login.dart';
import 'package:ticketing_flutter/services/user_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF000000), Color(0xFF111827), Color(0xFF1E3A8A)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_add, size: 80, color: Colors.white),
                const SizedBox(height: 15),
                const Text(
                  "User Registration",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),

                // Full Name input
                _buildTextField(
                  controller: fullNameController,
                  label: "Full Name",
                  icon: Icons.person,
                ),
                const SizedBox(height: 20),

                // Email input
                _buildTextField(
                  controller: emailController,
                  label: "Email",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // Address input
                _buildTextField(
                  controller: addressController,
                  label: "Address",
                  icon: Icons.location_on,
                ),
                const SizedBox(height: 20),

                // Age input
                _buildTextField(
                  controller: ageController,
                  label: "Age",
                  icon: Icons.cake,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),

                // Gender input
                _buildTextField(
                  controller: genderController,
                  label: "Gender",
                  icon: Icons.transgender,
                ),
                const SizedBox(height: 20),

                // Birthdate input
                _buildTextField(
                  controller: birthdateController,
                  label: "Birthdate (YYYY-MM-DD)",
                  icon: Icons.calendar_today,
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 20),

                // Contact Number input
                _buildTextField(
                  controller: contactNumberController,
                  label: "Contact Number",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),

                // Password input
                _buildTextField(
                  controller: passwordController,
                  label: "Create Password",
                  icon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 20),

                // Confirm Password input
                _buildTextField(
                  controller: confirmPasswordController,
                  label: "Confirm Password",
                  icon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 30),

                // Register button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      side: const BorderSide(color: Colors.white, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _registerUser,
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Login option
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.white70),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Go back to the login page
                      },
                      child: const Text(
                        "Login now",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white70),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
    );
  }

  Future<void> _registerUser() async {
    String fullName = fullNameController.text.trim();
    String email = emailController.text.trim();
    String address = addressController.text.trim();
    String age = ageController.text.trim();
    String gender = genderController.text.trim();
    String birthdate = birthdateController.text.trim();
    String contactNumber = contactNumberController.text.trim();
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    // Validation: Check if any field is empty
    if (fullName.isEmpty ||
        email.isEmpty ||
        address.isEmpty ||
        age.isEmpty ||
        gender.isEmpty ||
        birthdate.isEmpty ||
        contactNumber.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showErrorDialog("Please fill in all fields.");
      return;
    }

    // Password match validation
    if (password != confirmPassword) {
      _showErrorDialog("Passwords do not match.");
      return;
    }

    // Prepare user data
    final userData = {
      "fullName": fullName,
      "email": email,
      "address": address,
      "age": age,
      "gender": gender,
      "birthdate": birthdate,
      "contactNumber": contactNumber,
      "password": password,
    };

    // Call the UserService to register the user
    final success = await UserService().registerUser(userData);

    if (success) {
      _showSuccessDialog();
    } else {
      _showErrorDialog("An error occurred while registering the account.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: const SizedBox(
          height: 80,
          child: Center(
            child: Text(
              "Account registered successfully!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ),
      ),
    );

    // Wait for 2 seconds, then close dialog and go back to login
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context)
        ..pop() // Close the dialog
        ..pop(); // Go back to login page
    }
  }
}
