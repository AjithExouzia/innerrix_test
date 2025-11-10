import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';

class ProductDetailScreen extends StatelessWidget {
  final int productId;
  final ProductController _productController = Get.put(ProductController());

  ProductDetailScreen({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      appBar: AppBar(title: Text('Product Details')),
      body: Obx(() {
        if (_productController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final product = _productController.product.value;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isTablet ? size.width * 0.04 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                width: double.infinity,
                height: isTablet ? size.height * 0.4 : 300,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    product.image != null
                        ? Image.network(product.image!, fit: BoxFit.cover)
                        : Icon(
                          Icons.shopping_bag,
                          size: isTablet ? size.width * 0.1 : 60,
                          color: Colors.grey[400],
                        ),
              ),

              SizedBox(height: size.height * 0.03),

              // Product Name
              Text(
                product.name,
                style: TextStyle(
                  fontSize: isTablet ? size.width * 0.04 : 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: size.height * 0.01),

              // Product Description
              Text(
                product.description,
                style: TextStyle(
                  fontSize: isTablet ? size.width * 0.025 : 16,
                  color: Colors.grey[600],
                ),
              ),

              SizedBox(height: size.height * 0.02),

              // Price
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: isTablet ? size.width * 0.035 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),

              SizedBox(height: size.height * 0.03),

              // Add to Cart Button
              SizedBox(
                width: double.infinity,
                height: isTablet ? size.height * 0.07 : 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Add to cart functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontSize: isTablet ? size.width * 0.025 : 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  void initState() {
    _productController.loadProductDetail(productId);
  }
}
