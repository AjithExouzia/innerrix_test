import 'package:test_5/models/product_model.dart';

class HomeData {
  final List<Category> categories;
  final List<Product> featuredProducts;
  final List<Offer> offers;

  HomeData({
    required this.categories,
    required this.featuredProducts,
    required this.offers,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      categories:
          (json['categories'] as List? ?? [])
              .map((category) => Category.fromJson(category))
              .toList(),
      featuredProducts:
          (json['featured_products'] as List? ?? [])
              .map((product) => Product.fromJson(product))
              .toList(),
      offers:
          (json['offers'] as List? ?? [])
              .map((offer) => Offer.fromJson(offer))
              .toList(),
    );
  }
}

class Category {
  final int id;
  final String name;
  final String? image;

  Category({required this.id, required this.name, this.image});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'],
    );
  }
}

class Offer {
  final int id;
  final String title;
  final String description;
  final String? image;

  Offer({
    required this.id,
    required this.title,
    required this.description,
    this.image,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'],
    );
  }
}
