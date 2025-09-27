import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../services/analytics_service.dart';

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  State<AnalyticsDashboardScreen> createState() =>
      _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen> {
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
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh Data',
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.download),
                tooltip: 'Export Report',
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildStatsCards(),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildPerformanceTrends(),
                      const SizedBox(height: 24),
                      _buildTopPerformers(),
                      const SizedBox(height: 24),
                      _buildWeeklyAttendance(),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildSubjectPerformance(),
                      const SizedBox(height: 24),
                      _buildStudentsNeedingSupport(),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
              'Analytics Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Comprehensive insights into student performance and engagement',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh Data',
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.download),
              tooltip: 'Export Report',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadAnalyticsStats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('Unable to load statistics'));
        }
        
        final stats = snapshot.data!;
        return Row(
          children: [
            _buildStatCard(
              stats['totalStudents']?.toString() ?? '0',
              'Total Students',
              AppColors.primary,
              '+${stats['studentGrowth'] ?? '0'}%',
            ),
            const SizedBox(width: 16),
            _buildStatCard(
              stats['averageAttendance']?.toString() ?? '0%',
              'Avg Attendance',
              AppColors.success,
              '+${stats['attendanceChange'] ?? '0'}%',
            ),
            const SizedBox(width: 16),
            _buildStatCard(
              stats['completedAssessments']?.toString() ?? '0',
              'Assessments',
              AppColors.warning,
              '+${stats['assessmentGrowth'] ?? '0'}%',
            ),
            const SizedBox(width: 16),
            _buildStatCard(
              stats['averageGrade']?.toString() ?? 'N/A',
              'Avg Grade',
              AppColors.secondary,
              stats['gradeChange'] ?? '',
            ),
          ],
        );
      },
    );
  }
  
  Future<Map<String, dynamic>> _loadAnalyticsStats() async {
    return await AnalyticsService().getAnalyticsData();
  }

  Widget _buildStatCard(String value, String label, Color color, String trend) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (trend.isNotEmpty)
                  Text(
                    trend,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
              ],
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

  Widget _buildPerformanceTrends() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.trending_up, size: 16, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Performance Trends',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Monthly performance analysis',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _loadPerformanceTrends(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No performance data available'));
              }
              
              return Column(
                children: snapshot.data!.map((trend) => 
                  _buildTrendItem(
                    trend['month'] ?? '',
                    trend['metric'] ?? '',
                    (trend['value'] as num?)?.toDouble() ?? 0.0,
                  )
                ).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Future<List<Map<String, dynamic>>> _loadPerformanceTrends() async {
    return await AnalyticsService().getPerformanceTrends();
  }

  Widget _buildTrendItem(String month, String metric, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(month, style: const TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(metric, style: const TextStyle(fontSize: 12)),
                    Text(
                      '${(value * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: value,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopPerformers() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.star, size: 16, color: AppColors.success),
              SizedBox(width: 8),
              Text(
                'Top Performers',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Students with highest assessment scores',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<Map<String, String>>>(
            future: _loadTopPerformers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No performance data available'));
              }
              
              return Column(
                children: snapshot.data!.map((performer) => 
                  _buildPerformerItem(
                    performer['name'] ?? '',
                    performer['assessment'] ?? '',
                    performer['score'] ?? '',
                  )
                ).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPerformerItem(String name, String assessment, String score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  assessment,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              score,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyAttendance() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.calendar_view_week, size: 16, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Weekly Attendance',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Attendance patterns over the week',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _loadWeeklyAttendance(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No attendance data available'));
              }
              
              return Column(
                children: snapshot.data!.map((day) => 
                  _buildAttendanceDay(
                    day['day'] ?? '',
                    (day['percentage'] as num?)?.toDouble() ?? 0.0,
                  )
                ).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildAttendanceDay(String day, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(day, style: const TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Attendance', style: TextStyle(fontSize: 12)),
                    Text(
                      '${(percentage * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: percentage,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Future<List<Map<String, String>>> _loadTopPerformers() async {
    return await AnalyticsService().getTopPerformers();
  }
  
  Future<List<Map<String, dynamic>>> _loadWeeklyAttendance() async {
    return await AnalyticsService().getWeeklyAttendance();
  }

  Widget _buildAttendanceBar(String day, double value) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 40,
              height: 100 * value,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(day.substring(0, 3), style: const TextStyle(fontSize: 10)),
        Text(
          '${(value * 100).toInt()}%',
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildSubjectPerformance() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.subject, size: 16, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Subject Performance',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Performance by subject area',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: AnalyticsService().getSubjectPerformance(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No subject data available'));
              }
              
              return Column(
                children: snapshot.data!.map((subject) => 
                  _buildSubjectItem(
                    subject['name'] ?? '',
                    (subject['score'] as num?)?.toDouble() ?? 0.0,
                  )
                ).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildSubjectItem(String subject, double score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(subject, style: const TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 16),
          Text(
            '${(score * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectItemWithProgress(String subject, double value, String percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subject,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(percentage, style: const TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsNeedingSupport() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning, size: 16, color: AppColors.warning),
              SizedBox(width: 8),
              Text(
                'Students Needing Support',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Students requiring attention',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<Map<String, String>>>(
            future: AnalyticsService().getStudentsNeedingSupport(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No students need support'));
              }
              
              return Column(
                children: snapshot.data!.map((student) => 
                  _buildSupportItem(
                    student['name'] ?? '',
                    student['reason'] ?? '',
                    student['metric'] ?? '',
                  )
                ).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildSupportItem(String name, String reason, String metric) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  reason,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            metric,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
