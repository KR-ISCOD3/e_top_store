import 'package:e_top_store/data/services/auth_service.dart';
import 'package:e_top_store/data/services/google_auth_service.dart';
import 'package:e_top_store/ui/screens/main/main_layout.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // 🔹 Controllers
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    confirmCtrl.dispose();
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
                  "Create Account",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Create an account so you can\nexplore all laptop",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 40),

                /// 🔹 NAME
                _inputField("Full Name", controller: nameCtrl),
                const SizedBox(height: 20),

                /// 🔹 EMAIL
                _inputField("Email", controller: emailCtrl),
                const SizedBox(height: 20),

                /// 🔹 PASSWORD
                _inputField(
                  "Password",
                  controller: passwordCtrl,
                  obscure: true,
                ),
                const SizedBox(height: 20),

                /// 🔹 CONFIRM PASSWORD
                _inputField(
                  "Confirm Password",
                  controller: confirmCtrl,
                  obscure: true,
                ),

                const SizedBox(height: 32),

                /// 🔹 SIGN UP
                _primaryButton(
                  text: "Sign up",
                  onTap: () async {
                    if (nameCtrl.text.isEmpty ||
                        emailCtrl.text.isEmpty ||
                        passwordCtrl.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill all fields"),
                        ),
                      );
                      return;
                    }

                    if (passwordCtrl.text != confirmCtrl.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Passwords do not match"),
                        ),
                      );
                      return;
                    }

                    final success = await AuthService.register(
                      name: nameCtrl.text.trim(),
                      email: emailCtrl.text.trim(),
                      password: passwordCtrl.text.trim(),
                    );

                    if (success && context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const MainLayout()),
                        (route) => false,
                      );
                    }
                  },
                ),

                const SizedBox(height: 24),

                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Already have an account",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                // const SizedBox(height: 10),

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

                /// 🔹 GOOGLE SIGN IN
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final success = await GoogleAuthService.signInWithGoogle();
                        if (success && context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const MainLayout()),
                            (route) => false,
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

  /// 🔹 INPUT FIELD (UNCHANGED UI)
  Widget _inputField(
    String hint, {
    required TextEditingController controller,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// 🔹 PRIMARY BUTTON
  Widget _primaryButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
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
          ),
        ),
      ),
    );
  }

  /// 🔹 SOCIAL BUTTON
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
