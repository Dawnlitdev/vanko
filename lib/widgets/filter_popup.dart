import 'package:flutter/material.dart';

class CustomFilterPopup extends StatelessWidget {
  final Function(String) onFilterSelected;

  CustomFilterPopup({required this.onFilterSelected});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filter Words by Alphabet'),
      content: Container(
        width: double.maxFinite,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // 4 columns to fit alphabets
            childAspectRatio: 2.0,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          shrinkWrap: true,
          itemCount: 26, // A to Z
          itemBuilder: (context, index) {
            String alphabet =
                String.fromCharCode(65 + index); // ASCII values for A-Z
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueAccent, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                onFilterSelected(alphabet);
                Navigator.of(context).pop();
              },
              child: Text(
                alphabet,
                style: TextStyle(fontSize: 18),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Close'),
        ),
      ],
    );
  }
}
