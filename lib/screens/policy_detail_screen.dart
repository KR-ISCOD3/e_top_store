import 'package:flutter/material.dart';

enum PolicyType { terms, data }

class PolicyDetailScreen extends StatelessWidget {
  final String title;
  final bool showLastUpdated;
  final PolicyType policyType;

  const PolicyDetailScreen({
    super.key,
    required this.title,
    this.showLastUpdated = false,
    this.policyType = PolicyType.terms,
  });

  Widget _section(String heading, List<String> bullets) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(heading, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...bullets.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4, right: 8),
                    child: Icon(Icons.circle, size: 6),
                  ),
                  Expanded(child: Text(b, style: const TextStyle(height: 1.4))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _termsWidgets() {
    return [
      const SizedBox(height: 6),
      const Text(
        'Terms & Conditions - Laptop Store',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 6),
      const Text(
        'Last updated: 11/25/2025',
        style: TextStyle(color: Colors.grey, fontSize: 12),
      ),
      const SizedBox(height: 12),
      const Text(
        'Welcome to our Laptop Store. By accessing or using our website, mobile app, or purchasing any products from us, you agree to the following Terms & Conditions. Please read them carefully.',
        style: TextStyle(height: 1.5),
      ),
      _section('1. General Use', [
        'By using our services, you confirm that you are at least 18 years old or have permission from a guardian.',
        'You agree to provide accurate information when creating an account or making a purchase.',
        'We reserve the right to update these Terms & Conditions at any time without notice.',
      ]),
      _section('2. Products & Pricing', [
        'All product prices, specifications, and availability may change without notice.',
        'We make every effort to display accurate product information, but errors may occur.',
        'In case of a pricing or listing error, we may cancel or adjust the order and notify you.',
      ]),
      _section('3. Orders & Payments', [
        'An order is considered confirmed only after full payment is received (except COD).',
        'We reserve the right to cancel orders for reasons including payment failure, incorrect pricing, or suspicious activity.',
        'Payments made through our website/app are securely processed through trusted third-party providers.',
      ]),
      _section('4. Shipping & Delivery', [
        'Delivery times shown are estimates and may vary due to external factors.',
        'Once the product is handed to the courier, responsibility for delivery shifts to the courier service.',
        'Customers must provide accurate delivery details. Failed deliveries due to incorrect addresses may incur additional fees.',
      ]),
      const SizedBox(height: 8),
    ];
  }

  List<Widget> _dataPolicyWidgets() {
    Widget _subHeading(String text) => Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );

    Widget _smallHeading(String text) => Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 6),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );

    Widget _bullet(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6, right: 8),
            child: Icon(Icons.circle, size: 6),
          ),
          Expanded(child: Text(text, style: const TextStyle(height: 1.4))),
        ],
      ),
    );

    return [
      const SizedBox(height: 6),
      const Text(
        'Data Policy (Privacy Policy) - Laptop Store',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 6),
      const Text(
        'Last updated: 11/25/2025',
        style: TextStyle(color: Colors.grey, fontSize: 12),
      ),
      const SizedBox(height: 12),
      const Text(
        'Your privacy is important to us. This Data Policy explains how we collect, use, protect, and share your information when you use our website, mobile app, or services.',
        style: TextStyle(height: 1.5),
      ),
      _subHeading('Information We Collect'),
      _smallHeading('a. Personal Information'),
      _bullet(
        'We collect personal details when you create an account or place an order:',
      ),
      _bullet('Name'),
      _bullet('Phone number'),
      _bullet('Email address'),
      _bullet('Delivery address'),
      _bullet('Payment information (processed securely)'),
      _smallHeading('b. Device & Usage Information'),
      _bullet('We automatically collect:'),
      _bullet('IP address'),
      _bullet('Browser type'),
      _bullet('Device type'),
      _bullet('Pages visited'),
      _bullet('App or website usage statistics'),
      _smallHeading('c. Cookies & Tracking'),
      _bullet('We use cookies to:'),
      _bullet('Improve user experience'),
      _bullet('Remember your preferences'),
      _bullet('Analyze website performance'),
      const SizedBox(height: 8),
      const Text('You can disable cookies through your browser settings.'),
      const SizedBox(height: 8),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final widgets = policyType == PolicyType.terms
        ? _termsWidgets()
        : _dataPolicyWidgets();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(title),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets,
          ),
        ),
      ),
    );
  }
}
