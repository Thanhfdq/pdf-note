import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final IconData? icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor = const Color.fromARGB(0, 255, 255, 255),
    this.textColor = const Color(0xFF856DFF),
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, color: textColor) : Container(),
    );
  }
}
