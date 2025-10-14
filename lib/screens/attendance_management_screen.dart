import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../services/admin_attendance_service.dart';

class AttendanceManagementScreen extends StatefulWidget {
  const AttendanceManagementScreen({super.key});

  @override
  State<AttendanceManagementScreen> createState() => _AttendanceManagementScreenState();
}

class _AttendanceManagementScreenState extends State<AttendanceManagementScreen> {
  final AdminAttendanceService _attendanceService = AdminAttendanceService();
  String selectedCohort = 'Frontend Cohort 2024';
  String selectedDate = 'Today';
  
  Map<String, dynamic> _stats = {};
  List<Map<String, dynamic>> _attendanceList = [];
  bool _isLoading = true;
  bool _isSessionActive = false;

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
  }

  Future<void> _loadAttendanceData() async {
    try {
      final stats = await _attendanceService.getAttendanceStats();
      final attendance = await _attendanceService.getTodayAttendance();
      final sessionActive = await _attendanceService.isSessionActive();
      
      if (mounted) {
        setState(() {
          _stats = stats;
          _attendanceList = attendance;
          _isSessionActive = sessionActive;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
                    onPressed: _isSessionActive ? _closeSession : _startSession,
                    icon: Icon(
                      _isSessionActive ? Icons.stop : Icons.play_arrow,
                      size: 16,
                    ),
                    label: Text(_isSessionActive ? 'Close Session' : 'Start Session'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isSessionActive ? AppColors.error : AppColors.success,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _isSessionActive ? Colors.green[100] : Colors.red[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isSessionActive ? Icons.radio_button_checked : Icons.radio_button_off,
                          size: 12,
                          color: _isSessionActive ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _isSessionActive ? 'Session Active' : 'Session Closed',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _isSessionActive ? Colors.green[800] : Colors.red[800],
                          ),
                        ),
                      ],
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
          _buildAttendanceTable(),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        _buildDropdown(selectedCohort, Icons.group),
        const SizedBox(width: 16),
        _buildDropdown(selectedDate, Icons.calendar_today),
      ],
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

  Widget _buildStatsCards() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return Row(
      children: [
        _buildStatCard('${_stats['totalStudents'] ?? 0}', 'Total Students', AppColors.primary),
        const SizedBox(width: 16),
        _buildStatCard('${_stats['presentCount'] ?? 0}', 'Present', AppColors.success),
        const SizedBox(width: 16),
        _buildStatCard('${_stats['lateCount'] ?? 0}', 'Late', AppColors.warning),
        const SizedBox(width: 16),
        _buildStatCard('${_stats['absentCount'] ?? 0}', 'Absent', AppColors.error),
        const SizedBox(width: 16),
        _buildStatCard('${(_stats['attendanceRate'] ?? 0.0).toStringAsFixed(1)}%', 'Attendance Rate', AppColors.secondary),
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

  Widget _buildAttendanceTable() {
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
                  Expanded(child: Text('Check-in Time', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text('Engagement', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text('Actions', style: TextStyle(fontWeight: FontWeight.w600))),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _attendanceList.isEmpty
                      ? const Center(child: Text('No students found'))
                      : ListView.builder(
                          itemCount: _attendanceList.length,
                          itemBuilder: (context, index) => _buildAttendanceRow(index),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceRow(int index) {
    final student = _attendanceList[index];
    final status = student['status'];
    final checkInTime = student['checkInTime'];
    final engagement = student['engagement'];

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
                Text(student['studentName'], style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(student['studentEmail'], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          Expanded(child: Text(checkInTime)),
          Expanded(child: _buildStatusChip(status)),
          Expanded(child: _buildEngagementBar(engagement)),
          Expanded(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 16),
                  onPressed: () => _editAttendance(student['studentId'], status),
                ),
                IconButton(
                  icon: const Icon(Icons.message, size: 16),
                  onPressed: () => _sendMessage(student['studentName']),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = AppColors.success;
    if (status == 'Late') color = AppColors.warning;
    if (status == 'Absent') color = AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildEngagementBar(double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${(value * 100).toInt()}%', style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          minHeight: 4,
        ),
      ],
    );
  }

  void _startSession() {
    final titleController = TextEditingController();
    final topicController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start New Session'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Session Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: topicController,
              decoration: const InputDecoration(
                labelText: 'Topic',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty && topicController.text.isNotEmpty) {
                final success = await _attendanceService.startSession(
                  titleController.text,
                  topicController.text,
                );
                Navigator.pop(context);
                if (mounted) {
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Session started - Students can now mark attendance')),
                    );
                    _loadAttendanceData();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to start session')),
                    );
                  }
                }
              }
            },
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }

  void _closeSession() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Close Session'),
        content: const Text('Are you sure you want to close the current session? Students will no longer be able to mark attendance.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final success = await _attendanceService.closeSession();
              Navigator.pop(context);
              if (mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Session closed - Attendance marking disabled')),
                  );
                  _loadAttendanceData();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to close session')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Close Session'),
          ),
        ],
      ),
    );
  }

  void _editAttendance(String studentId, String currentStatus) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Attendance'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Present'),
              leading: Radio<String>(
                value: 'Present',
                groupValue: currentStatus,
                onChanged: (value) => _updateStatus(studentId, value!),
              ),
            ),
            ListTile(
              title: const Text('Late'),
              leading: Radio<String>(
                value: 'Late',
                groupValue: currentStatus,
                onChanged: (value) => _updateStatus(studentId, value!),
              ),
            ),
            ListTile(
              title: const Text('Absent'),
              leading: Radio<String>(
                value: 'Absent',
                groupValue: currentStatus,
                onChanged: (value) => _updateStatus(studentId, value!),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ],
      ),
    );
  }

  void _updateStatus(String studentId, String status) async {
    Navigator.pop(context);
    final success = await _attendanceService.updateAttendance(studentId, status);
    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance updated successfully')),
      );
      _loadAttendanceData();
    }
  }

  void _sendMessage(String studentName) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message feature for $studentName coming soon')),
      );
    }
  }
}