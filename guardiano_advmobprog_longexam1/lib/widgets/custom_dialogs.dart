import 'package:flutter/material.dart';
import '../constants.dart';

// Displays a standard alert dialog box with a title, message content, and dismiss button.
void customDialogs(
  BuildContext context, {
  required String title,
  required String content,
}) {
  // Configures alert dialog layout and dismiss button.
  AlertDialog alertDialog = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: <Widget>[
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: VZ_CARD_DARK,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          // Closes the open dialog.
          Navigator.of(context).pop();
        },
        child: const Text('Okay'),
      ),
    ],
  );

  // Renders the alert dialog on screen.
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alertDialog;
    },
  );
}
