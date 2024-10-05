import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/welcome/welcome_screen.dart';
import 'screens/main_screen.dart';
import 'widgets/splash.dart'; // Import splash screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VANKO Dictionary',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Set initial screen to SplashScreen
      routes: {
        '/dictionary': (context) => MainScreen(initialIndex: 0),
        '/welcome': (context) => WelcomeScreen(),
        '/update': (context) => MainScreen(initialIndex: 4),
        '/favorites': (context) => MainScreen(initialIndex: 3),
        '/learn_wancho': (context) => MainScreen(initialIndex: 2),
        '/about': (context) => MainScreen(initialIndex: 1),
      },
    );
  }
}

class Initializer extends StatefulWidget {
  @override
  _InitializerState createState() => _InitializerState();
}

class _InitializerState extends State<Initializer> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    bool isFirstLaunch = await _checkFirstLaunch();

    if (isFirstLaunch) {
      Navigator.pushReplacementNamed(context, '/welcome');
    } else {
      Navigator.pushReplacementNamed(context, '/dictionary');
    }
  }

  Future<bool> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      await prefs.setBool('isFirstLaunch', false);
    }

    return isFirstLaunch;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child:
              CircularProgressIndicator()), // Loading indicator while checking
    );
  }
}
