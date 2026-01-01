class Product {
  final int id;
  final String brand;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final double oldPrice;
  final int rating;

  Product({
    required this.id,
    required this.brand,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.oldPrice,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      brand: json['brand'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      price: (json['price'] as num).toDouble(),
      oldPrice: (json['oldPrice'] as num).toDouble(),
      rating: json['rating'],
    );
  }
}
