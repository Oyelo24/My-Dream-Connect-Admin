import 'package:cloud_firestore/cloud_firestore.dart';

class TrackService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getAllTracks() async {
    try {
      final querySnapshot = await _firestore.collection('tracks').get();
      
      final tracks = <Map<String, dynamic>>[];
      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        
        // Get student count for this track
        final studentsQuery = await _firestore
            .collection('users')
            .where('role', isEqualTo: 'student')
            .where('track', isEqualTo: data['name'])
            .get();
        
        tracks.add({
          'id': doc.id,
          'name': data['name'] ?? '',
          'description': data['description'] ?? '',
          'students': studentsQuery.docs.length,
          'modules': data['modules'] ?? 0,
          'duration': data['duration'] ?? '',
          'status': data['status'] ?? 'Active',
          'instructor': data['instructor'] ?? '',
        });
      }
      
      return tracks;
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> getStudentTrack(String studentId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(studentId).get();
      if (!userDoc.exists) return null;
      
      final userData = userDoc.data()!;
      final trackName = userData['track'];
      if (trackName == null) return null;
      
      final trackQuery = await _firestore
          .collection('tracks')
          .where('name', isEqualTo: trackName)
          .get();
      
      if (trackQuery.docs.isEmpty) return null;
      
      final trackData = trackQuery.docs.first.data();
      
      // Get modules for this track
      final modulesQuery = await _firestore
          .collection('modules')
          .where('track', isEqualTo: trackName)
          .orderBy('order')
          .get();
      
      final modules = modulesQuery.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'title': data['title'] ?? '',
          'description': data['description'] ?? '',
          'progress': data['progress'] ?? 0,
          'status': data['status'] ?? 'Locked',
          'duration': data['duration'] ?? '',
          'lessons': data['lessons'] ?? 0,
        };
      }).toList();
      
      return {
        'track': trackData,
        'modules': modules,
      };
    } catch (e) {
      return null;
    }
  }

  Future<bool> createTrack(Map<String, dynamic> trackData) async {
    try {
      await _firestore.collection('tracks').add({
        ...trackData,
        'created_at': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}