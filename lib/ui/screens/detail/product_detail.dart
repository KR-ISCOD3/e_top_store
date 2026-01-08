import 'dart:convert';
import 'package:e_top_store/data/models/product.dart';
import 'package:e_top_store/data/services/cart_service.dart';
import 'package:e_top_store/ui/screens/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/cart_item.dart';

class ProductDetailScreen extends StatefulWidget {
  final int laptopId;
  final VoidCallback onOpenCart; // ✅ ADD THIS

  const ProductDetailScreen({
    super.key,
    required this.laptopId,
    required this.onOpenCart,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product? product;
  bool isLoading = true;
  bool isFavorite = false;
  int selectedThumbnail = 0;
  int cartCount = 0;

  @override
  void initState() {
    super.initState();
    fetchProduct();
    loadCartCount();
  }

  Future<void> fetchProduct() async {
    final response = await http.get(
      Uri.parse("http://10.0.2.2:5000/api/laptops/${widget.laptopId}"),
    );

    if (response.statusCode == 200) {
      setState(() {
        product = Product.fromJson(json.decode(response.body));
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadCartCount() async {
    final cart = await CartService.getCart();
    setState(() {
      cartCount = cart.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || product == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Product Detail',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= IMAGE SECTION =================
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Main Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            product!.imageUrl,
                            width: double.infinity,
                            height: 240,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image_not_supported, size: 80),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Thumbnails with Favorite Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Thumbnail 1
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedThumbnail = 0;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: selectedThumbnail == 0
                                        ? Colors.blue
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(
                                    product!.imageUrl,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.image, size: 30),
                                  ),
                                ),
                              ),
                            ),

                            // Thumbnail 2
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedThumbnail = 1;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: selectedThumbnail == 1
                                        ? Colors.blue
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(
                                    product!.imageUrl,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.image, size: 30),
                                  ),
                                ),
                              ),
                            ),

                            const Spacer(),

                            // Favorite Button (Bottom Right)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isFavorite = !isFavorite;
                                });
                              },
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 16,
                                      spreadRadius: 0,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    transitionBuilder: (child, animation) {
                                      return ScaleTransition(
                                        scale: animation,
                                        child: child,
                                      );
                                    },
                                    child: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      key: ValueKey(isFavorite),
                                      color: isFavorite
                                          ? Colors.red
                                          : Colors.grey[600],
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ================= PRODUCT INFO SECTION =================
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rating
                        if (product!.rating != null && product!.rating! > 0)
                          Row(
                            children: [
                              ...List.generate(5, (index) {
                                return Icon(
                                  index < product!.rating!.floor()
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.orange,
                                  size: 18,
                                );
                              }),
                              const SizedBox(width: 8),
                              Text(
                                product!.rating.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        // Price Section
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "US \$${product!.price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 28,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Discounted: US \$${(product!.oldPrice - product!.price).toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    "US \$${product!.oldPrice.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 11,
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ================= PRODUCT DETAILS SECTION =================
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Product Details",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          product!.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Product Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            product!.imageUrl,
                            width: double.infinity,
                            height: 240,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 240,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, size: 60),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ================= BOTTOM BAR =================
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Chat Icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.chat_bubble_outline,
                        size: 24,
                        color: Colors.grey[700],
                      ),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Cart Icon with Badge
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.shopping_cart_outlined,
                            size: 24,
                            color: Colors.grey[700],
                          ),
                          onPressed: () {
                            widget
                                .onOpenCart(); // ✅ tell MainLayout to switch tab
                            Navigator.pop(context); // ✅ close ProductDetail
                          },
                          padding: EdgeInsets.zero,
                        ),
                      ),

                      if (cartCount > 0)
                        Positioned(
                          right: -4,
                          top: -4,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 22,
                              minHeight: 22,
                            ),
                            child: Text(
                              cartCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(width: 12),

                  // Add to Cart Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        await CartService.addToCart(
                          CartItem(
                            id: product!.id,
                            name: product!.title,
                            image: product!.imageUrl,
                            price: product!.price,
                          ),
                        );
                        await loadCartCount();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Added to cart")),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey[800]!, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Add to cart",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Buy Now Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.black,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Buy Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
