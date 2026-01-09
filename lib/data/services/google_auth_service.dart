import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';
import 'token_storage.dart';
import 'user_session.dart';

class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email', 'profile'],
  serverClientId:'827259358924-hbpcejiqe14fqq0uu810ol56clars48s.apps.googleusercontent.com', // 👈 WEB CLIENT ID
);

  static Future<bool> signInWithGoogle() async {
    try {
      // 1️⃣ Pick Google account
      final GoogleSignInAccount? account =
          await _googleSignIn.signIn();

      if (account == null) return false;

      // 2️⃣ Get Google ID token
      final GoogleSignInAuthentication auth =
          await account.authentication;

      final String? idToken = auth.idToken;

      if (idToken == null) {
        debugPrint("❌ Google ID token is null");
        return false;
      }

      debugPrint("🔥 GOOGLE ID TOKEN OK");

      // 3️⃣ Send token to backend
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // 🔐 SAVE JWT
        TokenStorage.token = data['token'];

        // 👤 SAVE USER (OPTIONAL BUT RECOMMENDED)
        UserSession.id = data['user']['id'];
        UserSession.name = data['user']['name'];
        UserSession.email = data['user']['email'];
        UserSession.role = data['user']['role'];

        // ✅ LOGIN STATE
        AuthService.login();

        debugPrint("✅ GOOGLE LOGIN SUCCESS");
        return true;
      }

      debugPrint("❌ Backend error: ${response.body}");
      return false;
    } catch (e) {
      debugPrint("❌ Google Sign-In error: $e");
      return false;
    }
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    AuthService.logout();
  }
}
