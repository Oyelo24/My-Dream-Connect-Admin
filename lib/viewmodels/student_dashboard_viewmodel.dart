import 'package:flutter/material.dart';

class StudentDashboardViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  String _userName = '';
  double _attendance = 0.0;
  String _overallGrade = 'N/A';
  int _completedAssessments = 0;
  int _totalAssessments = 0;
  List<Map<String, String>> _upcomingAssessments = [];
  List<Map<String, String?>> _recentActivity = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get userName => _userName;
  double get attendance => _attendance;
  String get overallGrade => _overallGrade;
  int get completedAssessments => _completedAssessments;
  int get totalAssessments => _totalAssessments;
  double get assessmentProgress => _totalAssessments > 0 ? _completedAssessments / _totalAssessments : 0.0;
  List<Map<String, String>> get upcomingAssessments => _upcomingAssessments;
  List<Map<String, String?>> get recentActivity => _recentActivity;

  Future<void> loadDashboardData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Load student dashboard data from backend
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      _userName = 'Student Name';
      _attendance = 0.85;
      _overallGrade = 'B+';
      _completedAssessments = 8;
      _totalAssessments = 12;
      
      _upcomingAssessments = [
        {
          'title': 'JavaScript Fundamentals',
          'date': 'Tomorrow, 10:00 AM',
          'type': 'Quiz'
        },
        {
          'title': 'React Components',
          'date': 'Friday, 2:00 PM',
          'type': 'Assignment'
        },
      ];
      
      _recentActivity = [
        {
          'title': 'Completed HTML/CSS Assessment',
          'time': '2 hours ago',
          'score': '92%'
        },
        {
          'title': 'Attended Morning Session',
          'time': '4 hours ago',
          'score': null
        },
      ];
      
      _isLoading = false;
    } catch (e) {
      _error = 'Failed to load dashboard data';
      _isLoading = false;
    }
    
    notifyListeners();
  }
}