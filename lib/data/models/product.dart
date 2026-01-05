class Product {
  final int id;
  final String brand;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final double oldPrice;
  final int? rating; // 👈 nullable

  Product({
    required this.id,
    required this.brand,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.oldPrice,
    this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final price = double.parse(json['price'].toString());
    final discount = json['discount'] ?? 0;

    return Product(
      id: json['id'],
      brand: json['brand_name'],
      title: json['name'],
      description: json['description'],
      imageUrl: json['thumbnail'],
      price: price,
      oldPrice: discount > 0 ? price + discount : price,
      rating: null, // ❌ backend not ready yet
    );
  }
}
