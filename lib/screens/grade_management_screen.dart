import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class GradeManagementScreen extends StatefulWidget {
  const GradeManagementScreen({super.key});

  @override
  State<GradeManagementScreen> createState() => _GradeManagementScreenState();
}

class _GradeManagementScreenState extends State<GradeManagementScreen> {
  String selectedCourse = 'All Courses';
  String selectedSemester = 'Current Semester';

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
                onPressed: () {},
                icon: const Icon(Icons.download, size: 16),
                label: const Text('Export Grades'),
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
          _buildGradesTable(),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              const Icon(Icons.book, size: 16),
              const SizedBox(width: 8),
              Text(selectedCourse),
              const Icon(Icons.arrow_drop_down, size: 16),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 8),
              Text(selectedSemester),
              const Icon(Icons.arrow_drop_down, size: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        _buildStatCard('85.2', 'Class Average', AppColors.primary),
        const SizedBox(width: 16),
        _buildStatCard('92', 'Highest Grade', AppColors.success),
        const SizedBox(width: 16),
        _buildStatCard('68', 'Lowest Grade', AppColors.error),
        const SizedBox(width: 16),
        _buildStatCard('78%', 'Pass Rate', AppColors.secondary),
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
                  Expanded(child: Text('Course', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text('Midterm', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text('Final', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text('Overall', style: TextStyle(fontWeight: FontWeight.w600))),
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
                Text('ID: ST2024001', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          const Expanded(child: Text('MATH101')),
          const Expanded(child: Text('85')),
          const Expanded(child: Text('88')),
          const Expanded(child: Text('86.5')),
          Expanded(child: _buildGradeChip('B+')),
          Expanded(
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.edit, size: 16), onPressed: () {}),
                IconButton(icon: const Icon(Icons.visibility, size: 16), onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
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
}