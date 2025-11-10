import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return SizedBox(
      width: double.infinity,
      height: isTablet ? size.height * 0.07 : 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child:
            isLoading
                ? SizedBox(
                  height: isTablet ? size.width * 0.03 : 20,
                  width: isTablet ? size.width * 0.03 : 20,
                  child: CircularProgressIndicator(
                    color: textColor,
                    strokeWidth: 2,
                  ),
                )
                : Text(
                  text,
                  style: TextStyle(
                    fontSize: isTablet ? size.width * 0.025 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      ),
    );
  }
}
