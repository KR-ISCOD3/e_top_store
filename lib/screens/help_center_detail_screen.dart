import 'package:flutter/material.dart';

class HelpCenterDetailScreen extends StatelessWidget {
  const HelpCenterDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Cancel Order'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How can I cancel my order?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'You can request to cancel your order within 2 hours after placing it.\nTo cancel, go to My Orders -> Select Order -> Cancel Order.',
                style: TextStyle(height: 1.5),
              ),
              const SizedBox(height: 12),
              const Text(
                'Why can\'t I cancel my order after 2 hours?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  '- After 2 hours, your order may already be:\n  • Processed\n  • Packed\n  • Handed over to delivery\nAt this stage, cancellation is no longer possible.',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'What can I do if my order has already shipped?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'If your order has already been shipped, you may still be eligible for:',
              ),
              const SizedBox(height: 6),
              const Text(
                '• Return\n• Exchange\n• Refund (depending on condition and policy)\nPlease check our Return & Refund Policy.',
              ),
              const SizedBox(height: 12),
              const Text(
                'How long does it take to confirm cancellation?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Cancellation requests are reviewed within 1–3 hours. If approved, you will receive a confirmation notification or email.',
              ),
              const SizedBox(height: 12),
              const Text(
                'When will I get my refund?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'If your order was prepaid, the refund will be processed within 3–7 business days, depending on your payment method.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
