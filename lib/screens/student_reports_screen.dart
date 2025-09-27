import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class StudentReportsScreen extends StatelessWidget {
  const StudentReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Track your learning progress and achievements',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            
            // Performance Cards
            Row(
              children: [
                Expanded(child: _buildPerformanceCard('A-', 'Grade', AppColors.primary)),
                const SizedBox(width: 12),
                Expanded(child: _buildPerformanceCard('84%', 'Attendance', AppColors.success)),
                const SizedBox(width: 12),
                Expanded(child: _buildPerformanceCard('80%', 'Progress', AppColors.warning)),
              ],
            ),
            const SizedBox(height: 32),
            
            // Recent Scores
            Row(
              children: [
                Icon(Icons.trending_up, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Recent Scores',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Your latest assessment results',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            
            _buildScoreItem('JavaScript Fundamentals', 'Dec 10, 2024', '95%', AppColors.success),
            _buildScoreItem('HTML & CSS Mastery', 'Dec 8, 2024', '88%', AppColors.primary),
            _buildScoreItem('Web Design Principles', 'Dec 5, 2024', '92%', AppColors.success),
            _buildScoreItem('Programming Logic', 'Dec 3, 2024', '78%', AppColors.primary),
            _buildScoreItem('Introduction to Web Dev', 'Dec 1, 2024', '85%', AppColors.primary),
            
            const SizedBox(height: 32),
            
            // Skill Development
            Row(
              children: [
                Icon(Icons.trending_up, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Skill Development',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Your progress in different skill areas',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            
            _buildSkillProgress('JavaScript', 0.85, 'Advanced'),
            _buildSkillProgress('HTML/CSS', 0.90, 'Expert'),
            _buildSkillProgress('React', 0.65, 'Intermediate'),
            _buildSkillProgress('Version Control', 0.75, 'Intermediate'),
            _buildSkillProgress('Problem Solving', 0.80, 'Advanced'),
            
            const SizedBox(height: 32),
            
            // Achievement Unlocked
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.warning,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Icon(Icons.emoji_events, color: Colors.white, size: 32),
                  SizedBox(height: 8),
                  Text(
                    'Achievement Unlocked!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Completed 80% of all assessments with excellent scores',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
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
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String title, String date, String score, Color scoreColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text(
                score,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: scoreColor,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.check_circle, color: scoreColor, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillProgress(String skill, double progress, String level) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skill,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                level,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 8,
          ),
          const SizedBox(height: 4),
          Text(
            '${(progress * 100).round()}%',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}