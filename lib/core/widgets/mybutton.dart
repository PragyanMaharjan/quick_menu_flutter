import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.buttonColor = Colors.redAccent,
    this.textColor = Colors.white,
  });

  final VoidCallback? onPressed;
  final String text;
  final Color buttonColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled ? Colors.grey.shade400 : buttonColor,
          elevation: isDisabled ? 0 : 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
