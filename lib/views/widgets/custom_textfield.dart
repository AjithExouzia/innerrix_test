import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.isPassword = false,
    this.validator,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: isTablet ? size.width * 0.025 : 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: isTablet ? size.width * 0.025 : 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: EdgeInsets.symmetric(
          horizontal: isTablet ? size.width * 0.03 : 16,
          vertical: isTablet ? size.width * 0.02 : 12,
        ),
      ),
    );
  }
}
