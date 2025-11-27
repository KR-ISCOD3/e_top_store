/// Product model (data structure) to represent 1 product item.
class Product {
  final String brand;
  final String title;
  final String description;
  final double price;
  final double oldPrice;
  final int rating;
  final String imageAsset;

  /// Constructor to create product object.
  Product({
    required this.brand,
    required this.title,
    required this.description,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.imageAsset,
  });
}

///   STATIC LIST of sample products (array)
/// These will be displayed in Explore screen using liveView.
final List<Product> sampleProducts = [
  Product(
    brand: "Asus",
    title: "ASUS ROG Gaming Laptop",
    description:
        "High-performance gaming laptop with AMD Ryzen processor, RTX graphics, and RGB keyboard for the ultimate gaming experience.",
    price: 1299.99,
    oldPrice: 1599.99,
    rating: 5,
    imageAsset: "assets/images/1.png",
  ),

  Product(
    brand: "Dell",
    title: "Dell XPS 13 Ultrabook",
    description:
        "Premium ultrabook with Intel Core i7, 16GB RAM, and 512GB SSD. Perfect for professionals and students.",
    price: 899.99,
    oldPrice: 1199.99,
    rating: 4,
    imageAsset: "assets/images/2.png",
  ),

  Product(
    brand: "MacBook",
    title: "MacBook Air M2",
    description:
        "Supercharged by M2 chip, 13.6-inch Liquid Retina display, up to 18 hours of battery life. Perfect for creative work.",
    price: 1199.99,
    oldPrice: 1399.99,
    rating: 5,
    imageAsset: "assets/images/3.jpg",
  ),

  Product(
    brand: "HP",
    title: "HP Pavilion 15",
    description:
        "Versatile laptop with AMD Ryzen 7, 15.6-inch Full HD display, ideal for work, study, and entertainment.",
    price: 749.99,
    oldPrice: 899.99,
    rating: 4,
    imageAsset: "assets/images/4.jpg",
  ),
];
