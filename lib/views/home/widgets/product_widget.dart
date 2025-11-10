import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/product_model.dart';
import '../product_detail_screen.dart';

class ProductWidget extends StatelessWidget {
  final Product product;

  const ProductWidget({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return GestureDetector(
      onTap: () {
        Get.toNamed('/product-detail', arguments: {'productId': product.id});
      },
      child: Card(
        elevation: 2,
        child: Container(
          padding: EdgeInsets.all(isTablet ? size.width * 0.015 : 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                height: isTablet ? size.width * 0.15 : 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    product.image != null
                        ? Image.network(product.image!, fit: BoxFit.cover)
                        : Icon(
                          Icons.shopping_bag,
                          size: isTablet ? size.width * 0.06 : 40,
                          color: Colors.grey[400],
                        ),
              ),

              SizedBox(height: isTablet ? size.width * 0.01 : 8),

              // Product Name
              Text(
                product.name,
                style: TextStyle(
                  fontSize: isTablet ? size.width * 0.02 : 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 4),

              // Product Description
              Text(
                product.description,
                style: TextStyle(
                  fontSize: isTablet ? size.width * 0.015 : 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              Spacer(),

              // Price and Add to Cart
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: isTablet ? size.width * 0.02 : 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(isTablet ? size.width * 0.008 : 4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: isTablet ? size.width * 0.025 : 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
