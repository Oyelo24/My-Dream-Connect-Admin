import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../models/assessment.dart';
import '../services/assessment_service.dart';

class AssessmentManagementScreen extends StatefulWidget {
  const AssessmentManagementScreen({super.key});

  @override
  State<AssessmentManagementScreen> createState() =>
      _AssessmentManagementScreenState();
}

class _AssessmentManagementScreenState
    extends State<AssessmentManagementScreen> {
  List<Assessment> assessments = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAssessments();
  }

  Future<void> _fetchAssessments() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final data = await AssessmentService().getAllAssessments();
      setState(() {
        assessments = List<Assessment>.from(data);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load assessments';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Create Assessment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildStatsCards(),
          const SizedBox(height: 24),
          _buildAssessmentsTable(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assessment Management',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Create, manage, and monitor student assessments',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Create Assessment'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        _buildStatCard('4', 'Total Assessments', AppColors.primary),
        const SizedBox(width: 16),
        _buildStatCard('1', 'Active', AppColors.success),
        const SizedBox(width: 16),
        _buildStatCard('1', 'Completed', AppColors.warning),
        const SizedBox(width: 16),
        _buildStatCard('1', 'Drafts', Colors.grey[400]!),
      ],
    );
  }

  Widget _buildStatCard(String count, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssessmentsTable() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.assignment,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'All Assessments',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage and monitor all student assessments',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.grey[50],
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: const Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Assessment',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Subject',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Duration',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Questions',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Status',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Completion',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Performance',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Actions',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (errorMessage != null)
              Expanded(child: Center(child: Text('Error: ' + errorMessage!)))
            else if (assessments.isEmpty)
              const Expanded(child: Center(child: Text('No assessments found')))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: assessments.length,
                  itemBuilder: (context, index) =>
                      _buildAssessmentRow(assessments[index]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssessmentRow(Assessment assessment) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assessment.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Created: ${assessment.createdDate}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              assessment.subject,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                const Icon(
                  Icons.schedule,
                  size: 12,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(assessment.duration, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              assessment.questions,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(flex: 1, child: _buildStatusChip(assessment.status)),
          Expanded(
            flex: 1,
            child: Text(
              assessment.completion,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              assessment.performance,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility, size: 16),
                  onPressed: () {},
                  tooltip: 'View',
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 16),
                  onPressed: () {},
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: const Icon(Icons.bar_chart, size: 16),
                  onPressed: () {},
                  tooltip: 'Results',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(AssessmentStatus status) {
    Color color;
    String text;

    switch (status) {
      case AssessmentStatus.active:
        color = AppColors.success;
        text = 'active';
        break;
      case AssessmentStatus.completed:
        color = AppColors.primary;
        text = 'completed';
        break;
      case AssessmentStatus.draft:
        color = Colors.grey;
        text = 'draft';
        break;
      case AssessmentStatus.scheduled:
        color = AppColors.warning;
        text = 'scheduled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

enum AssessmentStatus { active, completed, draft, scheduled }

class Assessment {
  final String title;
  final String subject;
  final String duration;
  final String questions;
  final AssessmentStatus status;
  final String completion;
  final String performance;
  final String createdDate;

  Assessment({
    required this.title,
    required this.subject,
    required this.duration,
    required this.questions,
    required this.status,
    required this.completion,
    required this.performance,
    required this.createdDate,
  });
}
