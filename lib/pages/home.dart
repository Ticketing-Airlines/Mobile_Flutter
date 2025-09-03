import 'package:flutter/material.dart';
import 'package:ticketing_flutter/pages/book.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset('assets/map.jpg', fit: BoxFit.cover),
          Positioned(
            top: 300, // adjust this value to move text lower/higher
            left: 0,
            right: 0,
            child: const Text(
              "Fly Everywhere With US",
              style: TextStyle(
                fontSize: 55,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 20,
                    color: Colors.blueAccent, // glowing outline
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Picture above the button
          Positioned(
            bottom: 470,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/logo.png', // 🔹 replace with your image
                height: 320, // adjust size
                width: 320,
              ),
            ),
          ),

          // Button placed lower on the screen
          Positioned(
            bottom: 100, // adjust this value to move up/down
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTapDown: (_) {
                  setState(() => _isPressed = true);
                },
                onTapUp: (_) {
                  setState(() => _isPressed = false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Book()),
                  );
                },
                onTapCancel: () {
                  setState(() => _isPressed = false);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _isPressed
                          ? [Colors.blue.shade900, Colors.blue.shade700]
                          : [Colors.blue.shade400, Colors.blue.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: _isPressed ? 4 : 12,
                        offset: _isPressed
                            ? const Offset(2, 2)
                            : const Offset(4, 6),
                      ),
                    ],
                  ),
                  child: const Text(
                    'GET STARTED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
