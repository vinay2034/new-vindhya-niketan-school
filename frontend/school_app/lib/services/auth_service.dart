import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Your computer's IP address: 192.168.31.75
  static const String baseUrl = 'http://192.168.31.75:3000/api';
  static const String tokenKey = 'token'; // Changed from 'auth_token' to match ApiService

  Future<Map<String, dynamic>> login(String email, String password, String role) async {
    try {
      print('🔐 Attempting login: $email as $role');
      print('📡 API URL: $baseUrl/auth/login');
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'role': role, // Send role as-is (with capital letter)
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('⏱️ Request timed out after 10 seconds');
          throw Exception('Request timed out. Please check your network connection.');
        },
      );
      
      print('📨 Response status: ${response.statusCode}');
      print('📨 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Login successful!');
        // Store the token
        final token = data['token'];
        print('💾 Saving token with key "$tokenKey": ${token.substring(0, 20)}...');
        await _saveToken(token);
        // Store user info including role
        if (data['user'] != null) {
          await _saveUserInfo(data['user']);
        }
        print('✅ Token saved successfully');
        return data;
      } else {
        final error = json.decode(response.body);
        print('❌ Login failed: ${error['message']}');
        throw error['message'] ?? 'Login failed';
      }
    } catch (e) {
      print('❌ Exception: $e');
      throw 'Connection error: $e';
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _getToken();
    return token != null;
  }

  Future<void> logout() async {
    await _removeToken();
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$baseUrl/auth/verify'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Token management
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    await prefs.remove('user_info'); // Also remove user info
  }

  // User info management
  Future<void> _saveUserInfo(Map<String, dynamic> userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_info', json.encode(userInfo));
  }

  static Future<Map<String, dynamic>?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoStr = prefs.getString('user_info');
    if (userInfoStr != null) {
      return json.decode(userInfoStr);
    }
    return null;
  }

  static Future<String?> getUserRole() async {
    final userInfo = await getUserInfo();
    return userInfo?['role'];
  }

  static Future<bool> isAdmin() async {
    final role = await getUserRole();
    return role == 'Admin';
  }
}