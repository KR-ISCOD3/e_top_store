import 'package:flutter/material.dart';
import 'dart:async';
import '../data/models/product.dart';
import 'language_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _lang = 'en';
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  final List<String> _bannerImages = [
    'assets/images/1.png',
    'assets/images/2.png',
    'assets/images/3.jpg',
  ];

  final List<String> _brandImages = [
    'assets/images/1.png',
    'assets/images/2.png',
    'assets/images/3.jpg',
    'assets/images/4.jpg',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              const SizedBox(height: 15),
              _buildSearchBar(),
              const SizedBox(height: 15),
              _bigBanner(),
              const SizedBox(height: 20),
              _sectionHeader("Popular Brand"),
              const SizedBox(height: 10),
              _brandList(),
              const SizedBox(height: 20),
              _sectionHeader("Popular Laptop"),
              const SizedBox(height: 10),
              _laptopGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          "19:02",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Icon(Icons.signal_cellular_alt_rounded, size: 18),
            SizedBox(width: 4),
            Icon(Icons.wifi, size: 18),
            SizedBox(width: 4),
            Icon(Icons.battery_full, size: 20),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.black54, size: 20),
                const SizedBox(width: 8),
                Text(
                  t('search'),
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          // Language selector
          onTap: () async {
            final result = await Navigator.of(context).push<bool>(
              MaterialPageRoute(
                builder: (_) => LanguageScreen(initialIsKhmer: _lang == 'km'),
              ),
            );
            if (result != null) {
              setState(() {
                _lang = result ? 'km' : 'en';
              });
            }
          },
          child: Container(
            child: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.white,
              child: SizedBox(
                width: 24,
                height: 24,
                child: _lang == 'en'
                    ? const Center(
                        child: Text('🇺🇸', style: TextStyle(fontSize: 14)),
                      )
                    : ClipOval(child: _CambodiaFlag()),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.notifications_none, color: Colors.black45),
      ], // Removed the extra comma here
    );
  }

  Widget _bigBanner() {
    return SizedBox(
      height: 200,
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
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(_bannerImages[index], fit: BoxFit.cover),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
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
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Text("See all", style: TextStyle(color: Colors.red)),
      ],
    );
  }

  Widget _buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: _currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.red : Colors.grey,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _brandList() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _brandImages.length,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            margin: EdgeInsets.only(
              right: index == _brandImages.length - 1 ? 0 : 10,
            ),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(_brandImages[index]),
          );
        },
      ),
    );
  }

  Widget _laptopGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.64,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        final product = sampleProducts[index];
        return _laptopCard(product);
      },
    );
  }

  Widget _laptopCard(Product product) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12.0),
                  ),
                  child: Image.asset(product.imageAsset, fit: BoxFit.cover),
                ),
              ),
              const Positioned(
                right: 8,
                top: 8,
                child: Icon(Icons.favorite_border, size: 20),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.brand,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(
                    product.rating,
                    (index) =>
                        const Icon(Icons.star, color: Colors.orange, size: 14),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "\$${product.price.toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
                Text(
                  "\$${product.oldPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDashedLine extends StatelessWidget {
  final double height;
  final Color color;
  const _VerticalDashedLine({
    Key? key,
    this.height = 20,
    this.color = Colors.black26,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1,
      height: height,
      child: CustomPaint(painter: _DashedLinePainter(color: color)),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashHeight = 3.0;
    const dashSpace = 3.0;
    double y = 0;
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(0, y + dashHeight), paint);
      y += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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

    // Clip to circle
    final path = Path()..addOval(rect);
    canvas.save();
    canvas.clipPath(path);

    // Colors similar to Cambodia flag
    final blue = const Color(0xFF032EA1);
    final red = const Color(0xFFD21F26);

    // Draw top blue stripe (approx 20%)
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

    // Draw a simple stylized white Angkor silhouette (approximation)
    final centerX = w / 2;
    final baseY = topH + middleH * 0.6;
    paint.color = Colors.white;

    // base rectangle
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

    // three towers (triangles)
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

    // draw thin border circle
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = Colors.black12;
    canvas.drawOval(rect.deflate(0.5), borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
