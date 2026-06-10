import 'package:flutter/material.dart';
import '../../repository/auth_repo.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _token;
  String? get token => _token;

  // Profile fields
  String? currentUserId; // 🔥 Tambahkan ini untuk dipakai di WebSocket
  String? name;
  String? phone;
  String? emailUser;

  // Load profile from repository using saved token
  Future<void> loadProfile() async {
    if (_token == null) return;
    try {
      final data = await _authRepo.getProfile(_token!);
      
      // 🔥 Ambil ID dari backend (ubah ke String agar aman & cocok dengan WebSocket)
      currentUserId = data['id']?.toString() ?? data['user_id']?.toString(); 
      
      name = data['name'] ?? data['full_name'] ?? data['username'];
      phone = data['phone'] ?? data['phone_number'] ?? '-';
      emailUser = data['email'] ?? data['email_user'] ?? '-';
      notifyListeners();
    } catch (e) {
      // ignore errors for now
    }
  }

  Future<bool> loginUser(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _token = await _authRepo.login(email, password);
      // setelah mendapatkan token, coba muat profil pengguna
      await loadProfile();
      
      _isLoading = false;
      notifyListeners();
      return true; 
      
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow; // 💡 Best practice Dart: gunakan rethrow, bukan throw e
    }
  }

  Future<bool> registerUser(String name, String email, String password, String phone) async {
    _isLoading = true;
    notifyListeners();

    try {
      bool isSuccess = await _authRepo.register(name, email, password, phone);
      _isLoading = false;
      notifyListeners();
      return isSuccess;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow; // 💡 Best practice Dart: gunakan rethrow
    }
  }

  // 💡 Opsional: Tambahkan fungsi logout untuk membersihkan data saat user keluar
  void logout() {
    _token = null;
    currentUserId = null;
    name = null;
    phone = null;
    emailUser = null;
    notifyListeners();
  }
}