import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/student_service.dart';

class StudentManagement extends StatefulWidget {
  const StudentManagement({super.key});

  @override
  State<StudentManagement> createState() => _StudentManagementState();
}

class _StudentManagementState extends State<StudentManagement> {
  bool isLoading = true;
  String? errorMessage;
  Widget _buildStudentRow(Student student) {
    Color statusColor;
    Color statusBgColor;
    switch (student.status) {
      case 'ACTIVE':
        statusColor = Colors.green;
        statusBgColor = Colors.green.withOpacity(0.1);
        break;
      case 'HOLD':
        statusColor = Colors.orange;
        statusBgColor = Colors.orange.withOpacity(0.1);
        break;
      case 'INACTIVE':
        statusColor = Colors.grey;
        statusBgColor = Colors.grey.withOpacity(0.1);
        break;
      default:
        statusColor = Colors.grey;
        statusBgColor = Colors.grey.withOpacity(0.1);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          // Student Info
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  student.id,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          // Contact
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student.email, style: const TextStyle(fontSize: 12)),
                Text(
                  student.phone,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          // Enrollment
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.enrollmentDate,
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  student.lastSeen,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          // Attendance
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: Row(
                children: [
                  Text(
                    student.attendance,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LinearProgressIndicator(
                      value:
                          double.tryParse(
                                student.attendance.replaceAll('%', ''),
                              ) !=
                              null
                          ? double.parse(
                                  student.attendance.replaceAll('%', ''),
                                ) /
                                100
                          : 0.0,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        double.tryParse(
                                      student.attendance.replaceAll('%', ''),
                                    ) !=
                                    null &&
                                double.parse(
                                      student.attendance.replaceAll('%', ''),
                                    ) >=
                                    90
                            ? Colors.green
                            : double.tryParse(
                                        student.attendance.replaceAll('%', ''),
                                      ) !=
                                      null &&
                                  double.parse(
                                        student.attendance.replaceAll('%', ''),
                                      ) >=
                                      75
                            ? Colors.orange
                            : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Grade
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getGradeColor(student.grade).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  student.grade,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getGradeColor(student.grade),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          // Status
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  student.status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          // Progress
          Expanded(
            child: Text(
              student.progress,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          // Actions
          SizedBox(
            width: 80,
            child: IconButton(
              icon: const Icon(Icons.visibility, size: 16),
              onPressed: () {
                // Handle view action here
              },
              tooltip: 'View',
            ),
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(String grade) {
    if (grade.startsWith('A')) return Colors.green;
    if (grade.startsWith('B')) return Colors.blue;
    if (grade.startsWith('C')) return Colors.orange;
    return Colors.red;
  }

  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final data = await StudentService().getAllStudents();
      setState(() {
        students = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load students';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search students...',
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.grey[600]),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Students Table
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.people,
                          size: 20,
                          color: Color(0xFF4A90E2),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Enrolled Students',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Complete student roster with performance overview',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    color: Colors.grey[50],
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 2,
                          child: Text(
                            'Student',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Text(
                            'Contact',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Enrollment',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Attendance',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Grade',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Status',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Progress',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(
                          width: 80,
                          child: Text(
                            'Actions',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Table Rows
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (this.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (this.errorMessage != null) {
                          return Center(
                            child: Text('Error: ' + this.errorMessage!),
                          );
                        } else if (this.students.isEmpty) {
                          return const Center(child: Text('No students found'));
                        } else {
                          return ListView.builder(
                            itemCount: this.students.length,
                            itemBuilder: (context, index) =>
                                _buildStudentRow(this.students[index]),
                          );
                        }
                      },
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
