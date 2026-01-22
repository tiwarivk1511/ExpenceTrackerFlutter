import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://panelv3.cloudshope.com/api';

  AuthRepository() {
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  Future<bool> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/signIn',
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data['data']?['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['data']['token']);
        await prefs.setInt('userId', response.data['data']['id']);
        return true;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return false;
      }
      print(e);
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> signup(String name, String email, String username, String mobile, String password, String confirmPassword) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/signUp',
        data: {
          'name': name,
          'email': email,
          'username': username,
          'mobile': mobile,
          'password': password,
          'confirm_password': confirmPassword,
          'domainName': 'panelv3.cloudshope.com',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }
}
