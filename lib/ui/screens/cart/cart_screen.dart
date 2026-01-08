import 'package:flutter/material.dart';
import '../../../data/models/cart_item.dart';
import '../../../data/services/cart_service.dart';
import 'package:e_top_store/data/services/auth_service.dart';
import '../auth/login_screen.dart';

class CartScreen extends StatefulWidget {
  final VoidCallback onBack;

  const CartScreen({super.key, required this.onBack});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cart = [];

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    cart = await CartService.getCart();
    setState(() {});
  }

  double get subTotal => cart.fold(0, (sum, e) => sum + e.price * e.quantity);
  double get shipping => cart.isEmpty ? 0 : 10;
  double get total => subTotal + shipping;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: widget.onBack, // ✅ CORRECT BACK
        ),
        title: const Text(
          'Cart List',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.chat_bubble_outline, color: Colors.black),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Divider(height: 1, thickness: 0.8),

            // ===== CART ITEMS =====
            Expanded(
              child: cart.isEmpty
                  ? const Center(child: Text("Your cart is empty"))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: cart.length,
                      itemBuilder: (context, index) {
                        return _CartItem(
                          item: cart[index],
                          onQtyChanged: (qty) async {
                            await CartService.updateQuantity(
                              cart[index].id,
                              qty,
                            );
                            loadCart();
                          },
                          onDelete: () async {
                            await CartService.removeItem(cart[index].id);
                            loadCart();
                          },
                        );
                      },
                    ),
            ),

            // ===== SUMMARY =====
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _SummaryRow(
                    label: 'Sub Total',
                    value: '\$${subTotal.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 6),
                  _SummaryRow(
                    label: 'Shipping',
                    value: '\$${shipping.toStringAsFixed(2)}',
                  ),
                  const Divider(height: 24),
                  _SummaryRow(
                    label: 'Total Amount',
                    value: '\$${total.toStringAsFixed(2)}',
                    bold: true,
                  ),
                  const SizedBox(height: 16),
                  const _CheckoutButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= CART ITEM ================= */

class _CartItem extends StatelessWidget {
  final CartItem item;
  final Function(int qty) onQtyChanged;
  final VoidCallback onDelete;

  const _CartItem({
    required this.item,
    required this.onQtyChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.network(
              item.image,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.laptop, size: 40, color: Colors.grey),
            ),
          ),

          const SizedBox(width: 12),

          // INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'ASUS',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),

          // ACTIONS
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 🗑 DELETE
              GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.red,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // QTY
              Row(
                children: [
                  _QtyButton(
                    icon: Icons.remove,
                    onTap: item.quantity > 1
                        ? () => onQtyChanged(item.quantity - 1)
                        : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      item.quantity.toString(),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  _QtyButton(
                    icon: Icons.add,
                    onTap: () => onQtyChanged(item.quantity + 1),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QtyButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: bold ? Colors.black : Colors.grey,
            fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _CheckoutButton extends StatelessWidget {
  const _CheckoutButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () async {
          // 🔐 CHECK LOGIN
          if (!AuthService.isLoggedIn) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginScreen(),
              ),
            );

            // after login → recheck
            if (!AuthService.isLoggedIn) return;
          }

          // ✅ USER LOGGED IN → CONTINUE CHECKOUT
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Proceed to checkout 🚀"),
            ),
          );

          // TODO: Navigate to checkout screen
          // Navigator.push(context,
          //   MaterialPageRoute(builder: (_) => const CheckoutScreen()));
        },
        child: const Text(
          'Check Out',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

