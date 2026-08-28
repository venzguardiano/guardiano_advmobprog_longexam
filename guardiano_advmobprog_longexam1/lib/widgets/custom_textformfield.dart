import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

// Renders a customizable input text field with password visibility toggle support.
class CustomTextFormField extends StatefulWidget {
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextEditingController controller;
  final bool isPassword;
  final double fontSize;
  final Color fontColor;
  final double height;
  final double width;
  final double hintTextSize;
  final String hintText;
  final Color fillColor;
  final TextInputType keyboardType;
  final int maxLength;

  const CustomTextFormField({
    super.key,
    this.validator,
    this.onSaved,
    required this.controller,
    this.isPassword = false,
    required this.fontSize,
    required this.fontColor,
    this.hintTextSize = 12,
    this.hintText = '',
    this.fillColor = Colors.black12,
    required this.height,
    required this.width,
    this.keyboardType = TextInputType.text,
    this.maxLength = 200,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    // Sets initial password obscure state from widget configuration.
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    // Returns configured text field input widget.
    return TextFormField(
      validator: widget.validator,
      onSaved: widget.onSaved,
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      inputFormatters: [LengthLimitingTextInputFormatter(widget.maxLength)],
      style: TextStyle(fontSize: widget.fontSize, color: widget.fontColor),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(
          widget.width,
          widget.height,
          widget.width,
          widget.height,
        ),
        focusColor: Colors.black12,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: VZ_PRIMARY_DARK, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        errorStyle: const TextStyle(fontFamily: 'Frutiger'),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: VZ_NEON_BLUE, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        filled: true,
        hintStyle: TextStyle(
          color: Colors.black12,
          fontSize: widget.hintTextSize,
          fontFamily: 'Frutiger',
        ),
        hintText: widget.hintText,
        fillColor: widget.fillColor,
        // Renders password visibility toggle icon if isPassword is true.
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: VZ_NEON_BLUE,
                ),
                onPressed: () {
                  // Toggles text obscure state when eye icon is clicked.
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}
