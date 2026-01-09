import '../models/product.dart';

class FavoriteStore {
  static final List<Product> _favorites = [];

  static List<Product> get favorites => _favorites;

  static bool isFavorite(Product product) {
    return _favorites.any((p) => p.id == product.id);
  }

  static void toggle(Product product) {
    if (isFavorite(product)) {
      _favorites.removeWhere((p) => p.id == product.id);
    } else {
      _favorites.add(product);
    }
  }
}
