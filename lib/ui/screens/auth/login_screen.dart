import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                /// 🔹 Title
                const Text(
                  "Login Here",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Welcome back you've been missed",
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 32),

                /// 🔹 Email
                _inputField("Email"),
                const SizedBox(height: 16),

                /// 🔹 Password
                _inputField("Password", obscure: true),

                const SizedBox(height: 8),

                /// 🔹 Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot your password?",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔹 Sign in button
                _primaryButton(
                  text: "Sign in",
                  onTap: () {
                    AuthService.isLoggedIn = true;
                    Navigator.pop(context);
                  },
                ),

                const SizedBox(height: 24),

                /// 🔹 Create account
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/register");
                    },
                    child: const Text("Create new account"),
                  ),
                ),

                const SizedBox(height: 32),

                /// 🔹 Divider
                const Center(child: Text("Or continue with")),
                const SizedBox(height: 16),

                /// 🔹 Social login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton(Icons.g_mobiledata, Colors.red),
                    const SizedBox(width: 20),
                    _socialButton(Icons.facebook, Colors.blue),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Input Field
  Widget _inputField(String hint, {bool obscure = false}) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// 🔹 Primary Button
  Widget _primaryButton({required String text, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onTap,
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  /// 🔹 Social Button
  Widget _socialButton(IconData icon, Color color) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: Colors.grey.shade200,
      child: Icon(icon, color: color, size: 28),
    );
  }
}
