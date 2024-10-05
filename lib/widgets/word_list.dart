import 'package:flutter/material.dart';

class WordList extends StatelessWidget {
  final List<Map<String, dynamic>> wordList;
  final Function(Map<String, dynamic>) onWordTap;
  final Function(String, String)?
      onRemoveFavorite; // Optional callback for removing favorites
  final ScrollController? scrollController;

  WordList({
    required List<Map<String, dynamic>> wordList,
    required this.onWordTap,
    this.onRemoveFavorite, // Accepts the optional remove favorite callback
    this.scrollController,
  }) : wordList = wordList
          ..sort((a, b) => (a['English Word']?.toLowerCase() ?? '')
              .compareTo(b['English Word']?.toLowerCase() ?? ''));

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
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                    if (onRemoveFavorite != null)
                      IconButton(
                        icon: Icon(Icons.favorite, color: Colors.red),
                        onPressed: () => onRemoveFavorite!(
                            word['table'] ?? 'UpperWancho',
                            word['English Word'] ?? ''),
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
