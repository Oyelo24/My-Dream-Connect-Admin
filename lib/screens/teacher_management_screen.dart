import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class TeacherManagementScreen extends StatefulWidget {
  const TeacherManagementScreen({super.key});

  @override
  State<TeacherManagementScreen> createState() => _TeacherManagementScreenState();
}

class _TeacherManagementScreenState extends State<TeacherManagementScreen> {
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
                icon: const Icon(Icons.person_add, size: 16),
                label: const Text('Add Teacher'),
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
          _buildTeachersTable(),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        _buildStatCard('32', 'Total Teachers', AppColors.primary),
        const SizedBox(width: 16),
        _buildStatCard('28', 'Active', AppColors.success),
        const SizedBox(width: 16),
        _buildStatCard('4', 'On Leave', AppColors.warning),
        const SizedBox(width: 16),
        _buildStatCard('15', 'Avg Classes/Week', AppColors.secondary),
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

  Widget _buildTeachersTable() {
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
                  Expanded(flex: 2, child: Text('Teacher', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text('Subject', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text('Experience', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text('Classes', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text('Actions', style: TextStyle(fontWeight: FontWeight.w600))),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 15,
                itemBuilder: (context, index) => _buildTeacherRow(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherRow() {
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
                const Text('Dr. Sarah Johnson', style: TextStyle(fontWeight: FontWeight.w500)),
                Text('sarah.johnson@mdc.edu', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          const Expanded(child: Text('Mathematics')),
          const Expanded(child: Text('8 years')),
          const Expanded(child: Text('12')),
          Expanded(child: _buildStatusChip('Active')),
          Expanded(
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.visibility, size: 16), onPressed: () {}),
                IconButton(icon: const Icon(Icons.edit, size: 16), onPressed: () {}),
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