import 'package:flutter/material.dart';
import '../../repository/auth_repo.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _token;
  String? get token => _token;

  Future<bool> loginUser(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _token = await _authRepo.login(email, password);
      
      _isLoading = false;
      notifyListeners();
      return true; 
      
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw e; 
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
      throw e;
    }
  }
}