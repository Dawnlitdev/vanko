import 'package:flutter/material.dart';
import '/services/api_service.dart';
import '/services/database_helper.dart';

class UpdateScreen extends StatefulWidget {
  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen>
    with SingleTickerProviderStateMixin {
  String _currentVersion = "1.0"; // Example version
  bool _isUpdating = false;
  bool _isUpdateAvailable = false; // Track if an update is available
  String _updateStatus = "";
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _getCurrentVersion();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Method to get the current version from the local database
  void _getCurrentVersion() async {
    // Fetch the current version from the database
    String version = await DatabaseHelper.instance.getCurrentVersion();
    setState(() {
      _currentVersion = version;
    });
  }

  // Method to check for updates
  Future<void> _checkForUpdates() async {
    setState(() {
      _isUpdating = true;
      _updateStatus = "Checking for updates...";
    });

    try {
      bool isUpdateAvailable =
          await ApiService.checkForUpdates(_currentVersion);
      if (isUpdateAvailable) {
        setState(() {
          _isUpdateAvailable = true;
          _updateStatus = "Update to new version available!";
        });
        _animationController.forward(from: 0); // Start fade animation
      } else {
        setState(() {
          _isUpdateAvailable = false;
          _updateStatus = "Already updated to the latest version.";
        });
        _animationController.forward(from: 0); // Start fade animation
      }
    } catch (e) {
      setState(() {
        _updateStatus = "Error checking for updates: $e";
      });
      _animationController.forward(from: 0); // Start fade animation
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  // Method to apply updates to the local database with a warning
  Future<void> _applyUpdate() async {
    // Show a warning dialog before applying the update
    bool confirmUpdate = await _showUpdateWarningDialog();
    if (!confirmUpdate) return; // If the user cancels, do not proceed

    setState(() {
      _updateStatus = "Applying updates...";
    });

    try {
      await ApiService.fetchAndApplyUpdates();
      _getCurrentVersion(); // Refresh the current version after update
      setState(() {
        _updateStatus = "Update applied successfully!";
        _isUpdateAvailable = false; // Reset update flag after successful update
      });
      _animationController.forward(from: 0); // Start fade animation
    } catch (e) {
      setState(() {
        _updateStatus = "Error applying updates: $e";
      });
      _animationController.forward(from: 0); // Start fade animation
    }
  }

  // Method to show a warning dialog before applying the update
  Future<bool> _showUpdateWarningDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Warning'),
              content: Text(
                  'Applying this update will remove all your favorite words. Do you want to continue?'),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Return false if cancelled
                  },
                ),
                ElevatedButton(
                  child: Text('Continue'),
                  onPressed: () {
                    Navigator.of(context).pop(true); // Return true if confirmed
                  },
                ),
              ],
            );
          },
        ) ??
        false; // Return false if dialog is dismissed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Dictionary Data',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Current Version: $_currentVersion',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 20),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        _updateStatus,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            _isUpdateAvailable
                ? ElevatedButton(
                    onPressed: _isUpdating ? null : _applyUpdate,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isUpdating
                        ? const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.0,
                              ),
                              SizedBox(width: 12),
                              Text('Applying...'),
                            ],
                          )
                        : Text('Update Now'),
                  )
                : ElevatedButton(
                    onPressed: _isUpdating ? null : _checkForUpdates,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isUpdating
                        ? const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.0,
                              ),
                              SizedBox(width: 12),
                              Text('Checking...'),
                            ],
                          )
                        : Text('Check for Updates'),
                  ),
          ],
        ),
      ),
    );
  }
}
