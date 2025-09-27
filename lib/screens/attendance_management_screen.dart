// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../models/attendance.dart';
import '../services/attendance_service.dart';

class AttendanceManagementScreen extends StatefulWidget {
  const AttendanceManagementScreen({super.key});

  @override
  State<AttendanceManagementScreen> createState() =>
      _AttendanceManagementScreenState();
}

class _AttendanceManagementScreenState
    extends State<AttendanceManagementScreen> {
  String selectedDate = '12/10/2024';
  String selectedSession = 'All Sessions';

  List<AttendanceRecord> attendanceRecords = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAttendance();
  }

  Future<void> _fetchAttendance() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final data = await AttendanceService().getAllAttendanceRecords();
      setState(() {
        attendanceRecords = List<AttendanceRecord>.from(data);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load attendance records';
        isLoading = false;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '80% Present Today',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text('Bulk Approve'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildStatsCards(),
          const SizedBox(height: 24),
          _buildFilters(),
          const SizedBox(height: 24),
          _buildAttendanceTable(),
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
              'Attendance Management',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Review and manage student attendance records',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                '80% Present Today',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text('Bulk Approve'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        _buildStatCard('5', 'Total Students', Colors.grey[100]!, Colors.black),
        const SizedBox(width: 16),
        _buildStatCard('2', 'Present', AppColors.success, Colors.white),
        const SizedBox(width: 16),
        _buildStatCard('1', 'Late', AppColors.warning, Colors.white),
        const SizedBox(width: 16),
        _buildStatCard('1', 'Absent', AppColors.error, Colors.white),
        const SizedBox(width: 16),
        _buildStatCard('1', 'Excused', Colors.grey[400]!, Colors.white),
      ],
    );
  }

  Widget _buildStatCard(
    String count,
    String label,
    Color color,
    Color textColor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: textColor == Colors.white
                    ? Colors.white70
                    : Colors.grey[600],
              ),
            ),
          ],
        ),
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
              Text(selectedDate),
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
              Text(selectedSession),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_drop_down, size: 16),
            ],
          ),
        ),
      ],
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.grey[50],
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: const Row(
                children: [
                  Expanded(flex: 2, child: Text('Student', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(flex: 2, child: Text('Contact', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text('Session', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text('Check-In', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text('Notes', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text('Actions', style: TextStyle(fontWeight: FontWeight.w600))),
                ],
              ),
            ),
            if (isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (errorMessage != null)
              Expanded(child: Center(child: Text('Error: ' + errorMessage!)))
            else if (attendanceRecords.isEmpty)
              const Expanded(child: Center(child: Text('No attendance records found')))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: attendanceRecords.length,
                  itemBuilder: (context, index) =>
                      _buildTableRow(attendanceRecords[index]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(AttendanceRecord record) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.studentName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  record.studentEmail,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(record.session, style: const TextStyle(fontSize: 14)),
          ),
          Expanded(
            flex: 1,
            child: Text(
              record.checkInTime,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(flex: 1, child: _buildStatusChip(record.status)),
          Expanded(
            flex: 1,
            child: record.override != null
                ? _buildOverrideChip(record.override!)
                : const SizedBox(),
          ),
          Expanded(
            flex: 2,
            child: Text(
              record.notes,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: PopupMenuButton<String>(
              child: Text(
                record.status.displayName,
                style: const TextStyle(fontSize: 12, color: Colors.blue),
              ),
              onSelected: (value) {},
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'present', child: Text('Present')),
                const PopupMenuItem(value: 'late', child: Text('Late')),
                const PopupMenuItem(value: 'absent', child: Text('Absent')),
                const PopupMenuItem(value: 'excused', child: Text('Excused')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(AttendanceStatus status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case AttendanceStatus.present:
        color = const Color(0xFF4CAF50);
        text = 'present';
        icon = Icons.check_circle;
        break;
      case AttendanceStatus.late:
        color = const Color(0xFFFFA726);
        text = 'late';
        icon = Icons.schedule;
        break;
      case AttendanceStatus.absent:
        color = const Color(0xFFEF5350);
        text = 'absent';
        icon = Icons.cancel;
        break;
      case AttendanceStatus.excused:
        color = Colors.grey;
        text = 'excused';
        icon = Icons.check_circle_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverrideChip(String override) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFFA726),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        override,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }


