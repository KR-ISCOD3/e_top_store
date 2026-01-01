import 'package:e_top_store/data/models/product.dart';
import 'package:e_top_store/ui/widgets/notifications_screen.dart';
import 'package:e_top_store/ui/widgets/top_search_bar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _allProducts = [];
  List<Product> _displayedProducts = [];
  bool _isLoading = true;
  int _selectedCategory = -1;
  final Set<int> _favorites = <int>{};
  String _lang = 'en';

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

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    try {
      final jsonString = await rootBundle.loadString('lib/data/laptops.json');
      final List<dynamic> jsonData = json.decode(jsonString);

      setState(() {
        _allProducts = jsonData.map((e) => Product.fromJson(e)).toList();
        _displayedProducts = List<Product>.from(_allProducts);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Explore JSON load error: $e');
      setState(() => _isLoading = false);
    }
  }

  void _performSearch(String rawQuery) {
    _applyFilters();
  }

  void _applyFilters() {
    final query = _searchController.text.trim().toLowerCase();
    List<Product> results = _allProducts;

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

  void _showSearchFeedback() {
    final query = _searchController.text.trim();
    if (_displayedProducts.isEmpty) {
      String message;
      if (query.isEmpty && _selectedCategory >= 0) {
        message = 'Coming soon';
      } else if (query.isNotEmpty) {
        message = 'No results for "$query"';
      } else {
        message = 'No products available';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopSection(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Best Selling",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Expanded(child: _buildProductList()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      color: const Color(0xFFF8F9FA),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          TopSearchBar(
            lang: _lang,
            searchText: 'Search',
            onLanguageChanged: (value) {
              setState(() {
                _lang = value;
              });
              final label = _lang == 'km' ? 'Khmer' : 'English';
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Language: $label')));
            },
            onNotificationTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
          const SizedBox(height: 20),
          const Text(
            "Model",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          _buildCategoryChips(),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return _buildCategoryChip(_categories[index], index);
        },
      ),
    );
  }

  Widget _buildCategoryChip(String label, int index) {
    final bool selected = _selectedCategory == index;
    return GestureDetector(
      onTap: () {
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
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? const Color(0xFF1A1A1A) : const Color(0xFFE0E0E0),
            width: 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? Colors.white : const Color(0xFF666666),
          ),
        ),
      ),
    );
  }

  Widget _buildProductList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_displayedProducts.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      itemCount: _displayedProducts.length,
      itemBuilder: (context, index) {
        return _buildProductCard(_displayedProducts[index], index);
      },
    );
  }

  Widget _buildEmptyState() {
    final query = _searchController.text.trim();
    String message;

    if (query.isEmpty && _selectedCategory >= 0) {
      message = 'Coming soon';
    } else if (query.isNotEmpty) {
      message = 'No results for "$query"';
    } else {
      message = 'No products available.';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF999999), fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // TODO: Navigate to product detail
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProductImage(product),
                const SizedBox(width: 14),
                Expanded(child: _buildProductInfo(product)),
                _buildFavoriteButton(index),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(Product product) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFFF0F0F0),
              child: Icon(
                Icons.image_not_supported,
                color: Colors.grey[400],
                size: 40,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductInfo(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.brand,
          style: const TextStyle(
            color: Color(0xFF999999),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          product.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
            height: 1.3,
          ),
        ),
        const SizedBox(height: 6),
        _buildRatingStars(product.rating),
        const SizedBox(height: 8),
        _buildPriceRow(product),
      ],
    );
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      children: List.generate(
        5,
        (i) => Icon(
          i < rating ? Icons.star : Icons.star_border,
          color: i < rating ? const Color(0xFFFFB800) : const Color(0xFFE0E0E0),
          size: 14,
        ),
      ),
    );
  }

  Widget _buildPriceRow(Product product) {
    return Row(
      children: [
        Text(
          "\$${product.price.toStringAsFixed(2)}",
          style: const TextStyle(
            color: Color(0xFFFF4444),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          "\$${product.oldPrice.toStringAsFixed(2)}",
          style: const TextStyle(
            decoration: TextDecoration.lineThrough,
            color: Color(0xFFBBBBBB),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteButton(int index) {
    return IconButton(
      icon: Icon(
        _favorites.contains(index) ? Icons.favorite : Icons.favorite_border,
        color: _favorites.contains(index)
            ? const Color(0xFFFF4444)
            : const Color(0xFFCCCCCC),
        size: 22,
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
    );
  }
}
