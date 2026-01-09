import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';

class CartService {
  static const String _cartKey = 'cart_items';

  // Get cart
  static Future<List<CartItem>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_cartKey);

    if (data == null) return [];

    final List list = json.decode(data);
    return list.map((e) => CartItem.fromJson(e)).toList();
  }

  // Add to cart
  static Future<void> addToCart(CartItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final cart = await getCart();

    final index = cart.indexWhere((e) => e.id == item.id);

    if (index >= 0) {
      cart[index].quantity++;
    } else {
      cart.add(item);
    }

    prefs.setString(
      _cartKey,
      json.encode(cart.map((e) => e.toJson()).toList()),
    );
  }

  // Update quantity
  static Future<void> updateQuantity(int id, int qty) async {
    final prefs = await SharedPreferences.getInstance();
    final cart = await getCart();

    final index = cart.indexWhere((e) => e.id == id);
    if (index >= 0) {
      cart[index].quantity = qty;
    }

    prefs.setString(
      _cartKey,
      json.encode(cart.map((e) => e.toJson()).toList()),
    );
  }

  // Remove item
  static Future<void> removeItem(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final cart = await getCart();

    cart.removeWhere((e) => e.id == id);

    prefs.setString(
      _cartKey,
      json.encode(cart.map((e) => e.toJson()).toList()),
    );
  }

  // Clear cart
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }
}
