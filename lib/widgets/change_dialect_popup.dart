import 'package:flutter/material.dart';

class CustomChangeDialectPopup extends StatelessWidget {
  final String currentDialect;
  final Function(String) onChangeDialect;

  CustomChangeDialectPopup(
      {required this.currentDialect, required this.onChangeDialect});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Dialect'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDialectOption(context, 'UpperWancho'),
          _buildDialectOption(context, 'MiddleWancho'),
          _buildDialectOption(context, 'LowerWancho'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
      ],
    );
  }

  Widget _buildDialectOption(BuildContext context, String dialect) {
    return RadioListTile<String>(
      value: dialect,
      groupValue: currentDialect,
      onChanged: (String? value) {
        if (value != null) {
          onChangeDialect(value);
          Navigator.of(context).pop();
        }
      },
      title: Text(dialect),
      activeColor: Colors.blueAccent,
    );
  }
}
