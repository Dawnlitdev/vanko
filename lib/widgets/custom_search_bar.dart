import 'dart:async'; // Import for debounce functionality
import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(List<Map<String, dynamic>>)
      onSearchResult; // Callback with search results
  final List<Map<String, dynamic>> wordList; // The full list of words to search

  CustomSearchBar({required this.onSearchResult, required this.wordList});

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce; // Timer for debounce

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel(); // Cancel the debounce timer on dispose
    super.dispose();
  }

  // Debounce function to delay search
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  // Perform search and return results
  void _performSearch(String query) {
    final filteredList = widget.wordList.where((word) {
      final englishWord = word['English Word']?.toLowerCase() ?? '';
      return englishWord.contains(query.toLowerCase());
    }).toList();
    widget.onSearchResult(filteredList); // Pass results back to parent
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Type a word...',
          prefixIcon: Icon(Icons.search),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    _performSearch(''); // Clear search results
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        onChanged: _onSearchChanged, // Use debounce function on change
      ),
    );
  }
}
