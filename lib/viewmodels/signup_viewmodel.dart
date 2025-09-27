import 'package:flutter/material.dart';
import '../models/signup_request.dart';
import '../services/auth_service.dart';
import '../services/environment_service.dart';

class SignupViewModel extends ChangeNotifier {
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

  Future<bool> signup(String email, String password, String username) async {
    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      _setError('Please fill in all fields.');
      return false;
    }

    if (password.length < 6) {
      _setError('Password must be at least 6 characters long.');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      final request = SignupRequest(
        email: email,
        password: password,
        username: username,
      );
      final response = await _authService.signup(request);

      if (response.isValid) {
        _setLoading(false);
        return true;
      } else {
        _setError('Failed to create account. Please try again.');
      }
    } catch (error) {
      _setError(_formatError(error.toString()));
    }

    _setLoading(false);
    return false;
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

  Future<String?> getUserRole() async {
    try {
      return await _authService.getCurrentUserRole();
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}