import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget {
  // Method to handle dialect selection
  void _selectDialect(BuildContext context, String dialect) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'selectedDialect', dialect); // Save the selected dialect
    await prefs.setBool('isFirstLaunch', false); // Set first launch to false

    // Navigate to the main dictionary page after selection
    Navigator.of(context).pushReplacementNamed('/dictionary');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome to the VANKO Dictionary!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Please select your preferred dialect to get started:',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _selectDialect(context, 'UpperWancho'),
                child: Text('Upper Wancho'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _selectDialect(context, 'MiddleWancho'),
                child: Text('Middle Wancho'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _selectDialect(context, 'LowerWancho'),
                child: Text('Lower Wancho'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
