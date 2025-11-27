import 'package:flutter/material.dart';
import 'policy_detail_screen.dart';

class TermsAndPoliciesScreen extends StatelessWidget {
  const TermsAndPoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'title': 'Terms And Conditions', 'type': 'terms'},
      {'title': 'Data Policy', 'type': 'data'},
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Terms And Policies'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final it = items[index];
          return ListTile(
            title: Text(it['title'] as String),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              if (it['type'] == 'terms') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PolicyDetailScreen(
                      title: 'Terms & Conditions',
                      showLastUpdated: true,
                      policyType: PolicyType.terms,
                    ),
                  ),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PolicyDetailScreen(
                      title: 'Data Policy',
                      showLastUpdated: true,
                      policyType: PolicyType.data,
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
