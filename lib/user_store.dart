class UserStore {
  static String uid = '';

  static String name = '';
  static String username = '';
  static String email = '';
  static String phone = '';
  static String birthday = '';
  static String password = '';

  static bool isLoggedIn = false;

  static void clear() {
    uid = '';
    name = '';
    email = '';
    phone = '';
    birthday = '';
    password = '';
    isLoggedIn = false;
  }
}