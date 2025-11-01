import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // static const String baseUrl = 'http://localhost:3000/api';
  static const String baseUrl = 'http://192.168.31.75:3000/api';

  // Get auth token from SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('🔑 Retrieved token: ${token != null ? "Token exists (${token.substring(0, 20)}...)" : "No token found"}');
    return token;
  }

  // Get auth headers
  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    print('📤 Request headers: ${headers.keys.join(", ")}');
    return headers;
  }

  // Handle API errors
  static void _handleError(http.Response response) {
    if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please login again.');
    } else if (response.statusCode == 403) {
      throw Exception('Forbidden. You don\'t have permission.');
    } else if (response.statusCode >= 400) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'An error occurred');
    }
  }

  // ==================== AUTH APIS ====================
  
  static Future<Map<String, dynamic>> login(String email, String password, String role) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'role': role,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Save token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      return data;
    } else {
      _handleError(response);
      throw Exception('Login failed');
    }
  }

  static Future<Map<String, dynamic>> getCurrentUser() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      _handleError(response);
      throw Exception('Failed to get user');
    }
  }

  // ==================== CLASS APIS ====================
  
  static Future<List<dynamic>> getAllClasses() async {
    final headers = await _getHeaders();
    print('📡 Fetching classes from: $baseUrl/classes');
    final response = await http.get(
      Uri.parse('$baseUrl/classes'),
      headers: headers,
    );

    print('📨 getAllClasses response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('📦 getAllClasses response data: $data');
      final classes = data['classes'] as List<dynamic>;
      print('✅ Returning ${classes.length} classes');
      return classes;
    } else {
      print('❌ getAllClasses failed: ${response.body}');
      _handleError(response);
      throw Exception('Failed to load classes');
    }
  }

  static Future<Map<String, dynamic>> getClassById(int id) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/classes/$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['class'];
    } else {
      _handleError(response);
      throw Exception('Failed to load class');
    }
  }

  static Future<Map<String, dynamic>> createClass({
    required String name,
    required String grade,
    String? section,
    String? academicYear,
    int? capacity,
    int? teacherId,
  }) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/classes'),
      headers: headers,
      body: jsonEncode({
        'name': name,
        'grade': grade,
        if (section != null) 'section': section,
        if (academicYear != null) 'academicYear': academicYear,
        if (capacity != null) 'capacity': capacity,
        if (teacherId != null) 'teacherId': teacherId,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      _handleError(response);
      throw Exception('Failed to create class');
    }
  }

  static Future<Map<String, dynamic>> updateClass({
    required int id,
    String? name,
    String? grade,
    String? section,
    String? academicYear,
    int? capacity,
    int? teacherId,
  }) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/classes/$id'),
      headers: headers,
      body: jsonEncode({
        if (name != null) 'name': name,
        if (grade != null) 'grade': grade,
        if (section != null) 'section': section,
        if (academicYear != null) 'academicYear': academicYear,
        if (capacity != null) 'capacity': capacity,
        if (teacherId != null) 'teacherId': teacherId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      _handleError(response);
      throw Exception('Failed to update class');
    }
  }

  static Future<void> deleteClass(int id) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/classes/$id'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      _handleError(response);
      throw Exception('Failed to delete class');
    }
  }

  // ==================== SUBJECT APIS ====================
  
  static Future<List<dynamic>> getAllSubjects() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/subjects'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['subjects'];
    } else {
      _handleError(response);
      throw Exception('Failed to load subjects');
    }
  }

  static Future<Map<String, dynamic>> getSubjectById(int id) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/subjects/$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['subject'];
    } else {
      _handleError(response);
      throw Exception('Failed to load subject');
    }
  }

  static Future<Map<String, dynamic>> createSubject({
    required String name,
    required int classId,
    String? code,
    String? description,
    int? teacherId,
    int? credits,
  }) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/subjects'),
      headers: headers,
      body: jsonEncode({
        'name': name,
        'classId': classId,
        if (code != null) 'code': code,
        if (description != null) 'description': description,
        if (teacherId != null) 'teacherId': teacherId,
        if (credits != null) 'credits': credits,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      _handleError(response);
      throw Exception('Failed to create subject');
    }
  }

  static Future<Map<String, dynamic>> updateSubject({
    required int id,
    String? name,
    int? classId,
    String? code,
    String? description,
    int? teacherId,
    int? credits,
  }) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/subjects/$id'),
      headers: headers,
      body: jsonEncode({
        if (name != null) 'name': name,
        if (classId != null) 'classId': classId,
        if (code != null) 'code': code,
        if (description != null) 'description': description,
        if (teacherId != null) 'teacherId': teacherId,
        if (credits != null) 'credits': credits,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      _handleError(response);
      throw Exception('Failed to update subject');
    }
  }

  static Future<void> deleteSubject(int id) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/subjects/$id'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      _handleError(response);
      throw Exception('Failed to delete subject');
    }
  }

  // ==================== USER APIS (for getting teachers list) ====================
  
  static Future<List<dynamic>> getAllTeachers() async {
    final headers = await _getHeaders();
    // We'll need to add this endpoint to backend or filter from current user endpoint
    // For now, we'll use a placeholder
    final response = await http.get(
      Uri.parse('$baseUrl/users/teachers'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['teachers'];
    } else {
      // Return empty list if endpoint doesn't exist yet
      return [];
    }
  }
}
