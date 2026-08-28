import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_font.dart';

// Renders a customizable button that supports outlined, text, or elevated styles.
class CustomButton extends StatelessWidget {
  final String buttonName;
  final String buttonType;
  final Color fontColor;
  final Color? backgroundColor;
  final Color? outlineColor;
  final VoidCallback onPressed;
  final bool isLiked;

  const CustomButton({
    super.key,
    required this.buttonName,
    required this.onPressed,
    this.buttonType = 'elevated',
    this.fontColor = Colors.black,
    this.backgroundColor,
    this.outlineColor,
    this.isLiked = false,
  });

  @override
  Widget build(BuildContext context) {
    // Sets initial background color with fallbacks.
    Color finalBackground =
        backgroundColor ?? const Color.fromARGB(255, 255, 252, 252);

    // Forces white background when liked state is active on a like button.
    if (isLiked && buttonName.toLowerCase() == 'like') {
      finalBackground = Colors.white;
    }

    // Returns outlined button variant when buttonType is outlined.
    if (buttonType.toLowerCase() == 'outlined') {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: outlineColor ?? Colors.black),
          backgroundColor: backgroundColor ?? Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(30),
            vertical: ScreenUtil().setHeight(10),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: CustomFont(
          text: buttonName,
          fontSize: ScreenUtil().setSp(12),
          color: fontColor,
        ),
      );
    }
    // Returns plain text button variant when buttonType is text.
    else if (buttonType.toLowerCase() == 'text') {
      return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(30),
            vertical: ScreenUtil().setHeight(10),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: CustomFont(
          text: buttonName,
          fontSize: ScreenUtil().setSp(12),
          color: fontColor,
        ),
      );
    }
    // Returns default elevated button variant.
    else {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: finalBackground,
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(30),
            vertical: ScreenUtil().setHeight(10),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: CustomFont(
          text: buttonName,
          fontSize: ScreenUtil().setSp(12),
          color: fontColor,
        ),
      );
    }
  }
}
