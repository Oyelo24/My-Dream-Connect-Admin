import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class StudentCoursesScreen extends StatelessWidget {
  const StudentCoursesScreen({super.key});

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
              'Your enrolled courses and learning materials',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            
            // Current Courses
            const Text(
              'Current Courses',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildCourseCard(
              title: 'Web Development Bootcamp',
              instructor: 'Dr. Sarah Johnson',
              progress: 0.75,
              status: 'In Progress',
              statusColor: AppColors.primary,
            ),
            
            _buildCourseCard(
              title: 'JavaScript Fundamentals',
              instructor: 'Prof. Michael Chen',
              progress: 0.90,
              status: 'Almost Complete',
              statusColor: AppColors.success,
            ),
            
            const SizedBox(height: 32),
            
            // Completed Courses
            const Text(
              'Completed Courses',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildCourseCard(
              title: 'HTML & CSS Mastery',
              instructor: 'Dr. Emily Rodriguez',
              progress: 1.0,
              status: 'Completed',
              statusColor: AppColors.success,
              grade: 'A-',
            ),
            
            _buildCourseCard(
              title: 'Programming Logic',
              instructor: 'Prof. David Kim',
              progress: 1.0,
              status: 'Completed',
              statusColor: AppColors.success,
              grade: 'B+',
            ),
            
            const SizedBox(height: 32),
            
            // Upcoming Courses
            const Text(
              'Upcoming Courses',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildCourseCard(
              title: 'React Development',
              instructor: 'Dr. Alex Thompson',
              progress: 0.0,
              status: 'Starts Jan 15',
              statusColor: AppColors.warning,
            ),
            
            _buildCourseCard(
              title: 'Node.js Backend',
              instructor: 'Prof. Lisa Wang',
              progress: 0.0,
              status: 'Starts Feb 1',
              statusColor: AppColors.warning,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard({
    required String title,
    required String instructor,
    required double progress,
    required String status,
    required Color statusColor,
    String? grade,
  }) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      instructor,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (progress > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Progress',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              minHeight: 8,
            ),
            const SizedBox(height: 16),
          ],
          
          if (grade != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Final Grade',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                  Text(
                    grade,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: statusColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'View Details',
                    style: TextStyle(color: statusColor),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: progress > 0 && progress < 1.0 ? () {} : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statusColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    progress == 1.0 ? 'Completed' : progress > 0 ? 'Continue' : 'Coming Soon',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}