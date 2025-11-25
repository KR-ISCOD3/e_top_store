import 'package:flutter/material.dart';
import '../data/models/product.dart';
import '../screens/notifications_screen.dart';
import '../screens/language_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _displayedProducts = [];
  final List<String> _categories = [
    'Asus',
    'MSI',
    'ROG',
    'Lenovo',
    'HP',
    'Dell',
    'Apple',
    'Acer',
    'Google',
    'Razer',
  ];
  int _selectedCategory = -1; // -1 means no category selected
  final Set<int> _favorites = <int>{};
  // Language state: false = English (US), true = Khmer
  bool _isKhmer = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // start with full list
    _displayedProducts = List<Product>.from(sampleProducts);
  }

  void _performSearch(String rawQuery) {
    // Re-apply filters using current search text + category selection.
    _applyFilters();
  }

  /// Apply category + search filters and update displayed products.
  void _applyFilters() {
    final query = _searchController.text.trim().toLowerCase();
    List<Product> results = sampleProducts;

    if (_selectedCategory >= 0 && _selectedCategory < _categories.length) {
      final label = _categories[_selectedCategory].toLowerCase();
      results = results
          .where((p) => p.brand.toLowerCase().contains(label))
          .toList();
    }

    if (query.isNotEmpty) {
      results = results.where((p) {
        return p.title.toLowerCase().contains(query) ||
            p.brand.toLowerCase().contains(query) ||
            p.description.toLowerCase().contains(query);
      }).toList();
    }

    setState(() {
      _displayedProducts = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the page structure.
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          //outer padding to match screenshot spacing
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Search bar row (search field + notification circle) ---
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration.collapsed(
                                hintText: "Search",
                              ),
                              onChanged: (value) => _performSearch(value),
                              onSubmitted: (value) {
                                _performSearch(value);
                                // decide polite feedback based on filters
                                final query = _searchController.text.trim();
                                if (_displayedProducts.isEmpty) {
                                  if (query.isEmpty && _selectedCategory >= 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Coming soon'),
                                      ),
                                    );
                                  } else if (query.isNotEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'No results for "${query}"',
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('No products available'),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Language selector (opens language picker page).
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                          builder: (_) =>
                              LanguageScreen(initialIsKhmer: _isKhmer),
                        ),
                      );
                      if (result != null) {
                        setState(() => _isKhmer = result);
                        final label = _isKhmer ? 'Khmer' : 'English';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Language: $label')),
                        );
                      }
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Semantics(
                          label: _isKhmer ? 'Khmer' : 'English',
                          child: Text(
                            _isKhmer ? '🇰🇭' : '🇺🇸',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Notification (round) tappable
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const NotificationsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.notifications_none),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // --- Model label ---
              const Text(
                "Model",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10),

              // --- Horizontal chips ---
              SizedBox(
                height: 45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, idx) => _chip(_categories[idx], idx),
                ),
              ),

              const SizedBox(height: 20),

              // --- Best Selling label ---
              const Text(
                "Best Selling",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              // --- Product list (scrollable) ---
              Expanded(
                child: _displayedProducts.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Builder(
                            builder: (context) {
                              final query = _searchController.text.trim();
                              String message;
                              if (query.isEmpty && _selectedCategory >= 0) {
                                message = 'Coming soon';
                              } else if (query.isNotEmpty) {
                                message = 'No results for "${query}"';
                              } else {
                                message = 'No products available.';
                              }
                              return Text(
                                message,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _displayedProducts.length,
                        itemBuilder: (context, index) {
                          final item = _displayedProducts[index];
                          return _productCard(
                            context,
                            index: index,
                            product: item,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Chip widget for horizontal scrolling categories
  Widget _chip(String label, int index) {
    final bool selected = _selectedCategory == index;
    return GestureDetector(
      onTap: () {
        // toggle selection: tapping the active chip clears it
        setState(() {
          if (_selectedCategory == index) {
            _selectedCategory = -1;
          } else {
            _selectedCategory = index;
          }
        });
        _applyFilters();
        final message = _selectedCategory == -1
            ? 'Category cleared'
            : 'Selected category: $label';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8, top: 6, bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? const Color.fromARGB(255, 0, 0, 0)
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: selected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  /// Product card layout matching the screenshot:
  /// left image, center text column, right small heart icon.
  Widget _productCard(
    BuildContext context, {
    required int index,
    required Product product,
  }) {
    final brand = product.brand;
    final title = product.title;
    final desc = product.description;
    final price = product.price;
    final oldPrice = product.oldPrice;
    final rating = product.rating;
    final imageAsset = product.imageAsset;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // image (left) - center image inside the square and avoid cropping
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 110,
                height: 110,
                color: Colors.transparent,
                child: Center(
                  child: Image.asset(
                    imageAsset,
                    width: 110,
                    height: 110,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 110,
                        height: 110,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // center column text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brand,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: List.generate(
                      rating,
                      (i) => const Padding(
                        padding: EdgeInsets.only(right: 4.0),
                        child: Icon(Icons.star, color: Colors.orange, size: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        "\$${price.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "\$${oldPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // heart icon on the right
            IconButton(
              icon: Icon(
                _favorites.contains(index)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: _favorites.contains(index) ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  if (_favorites.contains(index)) {
                    _favorites.remove(index);
                  } else {
                    _favorites.add(index);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple detail page for a product
class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                product.imageAsset,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey.shade200,
                  child: const Center(child: Icon(Icons.image_not_supported)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(product.brand, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 6),
            Text(
              product.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(product.description),
            const SizedBox(height: 12),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
