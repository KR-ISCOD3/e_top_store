import 'package:flutter/material.dart';
import 'add_credit_card_screen.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  int? _selectedIndex;

  final List<Map<String, String>> _cards = [
    {'provider': 'Wing', 'masked': '**** **** **** 5372', 'expires': '03/25'},
    {'provider': 'ACLEDA', 'masked': '**** **** **** 5372', 'expires': '03/25'},
    {'provider': 'ABA', 'masked': '**** **** **** 5372', 'expires': '03/25'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.close, color: Colors.black),
        ),
        title: const Text(
          'Payment Method',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose your favorite payment or add new payment method',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            // Cards list
            Expanded(
              child: ListView.separated(
                itemCount: _cards.length + 1, // card items + current method
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index < _cards.length) {
                    final card = _cards[index];
                    return _buildCardItem(card, index);
                  }

                  // Current Method (Cash Payment) with heading
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
                        child: Text(
                          'Current Method',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade100,
                              ),
                              child: const Icon(
                                Icons.money,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Cash Payment',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Default Method',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Radio<int?>(
                              value: -1,
                              groupValue: _selectedIndex,
                              onChanged: (v) {
                                setState(() {
                                  _selectedIndex = v;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Add Payment button
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    // open add credit card screen
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddCreditCardScreen(),
                      ),
                    );
                    // after returning you might refresh list or show confirmation
                  },
                  child: const Text(
                    'Add Payment Method',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardItem(Map<String, String> card, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // provider logo placeholder
          Container(
            width: 56,
            height: 40,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                card['provider']!,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card['masked']!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  'Expires ${card['expires']}',
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
          Radio<int?>(
            value: index,
            groupValue: _selectedIndex,
            onChanged: (v) {
              setState(() {
                _selectedIndex = v;
              });
            },
          ),
        ],
      ),
    );
  }
}
