import 'package:flutter/material.dart';

/// Language selection screen styled to match the provided mock.
/// Returns a `bool` on pop: true = Khmer, false = English.
class LanguageScreen extends StatefulWidget {
  final bool initialIsKhmer;
  const LanguageScreen({Key? key, required this.initialIsKhmer})
    : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late bool _isKhmer;

  @override
  void initState() {
    super.initState();
    _isKhmer = widget.initialIsKhmer;
  }

  void _saveAndClose() {
    Navigator.of(context).pop(_isKhmer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top header: close icon (left) + centered title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.close, size: 24),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Language',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Options with dividers
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Choose your favorite language',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => setState(() => _isKhmer = true),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey.shade300,
                            child: const Text(
                              '🇰🇭',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Khmer',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Radio<bool>(
                            value: true,
                            groupValue: _isKhmer,
                            onChanged: (v) => setState(() => _isKhmer = true),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  GestureDetector(
                    onTap: () => setState(() => _isKhmer = false),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey.shade300,
                            child: const Text(
                              '🇺🇸',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'English',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Radio<bool>(
                            value: false,
                            groupValue: _isKhmer,
                            onChanged: (v) => setState(() => _isKhmer = false),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),

            // Save button at bottom
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _saveAndClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Language',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
