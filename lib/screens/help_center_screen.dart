import 'package:flutter/material.dart';
import 'help_center_detail_screen.dart';
import 'ai_assistant_screen.dart';
import 'payment_and_refunds_screen.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'title': 'Can I cancel or change my order?',
        'type': 'cancel',
        'icon': Icons.shopping_bag_outlined,
      },
      {
        'title': 'Can you help me choose a laptop?',
        'type': 'ai',
        'icon': Icons.lightbulb_outline,
      },
      {
        'title': 'Payment and Refunds',
        'type': 'payment',
        'icon': Icons.payment,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Help Center'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'How can we help?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final it = items[index];
                  return ListTile(
                    leading: Icon(it['icon'] as IconData, size: 24),
                    title: Text(it['title'] as String),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      switch (it['type']) {
                        case 'cancel':
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const HelpCenterDetailScreen(),
                            ),
                          );
                          break;
                        case 'ai':
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AiAssistantScreen(),
                            ),
                          );
                          break;
                        case 'payment':
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const PaymentAndRefundsScreen(),
                            ),
                          );
                          break;
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
