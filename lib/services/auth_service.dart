import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/signup_request.dart';
import 'storage_service.dart';
import 'config_service.dart';

class AuthService {
  // Default to admins collection for admin-only login
  String _collectionName = ConfigService.getCollectionUrl('admins');

  // Set collection for authentication (admin/users)
  void setCollection(String collectionName) {
    _collectionName = ConfigService.getCollectionUrl(collectionName);
  }

  // Initialize auth service with collection type (defaults to admins)
  void initializeAuth({String collectionName = 'admins'}) {
    _collectionName = ConfigService.getCollectionUrl(collectionName);
  }

  Future<AccessResponse> login(LoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse(ConfigService.getAuthWithPasswordUrl(_collectionName)),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'identity': request.email,
          'password': request.password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final authResponse = AccessResponse.fromJson(data);
        if (authResponse.isValid) {
          // Save token and user data
          await _saveAuthData(authResponse);
          return authResponse;
        } else {
          throw Exception('Invalid authentication response');
        }
      } else {
        throw Exception(data['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<AccessResponse> signup(SignupRequest request) async {
    try {
      final response = await http.post(
        Uri.parse(ConfigService.getAuthWithPasswordUrl(_collectionName)),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': request.email,
          'password': request.password,
          'passwordConfirm': request.password,
          'name': request.username, // Using 'name' field as per your schema
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final authResponse = AccessResponse.fromJson(data);
        if (authResponse.isValid) {
          await _saveAuthData(authResponse);
          return authResponse;
        } else {
          throw Exception('Invalid signup response');
        }
      } else {
        throw Exception(data['message'] ?? 'Signup failed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> _saveAuthData(AccessResponse response) async {
    if (response.token != null) {
      await StorageService.saveAuthToken(response.token!);
    }
    if (response.username != null && response.role != null) {
      await StorageService.saveUserData(response.username!, response.role!);
    }
  }

  Future<bool> validateToken() async {
    try {
      final token = await StorageService.getAuthToken();
      if (token == null) return false;

      final response = await http.post(
        Uri.parse(ConfigService.getRefreshAuthUrl(_collectionName)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final token = await StorageService.getAuthToken();
      if (token != null) {
        // Call PocketBase logout endpoint
        await http.post(
          Uri.parse(
            '${ConfigService.baseUrl}/api/collections/${ConfigService.getCollectionUrl(_collectionName)}/auth-refresh',
          ),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'token': token}),
        );
      }
    } catch (e) {
      // Even if logout fails, clear local data
    } finally {
      await StorageService.clearAuthData();
    }
  }

  // Get current collection name
  String get currentCollection => _collectionName;

  // Check if current user is admin
  Future<bool> get isAdmin async {
    final role = await StorageService.getRole();
    return role == 'admin';
  }
}
