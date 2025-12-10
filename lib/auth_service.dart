import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio();
  static const String baseUrl = 'https://dummyjson.com/auth';
  
  // Login và lưu token
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '$baseUrl/login',
        data: {
          'username': username,
          'password': password,
        },
      );
      
      if (response.statusCode == 200) {
        // Lưu token và thông tin user
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', response.data['accessToken']);
        await prefs.setString('refreshToken', response.data['refreshToken']);
        await prefs.setInt('userId', response.data['id']);
        await prefs.setString('username', response.data['username']);
        
        return {
          'success': true,
          'data': response.data,
        };
      }
      
      return {
        'success': false,
        'message': 'Đăng nhập thất bại',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi: ${e.toString()}',
      };
    }
  }
  
  // Lấy thông tin user
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      
      if (accessToken == null) {
        return {
          'success': false,
          'message': 'Chưa đăng nhập',
        };
      }
      
      final response = await _dio.get(
        '$baseUrl/me',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      }
      
      return {
        'success': false,
        'message': 'Không thể lấy thông tin người dùng',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi: ${e.toString()}',
      };
    }
  }
  
  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
  }
  
  // Kiểm tra đã login chưa
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }
}