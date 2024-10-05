import 'package:flutter/material.dart';
import 'dictionary/dictionary_screen.dart';
import 'learn_wancho/learn_wancho_screen.dart';
import 'favorites/favorites_screen.dart';
import 'update/update_screen.dart';
import 'about/about_screen.dart';
import '/services/api_service.dart';
import '/services/database_helper.dart'; // Import your DatabaseHelper

class MainScreen extends StatefulWidget {
  final int initialIndex;

  MainScreen({Key? key, required this.initialIndex}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _isUpdateAvailable = false; // Flag to indicate if an update is available
  List<Widget> _pages = [
    DictionaryScreen(),
    AboutPage(),
    LearnPage(),
    FavoritesScreen(),
    UpdateScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex =
        widget.initialIndex; // Set the initial index from the passed value
    _checkForUpdatesOnInit(); // Check for updates when the app initializes
  }

  Future<void> _checkForUpdatesOnInit() async {
    // Fetch the current version from the database
    String currentVersion = await DatabaseHelper.instance.getCurrentVersion();

    try {
      bool isUpdateAvailable = await ApiService.checkForUpdates(currentVersion);
      setState(() {
        _isUpdateAvailable = isUpdateAvailable;
      });
    } catch (e) {
      // Handle any errors
      print("Error checking for updates: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // If user taps on UpdateScreen, remove the notification badge after viewing
      if (index == 4) {
        _checkForUpdatesOnInit(); // Recheck update status when UpdateScreen is tapped
        _isUpdateAvailable = false; // Reset the update available flag
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Dictionary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.update),
                if (_isUpdateAvailable) // Show red dot if update is available
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Update',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
