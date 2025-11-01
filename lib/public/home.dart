import 'package:flutter/material.dart';
import 'package:ticketing_flutter/public/book.dart';
import 'package:ticketing_flutter/auth/login.dart'; // Add this import

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isPressed = false;
  bool _isHovered = false;

  bool _signInPressed = false;

  late PageController _pageController;
  int _currentPage = 0;

  final List<String> _carouselImages = [
    'assets/boracay.webp',
    'assets/cebu.webp',
    'assets/davao.webp',
    'assets/hongkong.webp',
    'assets/palawan.webp',
    'assets/singapore.webp',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.75);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      _currentPage = _currentPage + 1;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Dark blue status bar section
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 50, // Height for status bar area
            child: Container(
              color: Colors.black, // Simple black color
            ),
          ),

          // White top section
          Positioned(
            top: 50, // Start below the dark blue section
            left: 0,
            right: 0,
            height: 65, // Change from 100 to 60 (or whatever height you want)
            child: Container(
              color: Colors.grey[100], // Light gray instead of white
            ),
          ),

          // Airline branding in white section
          Positioned(
            top: 55, // Adjust this to fit in the shorter white section
            left: 20, // Left margin
            child: Row(
              children: [
                Container(
                  width: 40, // Circle size
                  height: 40, // Circle size
                  decoration: BoxDecoration(
                    color: Colors.black, // Black circle background
                    shape: BoxShape.circle, // Makes it circular
                  ),
                  child: Icon(
                    Icons.flight_takeoff,
                    color: Colors.white, // White airplane icon
                    size: 24, // Slightly smaller to fit in circle
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Airlines Ticketing',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Gothic',
                      ),
                    ),
                    SizedBox(height: 2), // Small spacing between texts
                    Text(
                      'Your Journey Begins Here',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Gothic',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Sign In text on the right side
          // Sign In text on the right side
          Positioned(
            top:
                50 +
                (58 / 2) -
                15, // 50 (start) + 32.5 (center) - 15 (half button height) = 67.5
            right: 20, // Right margin
            child: GestureDetector(
              onTapDown: (_) => setState(() => _signInPressed = true),
              onTapUp: (_) => setState(() => _signInPressed = false),
              onTapCancel: () => setState(() => _signInPressed = false),
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const LoginPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(
                  horizontal: _signInPressed ? 21 : 15, // widen on touch
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                    255,
                    3,
                    24,
                    41,
                  ), // Blue background
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white, // White text on blue background
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gothic',
                  ),
                ),
              ),
            ),
          ),

          // Background gradient
          Positioned(
            top: 110, // Adjust this (50 + 60 = 110)
            left: 0,
            right: 0,
            bottom: 0,
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

          // Good Morning Text
          Positioned(
            top: 150, // Adjust this to position text correctly
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Fly Beyond Your Dreams',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gothic',
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Carousel
          Positioned(
            top: 200,
            left: 0,
            right: 0,
            height: 500,
            child: PageView.builder(
              controller: _pageController,
              itemCount:
                  _carouselImages.length *
                  1000, // Create a large number for infinite effect
              onPageChanged: (index) {
                setState(() => _currentPage = index);
                // Reset to beginning when we reach the end to prevent overflow
                if (index >= _carouselImages.length * 999) {
                  _pageController.jumpToPage(_carouselImages.length * 500);
                }
              },
              itemBuilder: (context, index) {
                final actualIndex = index % _carouselImages.length;
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 1.0;
                    if (_pageController.position.haveDimensions) {
                      value = (_pageController.page! - index).abs();
                      value = (1 - (value * 0.3)).clamp(0.85, 1.0);
                    }
                    return Center(
                      child: Transform.scale(
                        scale: value,
                        child: Container(
                          height:
                              400, // Add this line to make the container fill the available height
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              _carouselImages[actualIndex],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity, // Add this line too
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Get Started Button
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    _isPressed = true;
                    _isHovered = true;
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    _isPressed = false;
                    _isHovered = false;
                  });
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const Book(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                onTapCancel: () {
                  setState(() {
                    _isPressed = false;
                    _isHovered = false;
                  });
                },
                onPanDown: (_) => setState(() => _isHovered = true),
                onPanEnd: (_) => setState(() {
                  _isHovered = false;
                  _isPressed = false; // ensure it returns to original size
                }),
                onPanCancel: () => setState(() {
                  _isHovered = false;
                  _isPressed = false; // ensure it returns to original size
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  height: 60,
                  width: _isPressed ? 320 : 300, // widen box on press
                  padding: EdgeInsets.symmetric(
                    horizontal: _isPressed ? 24 : 20, // widen content on press
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: _isPressed
                          ? Colors.blue.shade300
                          : _isHovered
                          ? Colors.blue.shade200
                          : Colors.white,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(_isHovered ? 0.2 : 0.1),
                        blurRadius: _isHovered ? 35 : 25,
                        offset: Offset(0, _isHovered ? 15 : 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        color: _isPressed
                            ? Colors.blue.shade300
                            : _isHovered
                            ? Colors.blue.shade200
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: _isPressed
                            ? 32
                            : 30, // don't shrink; grow a bit on press
                      ),
                      child: const Text('GET STARTED'),
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
