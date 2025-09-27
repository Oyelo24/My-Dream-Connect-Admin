import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class StudentAssessmentsScreen extends StatelessWidget {
  const StudentAssessmentsScreen({super.key});

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
              'Test your knowledge and skills',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            
            _buildAssessmentCard(
              title: 'JavaScript Fundamentals Quiz',
              duration: '15 min',
              questions: '5 questions',
              status: 'available',
              buttonText: 'Start Assessment',
              onPressed: () {},
            ),
            
            _buildAssessmentCard(
              title: 'HTML & CSS Assessment',
              duration: '20 min',
              questions: '8 questions',
              status: 'completed',
              score: '95%',
              buttonText: 'Completed',
              onPressed: null,
            ),
            
            _buildAssessmentCard(
              title: 'React Components Test',
              duration: '25 min',
              questions: '10 questions',
              status: 'upcoming',
              buttonText: 'Coming Soon',
              onPressed: null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssessmentCard({
    required String title,
    required String duration,
    required String questions,
    required String status,
    required String buttonText,
    String? score,
    VoidCallback? onPressed,
  }) {
    Color statusColor;
    Color buttonColor;
    Color? buttonTextColor;
    
    switch (status) {
      case 'available':
        statusColor = AppColors.primary;
        buttonColor = AppColors.primary;
        buttonTextColor = Colors.white;
        break;
      case 'completed':
        statusColor = AppColors.success;
        buttonColor = AppColors.success.withOpacity(0.1);
        buttonTextColor = AppColors.success;
        break;
      case 'upcoming':
        statusColor = AppColors.warning;
        buttonColor = AppColors.primary;
        buttonTextColor = Colors.white;
        break;
      default:
        statusColor = Colors.grey;
        buttonColor = Colors.grey;
        buttonTextColor = Colors.white;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
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
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(duration, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(width: 16),
              Icon(Icons.quiz, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(questions, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
          if (score != null) ...[
            const SizedBox(height: 12),
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
                    'Completed',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                  Text(
                    'Score: $score',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: status == 'completed' ? 0 : 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (status == 'available') ...[
                    const Icon(Icons.play_arrow, color: Colors.white),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    buttonText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: buttonTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}