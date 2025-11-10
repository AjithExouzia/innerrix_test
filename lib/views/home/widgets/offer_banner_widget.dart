import 'package:flutter/material.dart';

class OfferBannerWidget extends StatelessWidget {
  final String title;
  final String description;

  const OfferBannerWidget({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? size.width * 0.03 : 16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTablet ? size.width * 0.03 : 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          SizedBox(height: size.height * 0.008),
          Text(
            description,
            style: TextStyle(
              fontSize: isTablet ? size.width * 0.02 : 14,
              color: Colors.blue[700],
            ),
          ),
        ],
      ),
    );
  }
}
