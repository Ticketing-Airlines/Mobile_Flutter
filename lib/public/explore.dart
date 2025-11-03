import 'package:flutter/material.dart';

// --- ExplorePage StatefulWidget (Stays largely the same) ---
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePage();
}

class _ExplorePage extends State<ExplorePage> with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

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
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header banner
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    image: const DecorationImage(
                      // IMPORTANT: Ensure this asset path is correct in your pubspec.yaml
                      image: AssetImage('assets/singapore.webp'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: const Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Discover Beautiful Places',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Philippine Destinations
                const Text(
                  'Philippines Destinations ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),

                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: const [
                    // Note: Same imagePath but different title creates a unique Hero tag
                    DestinationCard(
                      imagePath: 'assets/boracay.webp',
                      title: 'Boracay',
                      subtitle: 'White Beach Paradise',
                    ),
                    DestinationCard(
                      imagePath: 'assets/palawan.webp',
                      title: 'Palawan',
                      subtitle: 'The Last Frontier',
                    ),
                    DestinationCard(
                      imagePath: 'assets/singapore.webp',
                      title: 'Siargao',
                      subtitle: 'Surfing Capital',
                    ),
                    DestinationCard(
                      imagePath: 'assets/bohol.webp',
                      title: 'Bohol',
                      subtitle: 'Chocolate Hills',
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // International Destinations
                const Text(
                  'International Destinations ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),

                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: const [
                    DestinationCard(
                      imagePath: 'assets/singapore.webp',
                      title: 'Tokyo',
                      subtitle: 'City of the Rising Sun',
                    ),
                    DestinationCard(
                      imagePath: 'assets/singapore.webp',
                      title: 'Seoul',
                      subtitle: 'K-Culture Capital',
                    ),
                    DestinationCard(
                      imagePath: 'assets/singapore.webp',
                      title: 'Singapore',
                      subtitle: 'Garden City',
                    ),
                    DestinationCard(
                      imagePath: 'assets/singapore.webp',
                      title: 'Dubai',
                      subtitle: 'Luxury in the Desert',
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Footer
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      " 2025 Airlines Ticketing. All rights reserved.",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 13,
                      ),
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
}

// --- DestinationCard StatefulWidget (Updated for Hover and Hero Fix) ---

// Reusable Destination Card Widget (Now Stateful for the scale effect)
class DestinationCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String subtitle;

  const DestinationCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  @override
  State<DestinationCard> createState() => _DestinationCardState();
}

class _DestinationCardState extends State<DestinationCard> {
  double _scale = 1.0; // State for the scaling effect

  // Create a unique Hero tag by combining imagePath and title
  String get _heroTag => '${widget.imagePath}_${widget.title}';

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 1.05; // Scale up slightly when pressed
    });
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0; // Return to original size
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0; // Return to original size when released
    });

    // Handle navigation after a tap
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageViewer(
          imagePath: widget.imagePath,
          heroTag: _heroTag, // Pass the unique tag to the next screen
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: () {}, // Required by InkWell
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Hero(
          tag: _heroTag, // Use the unique Hero tag as the source
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(widget.imagePath),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              offset: Offset(1, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        widget.subtitle,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- ImageViewer StatelessWidget (Updated for Hero Fix) ---
class ImageViewer extends StatelessWidget {
  final String imagePath;
  final String heroTag; // 👈 Requires the unique hero tag

  const ImageViewer({
    super.key,
    required this.imagePath,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Hero(
          tag: heroTag, // 👈 Uses the unique hero tag as the destination
          child: Image.asset(imagePath, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
