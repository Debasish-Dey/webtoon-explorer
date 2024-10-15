import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class FavoritesProvider extends ChangeNotifier {
  Map<String, Map<String, dynamic>> _favorites = {};
  Box<Map> favoritesBox = Hive.box<Map>('webtoonfavoritesBox');

  FavoritesProvider() {
    final savedFavorites = favoritesBox.toMap();
    savedFavorites.forEach((key, value) {
      _favorites[key] = {
        'imageUrl': value['imageUrl'],
        'rating': value['rating'] ?? 0.0,
      };
    });
  }

  Map<String, Map<String, dynamic>> get favorites => _favorites;

  //add to favorites
  void addFavorite(String webtoonTitle, String imageUrl) {
    _favorites[webtoonTitle] = {
      'imageUrl': imageUrl,
      'rating': 0.0,
    };
    favoritesBox.put(webtoonTitle, {
      'title': webtoonTitle,
      'imageUrl': imageUrl,
      'rating': 0.0,
    });
    notifyListeners();
  }

  //remove from favorites
  void removeFavorite(String title) {
    _favorites.remove(title);
    favoritesBox.delete(title);
    notifyListeners();
  }

  // Update rating for a specific webtoon
  void updateRating(String webtoonTitle, double rating) {
    // Check if the webtoon is already in the favorites
    if (_favorites.containsKey(webtoonTitle)) {
      _favorites[webtoonTitle]!['rating'] = rating;
      favoritesBox.put(webtoonTitle, {
        'imageUrl': _favorites[webtoonTitle]!['imageUrl'],
        'rating': rating
      });
      notifyListeners();
    }
  }

  double getRating(String webtoonTitle) {
    return _favorites[webtoonTitle]?['rating'] ?? 0.0;
  }
}
