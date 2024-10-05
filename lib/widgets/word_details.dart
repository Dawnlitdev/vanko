import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:share_plus/share_plus.dart'; // For Sharing with share_plus
import '/services/database_helper.dart'; // Import DatabaseHelper

class WordDetails extends StatefulWidget {
  final Map<String, dynamic> word;
  final String tableName; // Add this to track which table the word belongs to

  WordDetails({required this.word, required this.tableName});

  @override
  _WordDetailsState createState() => _WordDetailsState();
}

class _WordDetailsState extends State<WordDetails> {
  bool isFavorite = false; // Initialize with a default value

  @override
  void initState() {
    super.initState();
    _initializeFavoriteState(); // Fetch the initial favorite state
  }

  Future<void> _initializeFavoriteState() async {
    // Fetch the latest favorite status from the database using ID
    bool favoriteStatus = await DatabaseHelper.instance.isWordFavorite(
        widget.tableName,
        widget.word['ID']); // Use 'ID' instead of 'English Word'

    setState(() {
      isFavorite = favoriteStatus;
    });
  }

  void _toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite; // Toggle the local state
    });

    // Update the database using ID
    await DatabaseHelper.instance.toggleFavorite(widget.tableName,
        widget.word['ID'], isFavorite); // Use 'ID' instead of 'English Word'
  }

  void _copyToClipboard(BuildContext context) {
    final text = '''
English Word: ${widget.word['English Word'] ?? ''}
Wancho Word: ${widget.word['Wancho Word'] ?? ''}
Word Type: ${widget.word['Word Type'] ?? ''}
English Example: ${widget.word['English Example Sentence'] ?? ''}
Wancho Example: ${widget.word['Wancho Example Sentence'] ?? ''}
''';

    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied to Clipboard!')),
    );
  }

  void _shareWordDetails() {
    final text = '''
English Word: ${widget.word['English Word'] ?? ''}
Wancho Word: ${widget.word['Wancho Word'] ?? ''}
Word Type: ${widget.word['Word Type'] ?? ''}
English Example: ${widget.word['English Example Sentence'] ?? ''}
Wancho Example: ${widget.word['Wancho Example Sentence'] ?? ''}
''';

    Share.share(text); // Using share_plus package
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 16,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Word Title
            Center(
              child: Text(
                widget.word['English Word'] ?? '',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            SizedBox(height: 8),

            // Word Type
            Center(
              child: Text(
                widget.word['Word Type'] ?? '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Divider(thickness: 1, color: Colors.grey[300]),

            // Wancho Translation
            SizedBox(height: 8),
            Text(
              'Wancho Translation:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              widget.word['Wancho Word'] ?? '',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),

            // Example Sentences
            SizedBox(height: 16),
            Text(
              'Example Sentence (English):',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              widget.word['English Example Sentence'] ?? '',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Example Sentence (Wancho):',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              widget.word['Wancho Example Sentence'] ?? '',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),

            // Action Buttons
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: _toggleFavorite, // Toggle favorite status
                ),
                IconButton(
                  icon: Icon(Icons.copy, color: Colors.blueAccent),
                  onPressed: () => _copyToClipboard(context),
                ),
                IconButton(
                  icon: Icon(Icons.share, color: Colors.green),
                  onPressed: _shareWordDetails,
                ),
              ],
            ),

            // Close Button
            SizedBox(height: 8),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
