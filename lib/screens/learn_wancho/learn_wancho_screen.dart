import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LearnPage extends StatelessWidget {
  final List<Map<String, String>> learnLinks = [
    {
      'title': 'Introduction to Wancho Language',
      'url': 'https://dawnlitdev.com/what-is-wancho/'
    },
    {
      'title': 'Basic Grammar in Wancho',
      'url': 'https://dawnlitdev.com/how-to-learn-wancho/'
    },
    {
      'title': 'Wancho Vocabulary List',
      'url': 'https://dawnlitdev.com/grammar-of-wancho/'
    },
    {
      'title': 'Cultural Context and Language',
      'url': 'https://example.com/cultural-context-wancho'
    },
    {
      'title': 'Advanced Wancho Studies',
      'url': 'https://example.com/advanced-wancho'
    },
  ];

  Future<void> _openUrl(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Learn Wancho',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: learnLinks.length,
          itemBuilder: (context, index) {
            final link = learnLinks[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () => _openUrl(context, link['url']!),
                child: Text(
                  link['title']!,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
