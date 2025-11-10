class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final double? discountedPrice;
  final String? image;
  final int categoryId;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountedPrice,
    this.image,
    required this.categoryId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountedPrice: (json['discounted_price'] as num?)?.toDouble(),
      image: json['image'],
      categoryId: json['category_id'] ?? 0,
    );
  }
}
