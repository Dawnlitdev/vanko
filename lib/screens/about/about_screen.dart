import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  final String donateUrl = "https://www.instagram.com/avangwangsu/";
  final String contactUrl =
      "https://www.instagram.com/avangwangsu/"; // Use mailto for email

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Vanko Dictionary',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                          'assets/images/logo.jpg'), // Ensure you have this image
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Vanko English to Wancho Dictionary',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Divider(thickness: 1, color: Colors.grey[300]),
              SizedBox(height: 16),

              // About Us Section
              Text(
                'About Us',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Welcome to the English to Wancho Translation App, a labor of love brought to you by Dawlit Developers. Our team, led by the visionary developer Avang Wangsu, is dedicated to bridging the language gap between the world and the beautiful Wancho language.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.justify,
              ),

              SizedBox(height: 16),
              Text(
                'Our Mission',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Our mission is to connect people across languages and cultures, fostering understanding, and promoting inclusivity. We believe that language should not be a barrier to communication, and our app is designed to make the Wancho language accessible to everyone.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.justify,
              ),

              SizedBox(height: 16),
              Text(
                'Our Story',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'The English to Wancho Translation App is a project born out of passion and dedication. Our team has worked tirelessly to create a platform that is not only functional but also user-friendly and intuitive. We aim to provide accurate and reliable translations, helping to preserve the richness and beauty of the Wancho language.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.justify,
              ),

              SizedBox(height: 16),
              Text(
                'Our Values',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Love: We made this app with love, and we hope you feel it too.\n'
                'Inclusivity: We believe everyone deserves access to communication, regardless of language.\n'
                'Accuracy: We strive to provide the most accurate translations possible.\n'
                'Community: We\'re committed to building a community that celebrates language and culture.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),

              SizedBox(height: 24),
              Divider(thickness: 1, color: Colors.grey[300]),
              SizedBox(height: 16),

              // Donate and Contact Buttons
              Center(
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.monetization_on),
                      label: Text('Donate Us'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _launchURL(donateUrl),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: Icon(Icons.mail),
                      label: Text('Contact the Developers'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _launchURL(contactUrl),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }
}
