import 'package:flutter/material.dart';
import '/services/database_helper.dart';
import '/widgets/word_details.dart'; // Import the WordDetails widget
import '/widgets/fav_word_list.dart'; // Import the new FavoriteWordList widget

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> favoriteWords = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // Method to load favorite words from all tables
  Future<void> _loadFavorites() async {
    List<Map<String, dynamic>> favoritesUpper =
        await DatabaseHelper.instance.fetchFavorites('UpperWancho');
    List<Map<String, dynamic>> favoritesMiddle =
        await DatabaseHelper.instance.fetchFavorites('MiddleWancho');
    List<Map<String, dynamic>> favoritesLower =
        await DatabaseHelper.instance.fetchFavorites('LowerWancho');

    setState(() {
      favoriteWords = [
        ...favoritesUpper,
        ...favoritesMiddle,
        ...favoritesLower
      ];
    });
  }

  // Method to unmark a word as favorite using ID
  Future<void> _unmarkFavorite(String tableName, int id) async {
    await DatabaseHelper.instance.toggleFavorite(tableName, id, false);
    _loadFavorites(); // Reload favorites after unmarking
  }

  // Method to handle word tap and show details
  void _onWordTap(Map<String, dynamic> word) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WordDetails(
          word: word,
          tableName: word['table'].toString(), // Ensure this is a String
        );
      },
    ).then((_) {
      // Ensure the favorite state is refreshed after closing the popup
      _loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: favoriteWords.isEmpty
          ? Center(child: Text('No favorite words found.'))
          : FavoriteWordList(
              wordList: favoriteWords,
              onWordTap: _onWordTap,
              onRemoveFavorite: (tableName, id) =>
                  _unmarkFavorite(tableName, id),
            ),
    );
  }
}
