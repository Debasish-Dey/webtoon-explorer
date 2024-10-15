import 'package:flutter/material.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final Map<String, String> character;

  const CharacterDetailsScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    // Background gradient colors based on the character
    List<Color> backgroundGradientColors;
    switch (character['name']) {
      case 'Persephone':
        backgroundGradientColors = [Colors.pink.shade100, Colors.white];
        break;
      case 'Hades':
        backgroundGradientColors = [Colors.blue.shade200, Colors.blue.shade800];
        break;
      case 'Zeus':
        backgroundGradientColors = [
          Colors.yellow.shade200,
          Colors.yellow.shade800
        ];
        break;
      case 'Poseidon':
        backgroundGradientColors = [
          Colors.green.shade100,
          Colors.green.shade500
        ];
        break;
      case 'Eros':
        backgroundGradientColors = [Colors.red.shade100, Colors.red.shade500];
        break;
      default:
        backgroundGradientColors = [Colors.grey.shade200, Colors.grey.shade400];
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(character['name']!),
        backgroundColor: backgroundGradientColors.last,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: backgroundGradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Character Image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    character['imageUrl']!,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Character Name
              Center(
                child: Text(
                  character['name']!,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Character Description
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 4,
                      blurRadius: 8,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Text(
                  character['description']!,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.5,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
