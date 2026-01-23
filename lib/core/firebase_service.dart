import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

import '../user_store.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  /// =========================
  /// REGISTER
  /// =========================
  Future<User?> register({
    required String name,
    required String username,
    required String password,
  }) async {
    try {
      final email = "$username@taqmusic.com";

      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user;
      if (user != null) {
        await _db.collection('users').doc(user.uid).set({
          'name': name,
          'username': username,
          'email': email,
          'phone': '',
          'birthday': '',
          'favorites': [],
          'downloads': [],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return user;
    } catch (e) {
      debugPrint("Register error: $e");
      return null;
    }
  }

  /// =========================
  /// LOGIN WITH USERNAME + PASSWORD ✅ FIX
  /// =========================
  Future<User?> loginWithEmail(
      String username,
      String password,
      ) async {
    try {
      final email = "$username@taqmusic.com";

      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user;
      if (user != null) {
        final doc =
        await _db.collection('users').doc(user.uid).get();

        if (doc.exists) {
          final data = doc.data()!;

          /// 🔥 GÁN ĐẦY ĐỦ USERSTORE
          UserStore.uid = user.uid;
          UserStore.name = data['name'] ?? '';
          UserStore.username = data['username'] ?? '';
          UserStore.email = data['email'] ?? '';
          UserStore.phone = data['phone'] ?? '';
          UserStore.birthday = data['birthday'] ?? '';
          UserStore.isLoggedIn = true;
        }
      }

      return user;
    } catch (e) {
      debugPrint("Login error: $e");
      return null;
    }
  }

  /// =========================
  /// GOOGLE LOGIN
  /// =========================
  Future<User?> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final cred = await _auth.signInWithCredential(credential);
      final user = cred.user;

      if (user != null) {
        final ref = _db.collection('users').doc(user.uid);
        final doc = await ref.get();

        if (!doc.exists) {
          await ref.set({
            'name': user.displayName ?? '',
            'username': '',
            'email': user.email ?? '',
            'phone': '',
            'birthday': '',
            'favorites': [],
            'downloads': [],
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        final data = (await ref.get()).data()!;

        UserStore.uid = user.uid;
        UserStore.name = data['name'] ?? '';
        UserStore.username = data['username'] ?? '';
        UserStore.email = data['email'] ?? '';
        UserStore.phone = data['phone'] ?? '';
        UserStore.birthday = data['birthday'] ?? '';
        UserStore.isLoggedIn = true;
      }

      return user;
    } catch (e) {
      debugPrint("Google login error: $e");
      return null;
    }
  }

  /// =========================
  /// LOGOUT
  /// =========================
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    UserStore.clear();
  }

  User? get currentUser => _auth.currentUser;
}