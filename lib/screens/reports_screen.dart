import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String selectedPeriod = 'This Month';
  String selectedReport = 'All Reports';

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
                label: const Text('Export All'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildQuickStats(),
          const SizedBox(height: 24),
          _buildReportCategories(),
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
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 8),
              Text(selectedPeriod),
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
              const Icon(Icons.filter_list, size: 16),
              const SizedBox(width: 8),
              Text(selectedReport),
              const Icon(Icons.arrow_drop_down, size: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        _buildStatCard('156', 'Total Reports', AppColors.primary),
        const SizedBox(width: 16),
        _buildStatCard('24', 'Generated Today', AppColors.success),
        const SizedBox(width: 16),
        _buildStatCard('8', 'Scheduled', AppColors.warning),
        const SizedBox(width: 16),
        _buildStatCard('95%', 'Success Rate', AppColors.secondary),
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

  Widget _buildReportCategories() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildReportCard('Student Performance', Icons.trending_up, AppColors.primary, '45 reports'),
          _buildReportCard('Attendance Reports', Icons.calendar_today, AppColors.success, '32 reports'),
          _buildReportCard('Financial Reports', Icons.attach_money, AppColors.warning, '18 reports'),
          _buildReportCard('Course Analytics', Icons.book, AppColors.secondary, '28 reports'),
          _buildReportCard('Teacher Performance', Icons.person, AppColors.primary, '15 reports'),
          _buildReportCard('System Reports', Icons.settings, Colors.grey[600]!, '12 reports'),
        ],
      ),
    );
  }

  Widget _buildReportCard(String title, IconData icon, Color color, String count) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: const Text('Generate', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}