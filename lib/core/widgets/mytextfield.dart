import 'package:flutter/material.dart';

class MyTextformfield extends StatelessWidget {
  const MyTextformfield({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.errorMessage,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
  });

  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String errorMessage;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.red.shade100.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        gradient: LinearGradient(
          colors: [Colors.red.shade50, Colors.red.shade100],
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: Colors.red.shade400)
              : null,
          labelText: labelText,
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        validator:
            validator ??
            (value) {
              if (value == null || value.isEmpty) return errorMessage;
              return null;
            },
      ),
    );
  }
}
