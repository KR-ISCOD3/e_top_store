import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';

class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  static Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account =
          await _googleSignIn.signIn();

      if (account == null) {
        return false;
      }

      final GoogleSignInAuthentication auth =
          await account.authentication;

      final String? idToken = auth.idToken;

      // 🔴 ADD THIS LINE
      debugPrint("ID TOKEN: $idToken");

      if (idToken == null) {
        debugPrint("Google ID token is null");
        return false;
      }

      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      if (response.statusCode == 200) {
        AuthService.login();
        return true;
      }

      debugPrint('Backend error: ${response.body}');
      return false;
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      return false;
    }
  }


  static Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

}
