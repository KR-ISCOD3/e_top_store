import 'package:e_top_store/data/services/auth_service.dart';
import 'package:e_top_store/ui/screens/checkout/order_status_screen.dart';
import 'package:flutter/material.dart';
import 'select_location_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_top_store/data/services/cart_service.dart';

class CheckoutScreen extends StatefulWidget {
  final double subtotal;
  
  const CheckoutScreen({super.key, required this.subtotal});
  
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _address = 'Select delivery address';
  String _locationType = 'Home';
  double? _lat;
  double? _lng;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const shipping = 0.0;
    final total = widget.subtotal + shipping;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            /// DELIVERY ADDRESS SECTION
            _buildSection(
              title: 'Delivery Address',
              child: GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SelectLocationScreen(),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      _address = result['address'];
                      _lat = result['lat'];
                      _lng = result['lng'];
                      _locationType = result['type'] ?? 'Home';
                    });
                  }
                },
                child: _buildAddressCard(),
              ),
            ),

            const SizedBox(height: 8),

            /// CONTACT PHONE SECTION
            _buildSection(
              title: 'Contact Phone',
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter your phone number',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.normal,
                  ),
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                    color: Colors.grey.shade600,
                    size: 22,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            /// PAYMENT METHOD SECTION
            _buildSection(
              title: 'Payment Method',
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.payments_outlined,
                        color: Colors.grey.shade700,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cash on Delivery',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Pay when you receive',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.check_circle,
                      color: Colors.green.shade600,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            /// ORDER SUMMARY SECTION
            _buildSection(
              title: 'Order Summary',
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow(
                      'Subtotal',
                      '\$${widget.subtotal.toStringAsFixed(2)}',
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryRow(
                      'Delivery Fee',
                      'Free',
                      valueColor: Colors.green.shade600,
                    ),
                    const SizedBox(height: 12),
                    Divider(color: Colors.grey.shade200, height: 1),
                    const SizedBox(height: 12),
                    _buildSummaryRow(
                      'Total',
                      '\$${total.toStringAsFixed(2)}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),

      /// BOTTOM BAR WITH CONFIRM BUTTON
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Payment',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final phone = _phoneController.text.trim();

                    // Phone validation
                    if (phone.isEmpty || phone.length < 8) {
                      _showSnackBar('Please enter a valid phone number');
                      return;
                    }

                    // Location validation
                    if (_lat == null || _lng == null) {
                      _showSnackBar('Please select delivery location');
                      return;
                    }

                    final cartItems = await CartService.getCart();

                    if (cartItems.isEmpty) {
                      _showSnackBar('Cart is empty');
                      return;
                    }

                    final items = cartItems.map((e) => {
                          "laptop_id": e.id,
                          "price": e.price,
                          "quantity": e.quantity,
                        }).toList();

                    // Show loading
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      ),
                    );

                    try {
                      final response = await http.post(
                        Uri.parse('http://10.0.2.2:5000/api/orders/checkout'),
                        headers: {
                          'Content-Type': 'application/json',
                          'Authorization': 'Bearer ${AuthService.token}',
                        },
                        body: jsonEncode({
                          "phone": phone,
                          "address": _address,
                          "lat": _lat,
                          "lng": _lng,
                          "note": "",
                          "items": items,
                        }),
                      );

                      Navigator.pop(context); // Close loading

                      if (response.statusCode == 201) {
                        await CartService.clear();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OrderStatusScreen(),
                          ),
                        );
                      } else {
                        _showSnackBar('Checkout failed: ${response.body}');
                      }
                    } catch (e) {
                      Navigator.pop(context); // Close loading
                      _showSnackBar('Network error: $e');
                    }
                  },
                  child: const Text(
                    'Confirm Order',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildAddressCard() {
    final hasLocation = _lat != null && _lng != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hasLocation ? Colors.grey.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasLocation ? Colors.black.withOpacity(0.1) : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: hasLocation ? Colors.black : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getLocationIcon(),
              color: hasLocation ? Colors.white : Colors.grey.shade600,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasLocation)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _locationType,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  _address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: hasLocation ? Colors.black : Colors.grey.shade600,
                    fontWeight: hasLocation ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.chevron_right,
            color: Colors.grey.shade600,
            size: 20,
          ),
        ],
      ),
    );
  }

  IconData _getLocationIcon() {
    switch (_locationType) {
      case 'Home':
        return Icons.home;
      case 'Office':
        return Icons.work;
      case 'Others':
        return Icons.location_on;
      default:
        return Icons.location_on_outlined;
    }
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? (isTotal ? Colors.black : Colors.black),
          ),
        ),
      ],
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.black,
      ),
    );
  }
}