import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthController extends ChangeNotifier {
  static final AuthController instance = AuthController._();
  AuthController._();

  final List<UserModel> _users = [
    UserModel(name: 'Demo User', email: 'user@test.com', password: '123', role: 'user'),
    UserModel(name: 'Demo Merchant', email: 'merchant@test.com', password: '123', role: 'merchant'),
  ];

  UserModel? currentUser;

  String? login(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      return 'Email dan password tidak boleh kosong!';
    }
    if (!email.contains('@')) {
      return 'Email harus mengandung karakter @';
    }
    try {
      currentUser = _users.firstWhere((u) => u.email == email && u.password == password);
      notifyListeners();
      return null;
    } catch (_) {
      return 'Email atau password salah!';
    }
  }

  String? register(String name, String email, String password, String role) {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      return 'Semua bidang harus diisi!';
    }
    if (!email.contains('@')) {
      return 'Email harus mengandung karakter @';
    }
    if (_users.any((u) => u.email == email)) return 'Email sudah terdaftar!';
    final user = UserModel(name: name, email: email, password: password, role: role);
    _users.add(user);
    currentUser = user;
    notifyListeners();
    return null;
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }
}
