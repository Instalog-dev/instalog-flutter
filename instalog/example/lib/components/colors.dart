import 'package:flutter/material.dart';

class InstalogColors {
  static const grey = Color(0xFFF4F4F4);
  static const hintGrey = Color(0xFFBFBFC1);
  static const textGrey = Color(0xFF4B4B4B);
  static const purple = Color(0xFF5756D5);
  static const red = Color(0xFFFF3B30);
  static const black = Color(0xFF000000);
  static const green = Color(0xFF35C759);
  static const orange = Color(0xFFFF9500);

  static InputDecoration get textFieldDecoration => InputDecoration(
        filled: true,
        fillColor: grey, // Background for text field
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(8.0), // Adjust if needed
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(8.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(8.0),
        ),
        hintStyle: const TextStyle(color: hintGrey),
      );
}
