import '../data/datasources/auth_services.dart';

class AuthRepository {
  Future<String> login(String email, String password) async {
    return await AuthServices.login(email, password);
  }

  Future<bool> register(String name, String email, String password, String phone) async {
    return await AuthServices.register(name, email, password, phone);
  }
}