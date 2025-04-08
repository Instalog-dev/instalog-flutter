import 'package:flutter/material.dart';

class InstalogButton extends StatelessWidget {
  final String text;
  final bool enabled;
  final EdgeInsetsGeometry? contentPadding;
  final double borderRadius;
  final Color buttonColor;
  final Color textColor;
  final VoidCallback? onClick;

  const InstalogButton({
    super.key,
    this.text = "",
    this.enabled = true,
    this.contentPadding,
    this.borderRadius = 15.0,
    this.buttonColor = Colors.black,
    this.textColor = Colors.white,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onClick : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500, // Equivalent to Medium weight in Compose
          fontSize: 16,
        ),
      ),
    );
  }
}
