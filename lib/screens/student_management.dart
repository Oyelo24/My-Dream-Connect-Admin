import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/firebase_student_service.dart';

class StudentManagement extends StatefulWidget {
  const StudentManagement({super.key});

  @override
  State<StudentManagement> createState() => _StudentManagementState();
}

class _StudentManagementState extends State<StudentManagement> {
  final FirebaseStudentService _studentService = FirebaseStudentService();
  List<Student> students = [];
  List<Student> filteredStudents = [];
  bool isLoading = false;
  String? errorMessage;
  String selectedTrack = 'All Tracks';
  final TextEditingController _searchController = TextEditingController();

  final List<String> tracks = [
    'All Tracks',
    'Programming',
    'UI/UX Design',
    'Data Science',
    'Digital Marketing',
    'Product Management',
  ];

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final data = await _studentService.getAllStudents();
      if (!mounted) return;
      setState(() {
        students = data;
        _filterStudents();
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Failed to load students';
        isLoading = false;
      });
    }
  }

  void _filterStudents() {
    filteredStudents = students.where((student) {
      final matchesTrack =
          selectedTrack == 'All Tracks' || student.track == selectedTrack;
      final matchesSearch =
          _searchController.text.isEmpty ||
          student.name.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ) ||
          student.email.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );
      return matchesTrack && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Student Management'),
      //   backgroundColor: const Color(0xFF4A90E2),
      //   foregroundColor: Colors.white,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Filters Row
            Row(
              children: [
                // Search Bar
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _filterStudents();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search students...',
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.grey[600]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Track Filter
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: selectedTrack,
                    underline: const SizedBox(),
                    items: tracks.map((track) {
                      return DropdownMenuItem(value: track, child: Text(track));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTrack = value!;
                        _filterStudents();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Students Table
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage != null
                  ? Center(child: Text(errorMessage!))
                  : filteredStudents.isEmpty
                  ? const Center(child: Text('No students found'))
                  : _buildStudentsTable(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentsTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Name',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Email',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Track',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Status',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Actions',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          // Table Body
          Expanded(
            child: ListView.builder(
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                return _buildStudentRow(filteredStudents[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentRow(Student student) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          // Name with Avatar
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF4A90E2),
                  child: Text(
                    student.name.isNotEmpty
                        ? student.name[0].toUpperCase()
                        : 'S',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    student.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Email
          Expanded(
            flex: 2,
            child: Text(student.email, overflow: TextOverflow.ellipsis),
          ),
          // Track
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getTrackColor(student.track),
                borderRadius: BorderRadius.circular(8 ),
              ),
              child: Text(
                student.track ?? 'N/A',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // Status
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: student.status == 'Active' ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                student.status,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Actions
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility, size: 18),
                  onPressed: () {
                    // Handle view action
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: () {
                    // Handle edit action
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTrackColor(String? track) {
    switch (track) {
      case 'Programming':
        return Colors.blue;
      case 'UI/UX Design':
        return Colors.purple;
      case 'Data Science':
        return Colors.green;
      case 'Digital Marketing':
        return Colors.orange;
      case 'Product Management':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
