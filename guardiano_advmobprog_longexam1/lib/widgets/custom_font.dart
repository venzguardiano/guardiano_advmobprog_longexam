import 'package:flutter/material.dart';

// Renders styled text using uniform custom font parameters.
class CustomFont extends StatelessWidget {
  final String text;
  final double fontSize, letterSpacing;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final String fontFamily;
  final FontStyle fontStyle;

  const CustomFont({
    super.key,
    required this.text,
    required this.fontSize,
    required this.color,
    this.fontFamily = 'Montserrat',
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.left,
    this.letterSpacing = 0,
    this.fontStyle = FontStyle.normal,
  });

  @override
  Widget build(BuildContext context) {
    // Returns a configured Text widget with specified typography styles.
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
