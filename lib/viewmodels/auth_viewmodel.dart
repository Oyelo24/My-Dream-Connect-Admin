import 'package:flutter/material.dart';
import '../models/login_request.dart';
import '../models/signup_request.dart';
import '../services/auth_service.dart';
import '../models/user_role.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  String _userType = 'users'; // Support both admin and student login
  UserRole? _currentUserRole;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get userType => _userType;
  UserRole? get currentUserRole => _currentUserRole;
  bool get isAdmin => _currentUserRole == UserRole.admin;
  bool get isStudent => _currentUserRole == UserRole.student;

  // Initialize auth service with user type
  void setUserType(String type) {
    _userType = type;
    _authService.initializeAuth(collectionName: type);
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Please enter both email and password.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _authService.login(request);

      if (response.isValid) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid server response: Missing authentication data.';
      }
    } catch (error) {
      _errorMessage = error.toString().replaceFirst('Exception: ', '');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> signup(String email, String password, String username) async {
    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      _errorMessage = 'Please fill in all fields.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = SignupRequest(
        email: email,
        password: password,
        username: username,
      );
      final response = await _authService.signup(request);

      if (response.isValid) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid server response: Missing authentication data.';
      }
    } catch (error) {
      _errorMessage = error.toString().replaceFirst('Exception: ', '');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> validateCurrentSession() async {
    return await _authService.validateToken();
  }

  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }



  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
