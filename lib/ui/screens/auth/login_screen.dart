import 'package:e_top_store/data/services/auth_service.dart';
import 'package:e_top_store/data/services/google_auth_service.dart';
import 'package:e_top_store/ui/screens/auth/signup_screen.dart';
import 'package:e_top_store/ui/screens/main/main_layout.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 🔹 Controllers
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Welcome back you've been missed!",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 60),

                /// 🔹 Email
                _inputField("Email", controller: emailCtrl),
                const SizedBox(height: 20),

                /// 🔹 Password
                _inputField(
                  "Password",
                  controller: passwordCtrl,
                  obscure: true,
                ),

                const SizedBox(height: 12),

                /// 🔹 Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot your password?",
                      style: TextStyle(
                        color: Color(0xFF1E90FF),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// 🔹 Sign in button
                _primaryButton(
                  text: _loading ? "Signing in..." : "Sign in",
                  onTap: _loading
                      ? null
                      : () async {
                          if (emailCtrl.text.isEmpty ||
                              passwordCtrl.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please fill all fields"),
                              ),
                            );
                            return;
                          }

                          setState(() => _loading = true);

                          final success =
                              await AuthService.loginWithApi(
                            email: emailCtrl.text.trim(),
                            password: passwordCtrl.text.trim(),
                          );

                          setState(() => _loading = false);

                          if (success && context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MainLayout(),
                              ),
                              (route) => false,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Invalid email or password"),
                              ),
                            );
                          }
                        },
                ),

                const SizedBox(height: 24),

                /// 🔹 Create account
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Create new account",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                /// 🔹 Divider
                const Center(
                  child: Text(
                    "Or continue with",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                /// 🔹 Social login (ready)
               Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        setState(() => _loading = true);

                        final success = await GoogleAuthService.signInWithGoogle();

                        setState(() => _loading = false);

                        if (success && context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MainLayout(),
                            ),
                            (route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Google sign-in failed"),
                            ),
                          );
                        }
                      },
                      child: _socialButton(
                        child: Image.asset(
                          'assets/images/google_icon.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  ],
                ),


                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Input Field (UNCHANGED UI)
  Widget _inputField(
    String hint, {
    required TextEditingController controller,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 15,
        ),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF1E90FF),
            width: 1.5,
          ),
        ),
      ),
    );
  }

  /// 🔹 Primary Button
  Widget _primaryButton({
    required String text,
    required VoidCallback? onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  /// 🔹 Social Button
  Widget _socialButton({required Widget child}) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: child),
    );
  }
}
