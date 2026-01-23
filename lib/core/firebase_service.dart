import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

import '../models/song.dart';
import '../user_store.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _google = GoogleSignIn(scopes: ['email']);

  /// ================= CHECK USERNAME =================
  Future<bool> isUsernameExists(String username) async {
    try {
      final snapshot = await _db
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint('Check username error: $e');
      return false;
    }
  }

  /// ================= REGISTER =================
  Future<User?> register({
    required String name,
    required String username,
    required String password,
  }) async {
    try {
      // 1️⃣ check username tồn tại (Firestore)
      final exists = await isUsernameExists(username);
      if (exists) {
        throw 'USERNAME_EXISTS';
      }

      // 2️⃣ tạo email ảo
      final email = '$username@taqmusic.com';

      // 3️⃣ tạo user Firebase Auth
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user;
      if (user == null) return null;

      // 4️⃣ lưu user Firestore
      await _db.collection('users').doc(user.uid).set({
        'name': name,
        'username': username,
        'email': email,
        'phone': '',
        'birthday': '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return user;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuth error: ${e.code}');
      rethrow;
    } catch (e) {
      debugPrint('Register error: $e');
      rethrow; // ⚠️ BẮT BUỘC để UI xử lý USERNAME_EXISTS
    }
  }

  /// ================= LOGIN =================
  Future<User?> loginWithEmail(String username, String password) async {
    try {
      final email = '$username@taqmusic.com';

      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _loadUserData(cred.user);
      return cred.user;
    } catch (e) {
      debugPrint('Login error: $e');
      return null;
    }
  }

  /// ================= GOOGLE LOGIN =================
  Future<User?> signInWithGoogle() async {
    try {
      await _google.signOut();

      final googleUser = await _google.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final cred = await _auth.signInWithCredential(credential);
      final user = cred.user;
      if (user == null) return null;

      final ref = _db.collection('users').doc(user.uid);

      if (!(await ref.get()).exists) {
        await ref.set({
          'name': user.displayName ?? '',
          'username': '',
          'email': user.email ?? '',
          'phone': '',
          'birthday': '',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      await _loadUserData(user);
      return user;
    } catch (e) {
      debugPrint('Google login error: $e');
      return null;
    }
  }

  /// ================= LOAD USER =================
  Future<void> _loadUserData(User? user) async {
    if (user == null) return;

    final doc = await _db.collection('users').doc(user.uid).get();
    if (!doc.exists) return;

    final data = doc.data()!;

    UserStore.uid = user.uid;
    UserStore.name = data['name'] ?? '';
    UserStore.username = data['username'] ?? '';
    UserStore.email = data['email'] ?? '';
    UserStore.phone = data['phone'] ?? '';
    UserStore.birthday = data['birthday'] ?? '';
    UserStore.isLoggedIn = true;
  }

  List<Song> _parseSongs(dynamic raw) {
    if (raw == null) return [];
    return List<Map<String, dynamic>>.from(raw)
        .map((e) => Song.fromMap(e))
        .toList();
  }

  /// ================= LOGOUT =================
  Future<void> signOut() async {
    await _auth.signOut();
    await _google.signOut();
    UserStore.clear();
  }
}
