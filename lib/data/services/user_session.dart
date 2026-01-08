class UserSession {
  static int? id;
  static String? name;
  static String? email;
  static String? role;

  static bool get isLoggedIn => id != null;

  static void clear() {
    id = null;
    name = null;
    email = null;
    role = null;
  }
}
