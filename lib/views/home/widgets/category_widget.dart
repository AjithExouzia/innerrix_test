import 'package:flutter/material.dart';
import '../../../models/home_data_model.dart';

class CategoryWidget extends StatelessWidget {
  final Category category;

  const CategoryWidget({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Container(
      width: isTablet ? size.width * 0.15 : 80,
      margin: EdgeInsets.symmetric(
        horizontal: isTablet ? size.width * 0.01 : 4,
      ),
      child: Column(
        children: [
          Container(
            width: isTablet ? size.width * 0.1 : 60,
            height: isTablet ? size.width * 0.1 : 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                category.image != null
                    ? Image.network(category.image!, fit: BoxFit.cover)
                    : Icon(
                      Icons.category,
                      size: isTablet ? size.width * 0.04 : 24,
                      color: Colors.grey[600],
                    ),
          ),
          SizedBox(height: 8),
          Text(
            category.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isTablet ? size.width * 0.02 : 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
