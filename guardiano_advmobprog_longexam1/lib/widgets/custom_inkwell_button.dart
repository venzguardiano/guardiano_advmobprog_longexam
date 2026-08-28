import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/custom_font.dart';

// Renders an interactive card button with ripple effects on tap.
class CustomInkwellButton extends StatelessWidget {
  final VoidCallback onTap;
  final double height;
  final double width;
  final double fontSize;
  final String buttonName;
  final Icon? icon;
  final FontWeight fontWeight;
  final Color bgColor;
  final Color fontColor;

  const CustomInkwellButton({
    super.key,
    required this.onTap,
    required this.height,
    required this.width,
    this.buttonName = '',
    this.bgColor = VZ_CARD_DARK,
    this.fontColor = Colors.white,
    this.fontSize = 14,
    this.icon,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    // Renders elevated card container.
    return Card(
      color: bgColor,
      elevation: 5,
      // Adds touch feedback ripple effect to container.
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        splashColor: VZ_NEON_BLUE,
        child: Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            // Displays icon if buttonName is empty, otherwise displays text.
            child: buttonName.isEmpty
                ? (icon ?? const Icon(Icons.touch_app, color: Colors.white))
                : CustomFont(
                    text: buttonName,
                    fontSize: fontSize,
                    color: fontColor,
                    fontWeight: fontWeight,
                  ),
          ),
        ),
      ),
    );
  }
}
