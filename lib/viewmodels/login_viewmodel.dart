import 'package:flutter/material.dart';
import '../models/login_request.dart';
import '../services/auth_service.dart';
import '../services/environment_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get obscurePassword => _obscurePassword;

  String get appName => EnvironmentService.appName;
  String get appSubtitle => EnvironmentService.appSubtitle;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _setError('Please enter both email and password.');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _authService.login(request);

      if (response.isValid) {
        _setLoading(false);
        return true;
      } else {
        _setError('Invalid credentials. Please try again.');
      }
    } catch (error) {
      _setError(_formatError(error.toString()));
    }

    _setLoading(false);
    return false;
  }

  Future<String?> getUserRole() async {
    try {
      final role = await _authService.getCurrentUserRole();
      print('DEBUG: Retrieved user role: $role'); // Debug log
      return role;
    } catch (e) {
      print('DEBUG: Error getting user role: $e'); // Debug log
      return null;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _formatError(String error) {
    return error.replaceFirst('Exception: ', '');
  }

  void clearError() {
    _clearError();
  }

  @override
  void dispose() {
    super.dispose();
  }
}