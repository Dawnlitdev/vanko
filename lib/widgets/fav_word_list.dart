import 'package:flutter/material.dart';

class FavoriteWordList extends StatelessWidget {
  final List<Map<String, dynamic>>
      wordList; // This should be sorted before passing to this widget
  final Function(Map<String, dynamic>) onWordTap;
  final Function(String, int)?
      onRemoveFavorite; // Callback for removing favorites
  final ScrollController? scrollController;

  FavoriteWordList({
    required this.wordList, // Assume the list is already sorted when passed
    required this.onWordTap,
    this.onRemoveFavorite, // Accepts the optional remove favorite callback
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController, // Attach ScrollController
      itemCount: wordList.length,
      itemBuilder: (context, index) {
        final word = wordList[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8), // Rounded corners
              onTap: () => onWordTap(word),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            word['English Word'] ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            word['Wancho Word'] ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Dialect: ${word['table'] ?? 'Unknown'}', // Display the dialect name
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (onRemoveFavorite != null)
                      IconButton(
                        icon: Icon(Icons.favorite, color: Colors.red),
                        onPressed: () => onRemoveFavorite!(
                            word['table'] ?? 'UpperWancho',
                            word['ID'] ?? 0), // Use ID for removal
                      )
                    else
                      Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
