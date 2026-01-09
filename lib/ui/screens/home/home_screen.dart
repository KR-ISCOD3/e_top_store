import 'package:e_top_store/ui/screens/detail/product_detail.dart';
import 'package:e_top_store/ui/widgets/notifications_screen.dart';
import 'package:e_top_store/ui/widgets/top_search_bar.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/language_screen.dart';
import '../../../data/store/favorite_store.dart';
import '../../../data/models/product.dart';
import '../../../data/models/brand.dart';

import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final VoidCallback onOpenCart;

  const HomeScreen({super.key, required this.onOpenCart});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _lang = 'en';
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  final TextEditingController _searchController = TextEditingController();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  // List<Product> _products = [];
  List<Brand> brands = [];

  bool isLoadingBrands = true;
  bool _isLoading = true;

  final List<String> _bannerImages = [
    'assets/images/1.png',
    'assets/images/2.png',
    'assets/images/3.jpg',
  ];

  static const Map<String, Map<String, String>> _translations = {
    'en': {'search': 'Search'},
    'km': {'search': 'ស្វែងរក'},
  };

  String t(String key) => _translations[_lang]?[key] ?? key;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startTimer();
    _loadProducts();
    _loadBrands();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      int nextPage = _currentPage + 1;
      if (nextPage >= _bannerImages.length) {
        nextPage = 0;
      }
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _loadProducts() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:5000/api/laptops'));

      if (response.statusCode == 200) {
        final List list = json.decode(response.body); // ✅ FIX HERE

        setState(() {
          _allProducts = list.map((e) => Product.fromJson(e)).toList();
          _filteredProducts = List.from(_allProducts);
          _isLoading = false;
        });
      } else {
        _isLoading = false;
      }
    } catch (e) {
      debugPrint('Laptop API error: $e');
      _isLoading = false;
    }
  }


  void _applyFilters() {
    final query = _searchController.text.toLowerCase().trim();

    if (query.isEmpty) {
      setState(() {
        _filteredProducts = List.from(_allProducts);
      });
      return;
    }

    setState(() {
      _filteredProducts = _allProducts.where((product) {
        return product.title.toLowerCase().contains(query) ||
            product.brand.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _loadBrands() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/brands'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List jsonList = json.decode(response.body);

        setState(() {
          brands = jsonList.map((e) => Brand.fromJson(e)).toList();
          isLoadingBrands = false;
        });
      } else {
        debugPrint('Failed to load brands: ${response.statusCode}');
        isLoadingBrands = false;
      }
    } catch (e) {
      debugPrint('Brand load error: $e');
      isLoadingBrands = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TopSearchBar(
                  lang: _lang,
                  searchText: 'Search',
                  onLanguageChanged: (value) {
                    setState(() {
                      _lang = value;
                    });
                  },
                  onSearchChanged: (value) {
                    _searchController.text = value;
                    _applyFilters(); // ✅ SEARCH BY NAME WORKS
                  },
                  onNotificationTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const NotificationsScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              _bigBanner(),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _sectionHeader("Popular Brand"),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: _brandList(),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _sectionHeader("Popular Laptop"),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _laptopGrid(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: widget.onOpenCart, // ✅ SWITCH TAB
        child: const Icon(Icons.shopping_cart, color: Colors.white),
      ),
    );
  }

  Widget _bigBanner() {
    return SizedBox(
      height: 180,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _bannerImages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(_bannerImages[index], fit: BoxFit.cover),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_bannerImages.length, (index) {
              return _buildDot(index: index);
            }),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          "See all",
          style: TextStyle(
            color: Colors.red.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 6),
      height: 6,
      width: _currentPage == index ? 24 : 6,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? Colors.red.shade600
            : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _brandLogo(String url) {
    final isSvg = url.toLowerCase().endsWith('.svg');

    return isSvg
        ? SvgPicture.network(
            url,
            height: 40,
            fit: BoxFit.contain,
            placeholderBuilder: (_) =>
                const SizedBox(height: 40, child: CircularProgressIndicator()),
          )
        : Image.network(
            url,
            height: 40,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
          );
  }

  Widget _brandList() {
    if (isLoadingBrands) {
      return const SizedBox(
        height: 90,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final displayBrands = brands.toList();

    return SizedBox(
      height: 60,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 16),
        scrollDirection: Axis.horizontal,
        itemCount: displayBrands.length,
        itemBuilder: (context, index) {
          final brand = displayBrands[index];

          return Container(
            width: 80,
            margin: EdgeInsets.only(
              right: index == displayBrands.length - 1 ? 16 : 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: _brandLogo(brand.image),
                ),
                // const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRatingStars(int? rating) {
    if (rating == null || rating <= 0) {
      return const SizedBox.shrink();
    }

    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: index < rating ? Colors.amber : Colors.grey,
          size: 14,
        ),
      ),
    );
  }

  Widget _laptopGrid() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.68,
      ),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        return _laptopCard(_filteredProducts[index]);
      },
    );
  }

  Widget _laptopCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(
              laptopId: product.id, // 👈 MUST EXIST IN Product model
              onOpenCart: widget.onOpenCart, // ✅ ADD THIS
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= IMAGE =================
            Stack(
              children: [
                Container(
                  height: 130,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          FavoriteStore.toggle(product);
                        });
                      },
                      child: Icon(
                        FavoriteStore.isFavorite(product)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: FavoriteStore.isFavorite(product)
                            ? Colors.red
                            : Colors.black54,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ================= CONTENT =================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // BRAND
                    Text(
                      product.brand,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // TITLE
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        height: 1.3,
                        color: Colors.black87,
                      ),
                    ),

                    // DESCRIPTION
                    Text(
                      product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF777777),
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // ⭐ RATING
                    if (product.rating != null && product.rating! > 0)
                      _buildRatingStars(product.rating),

                    const Spacer(),

                    // PRICE
                    Row(
                      children: [
                        Text(
                          "\$${product.price.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: Colors.red.shade600,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "\$${product.oldPrice.toStringAsFixed(2)}",
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey.shade400,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CambodiaFlag extends StatelessWidget {
  const _CambodiaFlag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CambodiaFlagPainter(),
      size: const Size(double.infinity, double.infinity),
    );
  }
}

class _CambodiaFlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rect = Offset.zero & size;

    final path = Path()..addOval(rect);
    canvas.save();
    canvas.clipPath(path);

    final blue = const Color(0xFF032EA1);
    final red = const Color(0xFFD21F26);

    final topH = h * 0.2;
    final bottomH = h * 0.2;
    final middleH = h - topH - bottomH;

    final paint = Paint();
    paint.color = blue;
    canvas.drawRect(Rect.fromLTWH(0, 0, w, topH), paint);

    paint.color = red;
    canvas.drawRect(Rect.fromLTWH(0, topH, w, middleH), paint);

    paint.color = blue;
    canvas.drawRect(Rect.fromLTWH(0, topH + middleH, w, bottomH), paint);

    final centerX = w / 2;
    final baseY = topH + middleH * 0.6;
    paint.color = Colors.white;

    final baseW = w * 0.36;
    final baseH = h * 0.06;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, baseY),
          width: baseW,
          height: baseH,
        ),
        const Radius.circular(1),
      ),
      paint,
    );

    final towerH = h * 0.12;
    final towerW = baseW * 0.18;
    final gap = baseW * 0.12;

    void drawTower(double offsetX) {
      final px = centerX + offsetX;
      final p1 = Offset(px, baseY - baseH / 2 - towerH);
      final p2 = Offset(px - towerW / 2, baseY - baseH / 2);
      final p3 = Offset(px + towerW / 2, baseY - baseH / 2);
      final towerPath = Path()
        ..moveTo(p1.dx, p1.dy)
        ..lineTo(p2.dx, p2.dy)
        ..lineTo(p3.dx, p3.dy)
        ..close();
      canvas.drawPath(towerPath, paint);
    }

    drawTower(-gap);
    drawTower(0);
    drawTower(gap);

    canvas.restore();

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = Colors.black12;
    canvas.drawOval(rect.deflate(0.5), borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
