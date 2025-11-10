import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_5/views/home/widgets/offer_banner_widget.dart';
import '../../controllers/home_controller.dart';
import '../widgets/loading_widget.dart';
import 'widgets/category_widget.dart';
import 'widgets/product_widget.dart';

class HomeScreen extends StatelessWidget {
  final HomeController _homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final crossAxisCount = isTablet ? 4 : 2;
    final categoryHeight = isTablet ? size.height * 0.15 : 100.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HI, Shammas',
          style: TextStyle(fontSize: isTablet ? size.width * 0.035 : 20),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
            iconSize: isTablet ? size.width * 0.04 : 24,
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
            iconSize: isTablet ? size.width * 0.04 : 24,
          ),
        ],
      ),
      body: Obx(() {
        if (_homeController.isLoading.value) {
          return LoadingWidget();
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(isTablet ? size.width * 0.03 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(size, isTablet),
              SizedBox(height: size.height * 0.02),

              OfferBannerWidget(
                title: 'Onam Special Exclusive Offer',
                description:
                    'The only online and efficient onam service depends on the price of all goods.',
              ),

              SizedBox(height: size.height * 0.03),

              _buildCategoriesSection(size, isTablet, categoryHeight),

              SizedBox(height: size.height * 0.03),

              _buildProductsSection(size, isTablet, crossAxisCount),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSearchBar(Size size, bool isTablet) {
    return Container(
      height: isTablet ? size.height * 0.07 : 50,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(fontSize: isTablet ? size.width * 0.025 : 16),
          prefixIcon: Icon(
            Icons.search,
            size: isTablet ? size.width * 0.04 : 24,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: isTablet ? size.width * 0.03 : 16,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(
    Size size,
    bool isTablet,
    double categoryHeight,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: TextStyle(
            fontSize: isTablet ? size.width * 0.04 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: size.height * 0.015),
        SizedBox(
          height: categoryHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _homeController.homeData.value.categories.length,
            itemBuilder: (context, index) {
              final category = _homeController.homeData.value.categories[index];
              return Container(
                margin: EdgeInsets.only(
                  right: isTablet ? size.width * 0.02 : 12,
                ),
                child: CategoryWidget(category: category),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductsSection(Size size, bool isTablet, int crossAxisCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Products',
          style: TextStyle(
            fontSize: isTablet ? size.width * 0.04 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: size.height * 0.015),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: isTablet ? size.width * 0.02 : 10,
            mainAxisSpacing: isTablet ? size.width * 0.02 : 10,
            childAspectRatio: isTablet ? 0.8 : 0.7,
          ),
          itemCount: _homeController.products.length,
          itemBuilder: (context, index) {
            final product = _homeController.products[index];
            return ProductWidget(product: product);
          },
        ),
      ],
    );
  }
}
