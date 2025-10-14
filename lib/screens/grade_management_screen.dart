import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class GradeManagementScreen extends StatefulWidget {
  const GradeManagementScreen({super.key});

  @override
  State<GradeManagementScreen> createState() => _GradeManagementScreenState();
}

class _GradeManagementScreenState extends State<GradeManagementScreen> {
  String selectedCohort = 'Frontend Cohort 2024';
  String selectedAssessment = 'All Assessments';

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
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _bulkGrade(),
                    icon: const Icon(Icons.grade, size: 16),
                    label: const Text('Bulk Grade'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('Export'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildStatsCards(),
          const SizedBox(height: 24),
          _buildGradesTable(),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        _buildDropdown(selectedCohort, Icons.group),
        const SizedBox(width: 16),
        _buildDropdown(selectedAssessment, Icons.assignment),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        _buildStatCard('85.2', 'Cohort Average', AppColors.primary),
        const SizedBox(width: 16),
        _buildStatCard('24', 'Total Students', AppColors.secondary),
        const SizedBox(width: 16),
        _buildStatCard('20', 'Graded', AppColors.success),
        const SizedBox(width: 16),
        _buildStatCard('4', 'Pending', AppColors.warning),
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
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget _buildGradesTable() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Container(
              color: Colors.grey[50],
              padding: const EdgeInsets.all(16),
              child: const Row(
                children: [
                  Expanded(flex: 2, child: Text('Student', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text('Assessment', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text('Score', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text('Submission', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text('Grade', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text('Actions', style: TextStyle(fontWeight: FontWeight.w600))),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) => _buildGradeRow(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeRow() {
    final assessments = ['JS Quiz', 'React Project', 'Final Exam'];
    final scores = ['85', '92', '78'];
    final submissions = ['On Time', 'Late', 'On Time'];
    final grades = ['B+', 'A-', 'C+'];
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('John Doe', style: TextStyle(fontWeight: FontWeight.w500)),
                Text('john.doe@email.com', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          Expanded(child: Text(assessments[0])),
          Expanded(child: Text('${scores[0]}%')),
          Expanded(child: _buildSubmissionChip(submissions[0])),
          Expanded(child: _buildGradeChip(grades[0])),
          Expanded(
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.edit, size: 16), onPressed: () => _editGrade()),
                IconButton(icon: const Icon(Icons.visibility, size: 16), onPressed: () => _viewSubmission()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 8),
          Text(value),
          const Icon(Icons.arrow_drop_down, size: 16),
        ],
      ),
    );
  }

  Widget _buildSubmissionChip(String status) {
    Color color = AppColors.success;
    if (status == 'Late') color = AppColors.warning;
    if (status == 'Missing') color = AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildGradeChip(String grade) {
    Color color = AppColors.success;
    if (grade.startsWith('C') || grade.startsWith('D')) color = AppColors.warning;
    if (grade.startsWith('F')) color = AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(grade, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  void _bulkGrade() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bulk Grade Assignment'),
        content: const Text('Apply grades to multiple students at once.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Apply')),
        ],
      ),
    );
  }

  void _editGrade() {
    // Edit individual grade
  }

  void _viewSubmission() {
    // View student submission
  }
}