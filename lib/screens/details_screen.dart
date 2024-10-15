import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webtoon_explorer/assets/character_list.dart';
import 'package:webtoon_explorer/assets/webtoon_list.dart';
import 'package:webtoon_explorer/services/favorites_provider_logic.dart';
import 'character_details_screen.dart';

class DetailsScreen extends StatefulWidget {
  final String title;

  const DetailsScreen({super.key, required this.title});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  double _currentRating = 1.0;
  bool _isFavorite = false;

  Map<String, dynamic>? _webtoonData;

  @override
  void initState() {
    super.initState();
    final favoritesProvider =
        Provider.of<FavoritesProvider>(context, listen: false);

    _webtoonData = webtoonList.firstWhere(
        (webtoon) => webtoon['title'] == widget.title,
        orElse: () => {});

    if (_webtoonData != null) {
      final initialRating = favoritesProvider.getRating(widget.title);
      setState(() {
        _currentRating =
            initialRating >= 1.0 && initialRating <= 5.0 ? initialRating : 1.0;
        _isFavorite = favoritesProvider.favorites.containsKey(widget.title);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider =
        Provider.of<FavoritesProvider>(context, listen: false);

    if (_webtoonData == null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
          child: Text(
            'Webtoon data not found.',
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.teal.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail Image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    _webtoonData!['imageUrl'],
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Webtoon Title
              Center(
                child: Text(
                  _webtoonData!['title'],
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 8),

              // Creator
              Center(
                child: Text(
                  'Creator: ${_webtoonData!['creator']}',
                  style: TextStyle(fontSize: 18, color: Colors.teal.shade900),
                ),
              ),
              SizedBox(height: 8),

              // Genre
              Center(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Genre: ${_webtoonData!['genre']}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Description
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.1),
                      spreadRadius: 4,
                      blurRadius: 10,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Text(
                  _webtoonData!['description'],
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              SizedBox(height: 16),

              // Add/Remove from Favorites
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      if (_isFavorite) {
                        // Remove from favorites
                        favoritesProvider.removeFavorite(widget.title);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Removed from Favorites!')),
                        );
                      } else {
                        // Add to favorites
                        favoritesProvider.addFavorite(
                            widget.title, _webtoonData!['imageUrl']);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added to Favorites!')),
                        );
                      }
                      _isFavorite = !_isFavorite;
                    });
                  },
                  icon: Icon(
                    _isFavorite ? Icons.favorite_border : Icons.favorite,
                    color: Colors.redAccent,
                  ),
                  label: Text(
                    _isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Show Rating Controls only if added to Favorites
              if (_isFavorite) ...[
                SizedBox(height: 16),

                // Rating Display
                Center(
                  child: Text(
                    'Current Rating: ${_currentRating.toStringAsFixed(1)} / 5',
                    style: TextStyle(fontSize: 18, color: Colors.teal.shade700),
                  ),
                ),
                SizedBox(height: 16),

                // Slider for rating
                Center(
                    child: Text('Rate this Webtoon:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500))),
                Slider(
                  min: 1.0,
                  max: 5.0,
                  divisions: 4,
                  label: _currentRating.toStringAsFixed(1),
                  activeColor: Colors.teal,
                  inactiveColor: Colors.teal.shade200,
                  value: _currentRating,
                  onChanged: (value) {
                    setState(() {
                      _currentRating = value;
                    });
                  },
                ),

                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Save the rating to the provider
                      favoritesProvider.updateRating(
                          widget.title, _currentRating);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Rating saved!')));
                    },
                    child: Text(
                      'Submit Rating',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],

              SizedBox(height: 32),

              // Characters Section
              Text(
                'Characters',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade800,
                ),
              ),
              SizedBox(height: 16),
              // Display Characters in a Grid View
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: characterList.length,
                itemBuilder: (context, index) {
                  final character = characterList[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to Character Details Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CharacterDetailsScreen(
                            character: character,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            character['imageUrl']!,
                            fit: BoxFit.cover,
                            height: 150,
                            width: 120,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          character['name']!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.teal.shade900,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
