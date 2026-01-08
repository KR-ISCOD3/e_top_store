import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_storage.dart';
import 'user_session.dart';

class AuthService {
  // 🔹 OLD LOCAL STATE (KEPT)
  static bool _isLoggedIn = false;

  /// 🔍 GLOBAL LOGIN CHECK (OLD + JWT)
  static bool get isLoggedIn =>
      _isLoggedIn || TokenStorage.isLoggedIn;

  // Android emulator → 10.0.2.2
  static const String baseUrl = 'http://10.0.2.2:5000/api/auth';

  /* =========================
     OLD LOGIN (UI ONLY – KEPT)
     ========================= */
  static Future<void> login() async {
    _isLoggedIn = true;
  }

  /* =========================
     REGISTER (JWT + OLD STATE)
     ========================= */
  static Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);

        _isLoggedIn = true;

        // 🔐 SAVE TOKEN
        TokenStorage.token = data['token'];

        // 👤 SAVE USER
        UserSession.id = data['user']['id'];
        UserSession.name = data['user']['name'];
        UserSession.email = data['user']['email'];
        UserSession.role = data['user']['role'];

        return true;
      }

      print('Register failed: ${response.body}');
      return false;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  /* =========================
     LOGIN WITH API (JWT)
     ========================= */
  static Future<bool> loginWithApi({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        _isLoggedIn = true;

        // 🔐 SAVE TOKEN
        TokenStorage.token = data['token'];

        // 👤 SAVE USER
        UserSession.id = data['user']['id'];
        UserSession.name = data['user']['name'];
        UserSession.email = data['user']['email'];
        UserSession.role = data['user']['role'];

        return true;
      }

      print('Login failed: ${response.body}');
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  /* =========================
     LOGOUT
     ========================= */
  static void logout() {
    _isLoggedIn = false;
    TokenStorage.clear();
    UserSession.clear();
  }

  /* =========================
     TOKEN ACCESS (OPTIONAL)
     ========================= */
  static String? get token => TokenStorage.token;

  /* =========================
     REDIRECT TAB (OPTIONAL)
     ========================= */
  static int? redirectTabIndex;
}
