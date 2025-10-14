import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_colors.dart';
import '../models/student_assessment.dart';
import '../services/firebase_assessment_service.dart';

class StudentAssessmentsScreen extends StatefulWidget {
  const StudentAssessmentsScreen({super.key});

  @override
  State<StudentAssessmentsScreen> createState() => _StudentAssessmentsScreenState();
}

class _StudentAssessmentsScreenState extends State<StudentAssessmentsScreen> {
  final FirebaseAssessmentService _assessmentService = FirebaseAssessmentService();
  List<StudentAssessment> _assessments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssessments();
  }

  Future<void> _loadAssessments() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final assessments = await _assessmentService.getStudentAssessments(user.uid);
      setState(() {
        _assessments = assessments;
        _isLoading = false;
      });
    } else {
      setState(() {
        _assessments = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.grey,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final completedAssessments = _assessments.where((a) => a.status == StudentAssessmentStatus.completed).length;
    final totalAssessments = _assessments.length;
    final progressRate = totalAssessments > 0 ? completedAssessments / totalAssessments : 0.0;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Complete your tech assessments and track progress',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            
            // Progress Overview
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Assessment Progress',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '$completedAssessments of $totalAssessments completed',
                            style: const TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                        ],
                      ),
                      Text(
                        '${(progressRate * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: progressRate,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Available Assessments
            if (_assessments.where((a) => a.status == StudentAssessmentStatus.available).isNotEmpty) ...[
              const Text(
                'Available Assessments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ..._assessments
                  .where((a) => a.status == StudentAssessmentStatus.available)
                  .map((assessment) => _buildAssessmentCard(assessment)),
              const SizedBox(height: 32),
            ],
            
            // Completed Assessments
            if (_assessments.where((a) => a.status == StudentAssessmentStatus.completed).isNotEmpty) ...[
              const Text(
                'Completed Assessments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ..._assessments
                  .where((a) => a.status == StudentAssessmentStatus.completed)
                  .map((assessment) => _buildCompletedCard(assessment)),
            ],
            
            if (_assessments.isEmpty) ...[
              const Center(
                child: Column(
                  children: [
                    Icon(Icons.assignment, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No assessments available', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAssessmentCard(StudentAssessment assessment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            assessment.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(assessment.duration, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(width: 16),
              Icon(Icons.quiz, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(assessment.questions, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
          if (assessment.dueDate != null) ...[
            const SizedBox(height: 12),
            Text(
              'Due: ${assessment.dueDate}',
              style: TextStyle(fontSize: 14, color: AppColors.warning, fontWeight: FontWeight.w500),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _startAssessment(assessment),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.play_arrow, color: Colors.white),
              label: const Text(
                'Start Assessment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedCard(StudentAssessment assessment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            assessment.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Score: ${assessment.score ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                    if (assessment.completedDate != null)
                      Text(
                        'Completed: ${assessment.completedDate}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                  ],
                ),
                Icon(Icons.check_circle, color: AppColors.success, size: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startAssessment(StudentAssessment assessment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Start ${assessment.title}'),
        content: const Text('Are you ready to begin this assessment?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                final success = await _assessmentService.startAssessment(assessment.id, user.uid);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Starting ${assessment.title}...')),
                  );
                  _loadAssessments(); // Refresh
                }
              }
            },
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }
}