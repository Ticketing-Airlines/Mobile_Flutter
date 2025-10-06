import 'package:flutter/material.dart';
import 'package:ticketing_flutter/services/user_service.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final users = UserService().users;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Registered Users"),
        backgroundColor: const Color(0xFF1E3A8A),
      ),
      body: users.isEmpty
          ? const Center(child: Text("No users registered yet."))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.person, color: Color(0xFF1E3A8A)),
                    title: Text(user.fullName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email: ${user.email}"),
                        Text("Address: ${user.address}"),
                        Text("Age: ${user.age}"),
                        Text("Gender: ${user.gender}"),
                        Text("Birthdate: ${user.birthdate}"),
                        Text("Contact: ${user.contactNumber}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
