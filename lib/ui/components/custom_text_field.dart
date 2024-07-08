import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final int readOnly;
  final TextInputType keyboardType;
  final bool obscureText;

  const CustomTextField({super.key,
    required this.controller,
    required this.labelText,
    required this.readOnly,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade600)
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly != 1,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(fontWeight: FontWeight.w300),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
