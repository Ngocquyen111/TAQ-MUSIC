class UserStore {
  static String? email;
  static String? password;

  static bool isRegistered() {
    return email != null && password != null;
  }

  static bool login(String e, String p) {
    return email == e && password == p;
  }

  static void register(String e, String p) {
    email = e;
    password = p;
  }

  static void logout() {
    email = null;
    password = null;
  }
}
