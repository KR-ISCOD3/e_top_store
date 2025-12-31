import 'package:flutter/material.dart';

class PaymentAndRefundsScreen extends StatelessWidget {
  const PaymentAndRefundsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final methods = [
      'Visa / MasterCard',
      'ABA Pay',
      'ACLEDA Mobile',
      'WingPay',
      'Bank Transfer',
      'Cash on Delivery (COD) (Phnom Penh only)',
      'Store Payment (Pay directly at our shop)',
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Payment and Refunds'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'We offer multiple secure payment options to make your shopping experience easy:',
                style: TextStyle(height: 1.4),
              ),
              const SizedBox(height: 12),
              const Text(
                'Available Payment Methods',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...methods.map(
                (m) => Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 6, right: 8),
                        child: Icon(Icons.circle, size: 6),
                      ),
                      Expanded(
                        child: Text(m, style: const TextStyle(height: 1.4)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your payment information is encrypted and protected.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
