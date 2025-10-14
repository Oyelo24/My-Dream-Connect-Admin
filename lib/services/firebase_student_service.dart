import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student.dart';

class FirebaseStudentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Student>> getAllStudents() async {
    try {
      final querySnapshot = await _firestore.collection('users')
          .where('role', isEqualTo: 'student')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Student(
          id: doc.id,
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          phone: data['phone'] ?? '',
          lastSeen: data['last_seen'] ?? 'Never',
          enrollmentDate: data['enrollment_date'] ?? '',
          attendance: '0%',
          grade: 'N/A',
          status: 'Active',
          progress: '0%',
          track: data['track'],
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch students: $e');
    }
  }

  Future<Student> getStudentById(String id) async {
    try {
      final doc = await _firestore.collection('users').doc(id).get();
      if (!doc.exists) {
        throw Exception('Student not found');
      }
      
      final data = doc.data()!;
      return Student(
        id: doc.id,
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        phone: data['phone'] ?? '',
        lastSeen: data['last_seen'] ?? 'Never',
        enrollmentDate: data['enrollment_date'] ?? '',
        attendance: '0%',
        grade: 'N/A',
        status: 'Active',
        progress: '0%',
        track: data['track'],
      );
    } catch (e) {
      throw Exception('Failed to fetch student: $e');
    }
  }
}