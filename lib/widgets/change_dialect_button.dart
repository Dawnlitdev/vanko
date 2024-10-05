import 'package:flutter/material.dart';

class ChangeDialectButton extends StatelessWidget {
  final String selectedDialect;
  final VoidCallback onPressed;

  ChangeDialectButton({required this.selectedDialect, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 90, 13, 36), // Text color
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10), // Less rounded corners for compactness
        ),
        padding: EdgeInsets.symmetric(
            vertical: 8, horizontal: 12), // Reduced padding
        elevation: 2, // Less elevation for a flatter look
      ),
      icon: Icon(Icons.language, size: 18), // Smaller icon size
      label: Text(
        'Dialect: $selectedDialect',
        style: TextStyle(fontSize: 14), // Smaller text size
      ),
      onPressed: onPressed,
    );
  }
}
