import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class CourseManagementScreen extends StatefulWidget {
  const CourseManagementScreen({super.key});

  @override
  State<CourseManagementScreen> createState() => _CourseManagementScreenState();
}

class _CourseManagementScreenState extends State<CourseManagementScreen> {
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
                label: const Text('Add Course'),
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
          _buildCoursesTable(),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        _buildStatCard('24', 'Total Courses', AppColors.primary),
        const SizedBox(width: 16),
        _buildStatCard('18', 'Active', AppColors.success),
        const SizedBox(width: 16),
        _buildStatCard('6', 'Inactive', Colors.grey[400]!),
        const SizedBox(width: 16),
        _buildStatCard('156', 'Enrolled Students', AppColors.secondary),
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
            Text(count, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesTable() {
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
                  Expanded(flex: 2, child: Text('Course', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text('Code', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text('Instructor', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text('Students', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text('Actions', style: TextStyle(fontWeight: FontWeight.w600))),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) => _buildCourseRow(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
      child: Row(
        children: [
          const Expanded(flex: 2, child: Text('Mathematics 101')),
          const Expanded(child: Text('MATH101')),
          const Expanded(child: Text('Dr. Smith')),
          const Expanded(child: Text('25')),
          Expanded(child: _buildStatusChip('Active')),
          Expanded(
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.edit, size: 16), onPressed: () {}),
                IconButton(icon: const Icon(Icons.delete, size: 16), onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.success,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 10)),
    );
  }
}