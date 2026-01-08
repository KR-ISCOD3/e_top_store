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
    final price = double.tryParse(json['price']?.toString() ?? '0') ?? 0;
    final discount = double.tryParse(json['discount']?.toString() ?? '0') ?? 0;

    return Product(
      id: json['id'] ?? 0,
      brand: json['brand_name'] ?? 'Unknown', // ✅ FIX
      title: json['name'] ?? '', // ✅ FIX
      description: json['description'] ?? '', // ✅ FIX
      imageUrl: json['thumbnail'] ?? '', // ✅ FIX
      price: price,
      oldPrice: discount > 0 ? price + discount : price,
      rating: null,
    );
  }
}
