import 'package:flutter/material.dart';

class DashboardViewModelAdmin extends ChangeNotifier {
  // Rename existing admin dashboard viewmodel to avoid conflicts
  // This will be used for admin-specific dashboard functionality
  
  bool _isLoading = false;
  String? _error;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void setError(String? error) {
    _error = error;
    notifyListeners();
  }
}