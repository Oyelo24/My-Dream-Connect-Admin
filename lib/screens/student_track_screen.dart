import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_colors.dart';
import '../services/track_service.dart';

class StudentTrackScreen extends StatefulWidget {
  const StudentTrackScreen({super.key});

  @override
  State<StudentTrackScreen> createState() => _StudentTrackScreenState();
}

class _StudentTrackScreenState extends State<StudentTrackScreen> {
  final TrackService _trackService = TrackService();
  String _studentTrack = '';
  List<Map<String, dynamic>> _modules = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudentTrack();
  }

  Future<void> _loadStudentTrack() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      
      final trackData = await _trackService.getStudentTrack(user.uid);
      if (!mounted) return;
      
      if (trackData != null) {
        setState(() {
          _studentTrack = trackData['track']['name'] ?? 'No Track';
          _modules = List<Map<String, dynamic>>.from(trackData['modules'] ?? []);
          _isLoading = false;
        });
      } else {
        setState(() {
          _studentTrack = 'No Track Assigned';
          _isLoading = false;
        });
      }
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
          _buildTrackHeader(),
          const SizedBox(height: 24),
          _buildProgressOverview(),
          const SizedBox(height: 24),
          _buildModulesList(),
        ],
      ),
    );
  }

  Widget _buildTrackHeader() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(_getTrackIcon(), size: 48, color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_studentTrack Track',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getTrackDescription(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTrackIcon() {
    switch (_studentTrack.toLowerCase()) {
      case 'programming': return Icons.code;
      case 'ui/ux design': return Icons.design_services;
      case 'data science': return Icons.analytics;
      case 'digital marketing': return Icons.campaign;
      default: return Icons.school;
    }
  }

  String _getTrackDescription() {
    switch (_studentTrack.toLowerCase()) {
      case 'programming': return 'Full-stack web development program';
      case 'ui/ux design': return 'User interface and experience design';
      case 'data science': return 'Data analysis and machine learning';
      case 'digital marketing': return 'Online marketing and social media';
      default: return 'Specialized learning track';
    }
  }

  Widget _buildProgressOverview() {
    final completedModules = _modules.where((m) => m['status'] == 'Completed').length;
    final totalModules = _modules.length;
    final overallProgress = completedModules / totalModules;
    
    return Row(
      children: [
        Expanded(
          child: _buildProgressCard(
            'Overall Progress',
            '${(overallProgress * 100).toInt()}%',
            overallProgress,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildProgressCard(
            'Modules Completed',
            '$completedModules/$totalModules',
            overallProgress,
            AppColors.success,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildProgressCard(
            'Current Module',
            'JavaScript Basics',
            0.85,
            AppColors.warning,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard(String title, String value, double progress, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildModulesList() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Learning Modules',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _modules.isEmpty
                    ? const Center(child: Text('No modules available for your track'))
                    : ListView.builder(
                        itemCount: _modules.length,
                        itemBuilder: (context, index) => _buildModuleCard(_modules[index], index),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard(Map<String, dynamic> module, int index) {
    final isLocked = module['status'] == 'Locked';
    final isCompleted = module['status'] == 'Completed';
    final isInProgress = module['status'] == 'In Progress';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isCompleted 
              ? AppColors.success 
              : isInProgress 
                  ? AppColors.warning 
                  : Colors.grey[300],
          child: Icon(
            isCompleted 
                ? Icons.check 
                : isLocked 
                    ? Icons.lock 
                    : Icons.play_arrow,
            color: isLocked ? Colors.grey[600] : Colors.white,
          ),
        ),
        title: Text(
          module['title'],
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isLocked ? Colors.grey[600] : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              module['description'],
              style: TextStyle(
                color: isLocked ? Colors.grey[500] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.schedule, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  module['duration'],
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.video_library, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  '${module['lessons']} lessons',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
            if (!isLocked && !isCompleted) ...[
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: module['progress'] / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              const SizedBox(height: 4),
              Text(
                '${module['progress']}% complete',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ],
        ),
        trailing: isLocked 
            ? null 
            : IconButton(
                onPressed: () => _openModule(module),
                icon: Icon(
                  isCompleted ? Icons.replay : Icons.arrow_forward,
                  color: AppColors.primary,
                ),
              ),
        onTap: isLocked ? null : () => _openModule(module),
      ),
    );
  }

  void _openModule(Map<String, dynamic> module) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${module['title']}')),
    );
  }
}