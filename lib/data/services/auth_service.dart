class AuthService {
  static bool _isLoggedIn = false; // private state

  static bool get isLoggedIn => _isLoggedIn;

  // 🔐 login
  static Future<void> login() async {
    _isLoggedIn = true;
  }

  // 📝 register (same effect for now)
  static Future<void> register() async {
    _isLoggedIn = true;
  }

  // 🚪 logout
  static void logout() {
    _isLoggedIn = false;
  }

  // 🔁 optional: remember tab before login
  static int? redirectTabIndex;
}
