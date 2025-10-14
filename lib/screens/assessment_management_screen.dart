import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_colors.dart';
import '../services/admin_assessment_service.dart';

class AssessmentManagementScreen extends StatefulWidget {
  const AssessmentManagementScreen({super.key});

  @override
  State<AssessmentManagementScreen> createState() =>
      _AssessmentManagementScreenState();
}

class _AssessmentManagementScreenState
    extends State<AssessmentManagementScreen> {
  final AdminAssessmentService _assessmentService = AdminAssessmentService();
  String selectedCohort = 'Frontend Cohort 2024';
  String selectedType = 'All Types';

  Map<String, dynamic> _stats = {};
  List<Map<String, dynamic>> _assessments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssessmentData();
  }

  Future<void> _loadAssessmentData() async {
    try {
      final stats = await _assessmentService.getAssessmentStats();
      final assessments = await _assessmentService.getAssessments();

      if (!mounted) return;
      setState(() {
        _stats = stats;
        _assessments = assessments;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFilters(),
              ElevatedButton.icon(
                onPressed: () => _createAssessment(),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Create Assessment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildStatsCards(),
          const SizedBox(height: 24),
          _buildAssessmentsList(),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        _buildDropdown(selectedCohort, Icons.group),
        const SizedBox(width: 16),
        _buildDropdown(selectedType, Icons.assignment),
      ],
    );
  }

  Widget _buildDropdown(String value, IconData icon) {
    final items = icon == Icons.group
        ? [
            'All Cohorts',
            'Frontend Cohort 2024',
            'Backend Cohort 2024',
            'Data Analysis Cohort 2024',
          ]
        : ['All Types', 'Quiz', 'Project', 'Exam'];

    return DropdownButton<String>(
      value: value,
      items: items
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Row(
                children: [
                  Icon(icon, size: 16),
                  const SizedBox(width: 8),
                  Text(item),
                ],
              ),
            ),
          )
          .toList(),
      onChanged: (newValue) {
        setState(() {
          if (icon == Icons.group) {
            selectedCohort = newValue!;
          } else {
            selectedType = newValue!;
          }
        });
      },
      underline: Container(),
    );
  }

  Widget _buildStatsCards() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Row(
      children: [
        _buildStatCard(
          '${_stats['totalAssessments'] ?? 0}',
          'Total Assessments',
          AppColors.primary,
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          '${_stats['completedCount'] ?? 0}',
          'Completed',
          AppColors.success,
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          '${_stats['activeCount'] ?? 0}',
          'Active',
          AppColors.warning,
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          '${_stats['upcomingCount'] ?? 0}',
          'Upcoming',
          AppColors.secondary,
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          '${(_stats['avgScore'] ?? 0.0).toStringAsFixed(1)}%',
          'Avg Score',
          AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
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
              value,
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

  Widget _buildAssessmentsList() {
    return Expanded(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _assessments.isEmpty
          ? const Center(child: Text('No assessments found'))
          : ListView.builder(
              itemCount: _assessments.length,
              itemBuilder: (context, index) => _buildAssessmentCard(index),
            ),
    );
  }

  Widget _buildAssessmentCard(int index) {
    final assessment = _assessments[index];
    final submissionRate = assessment['submissionRate'];
    final totalSubmissions = assessment['totalSubmissions'];
    final totalStudents = assessment['totalStudents'];
    final avgScore = assessment['avgScore'];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        assessment['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Type: ${assessment['type']} • Duration: ${assessment['duration']} • Due: ${assessment['dueDate']}',
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(assessment['status']),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Submissions',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: submissionRate,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$totalSubmissions/$totalStudents submitted',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Average Score',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${avgScore.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _gradeAssessment(assessment['id']),
                  icon: const Icon(Icons.grade, size: 16),
                  label: const Text('Grade'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => _viewSubmissions(assessment['id']),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('View Submissions'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => _generateReport(assessment['id']),
                  icon: const Icon(Icons.analytics, size: 16),
                  label: const Text('Analytics'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = AppColors.success;
    if (status == 'Active') color = AppColors.warning;
    if (status == 'Upcoming') color = AppColors.secondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _createAssessment() {
    final titleController = TextEditingController();
    final durationController = TextEditingController();
    final marksController = TextEditingController();
    final courseController = TextEditingController();
    String selectedAssessmentType = 'Quiz';
    DateTime selectedDate = DateTime.now().add(const Duration(days: 7));

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Create New Assessment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Assessment Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedAssessmentType,
                  items: ['Quiz', 'Project', 'Exam', 'Assignment']
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => selectedAssessmentType = value!),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: courseController,
                  decoration: const InputDecoration(
                    labelText: 'Course/Subject',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: durationController,
                  decoration: const InputDecoration(
                    labelText: 'Duration (e.g., 30 min, 2 hours)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: marksController,
                  decoration: const InputDecoration(
                    labelText: 'Total Marks',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Due Date'),
                  subtitle: Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setDialogState(() => selectedDate = date);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  final success = await _assessmentService.createAssessment({
                    'title': titleController.text,
                    'type': selectedAssessmentType,
                    'course': courseController.text.isNotEmpty
                        ? courseController.text
                        : 'General',
                    'duration': durationController.text.isNotEmpty
                        ? durationController.text
                        : '30 min',
                    'total_marks': int.tryParse(marksController.text) ?? 100,
                    'due_date': Timestamp.fromDate(selectedDate),
                  });
                  Navigator.pop(context);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Assessment created successfully'),
                      ),
                    );
                    _loadAssessmentData();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to create assessment'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _gradeAssessment(String assessmentId) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Grading feature coming soon')),
    );
  }

  void _viewSubmissions(String assessmentId) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Submissions view coming soon')),
    );
  }

  void _generateReport(String assessmentId) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Analytics report coming soon')),
    );
  }
}
