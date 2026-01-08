import 'package:flutter/material.dart';
import 'language_screen.dart';

class TopSearchBar extends StatelessWidget {
  final String lang;
  final Function(String) onLanguageChanged;
  final VoidCallback? onNotificationTap;
  final String searchText;
  final ValueChanged<String>? onSearchChanged; // ✅ SEARCH CALLBACK

  const TopSearchBar({
    super.key,
    required this.lang,
    required this.onLanguageChanged,
    this.onNotificationTap,
    this.searchText = 'Search',
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 🔍 SEARCH FIELD
        Expanded(
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey.shade400, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    onChanged: onSearchChanged, // ✅ SEND TEXT OUT
                    decoration: InputDecoration(
                      hintText: searchText,
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 15,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        // 🌐 LANGUAGE SWITCH
        GestureDetector(
          onTap: () async {
            final result = await Navigator.of(context).push<bool>(
              MaterialPageRoute(
                builder: (_) => LanguageScreen(initialIsKhmer: lang == 'km'),
              ),
            );
            if (result != null) {
              onLanguageChanged(result ? 'km' : 'en');
            }
          },
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                lang == 'en' ? '🇺🇸' : '🇰🇭',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // 🔔 NOTIFICATION
        GestureDetector(
          onTap: onNotificationTap,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_none,
              color: Colors.black87,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}
