import 'package:flutter/material.dart';
import '../../../data/models/product.dart';

class FavouriteScreen extends StatefulWidget {
  final VoidCallback onBack;

  const FavouriteScreen({super.key, required this.onBack});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<Product> _favorites = [];

  void _removeFavorite(Product product) {
    setState(() {
      _favorites.removeWhere((p) => p.title == product.title);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ===== TOP BAR =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
                    child: const Icon(Icons.close, size: 22),
                  ),
                  const Spacer(),
                  const Text(
                    'Favorite',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  const SizedBox(width: 22),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 0.8),

            // ===== LIST =====
            Expanded(
              child: _favorites.isEmpty
                  ? _emptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _favorites.length,
                      itemBuilder: (context, index) {
                        return _buildFavoriteCard(_favorites[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(Product product) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IMAGE + HEART
              Stack(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const Positioned(
                    top: 0,
                    left: 0,
                    child: Icon(Icons.favorite, color: Colors.red, size: 16),
                  ),
                ],
              ),

              const SizedBox(width: 12),

              // INFO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.brand,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'lorem asdflm asdklc eewipr\ncsd ncds...',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              // PRICE
              Text(
                '\$ ${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Text('No favorites yet', style: TextStyle(color: Colors.grey)),
    );
  }
}
