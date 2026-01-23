
class UserStore {
  static String uid = '';

  static String name = '';
  static String username = '';
  static String email = '';
  static String phone = '';
  static String birthday = '';



  static bool isLoggedIn = false;

  static void clear() {
    uid = '';
    name = '';
    username = '';
    email = '';
    phone = '';
    birthday = '';



    isLoggedIn = false;
  }
}
