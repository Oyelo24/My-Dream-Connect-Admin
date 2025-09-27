import '../models/track.dart';

class TrackService {
  static List<Track> getTechTracks() {
    return [
      Track(
        id: 'data_analytics',
        name: 'Data Analytics',
        description: 'Database management and Data Science fundamentals',
        icon: '📊',
        duration: 16,
        enrolledStudents: 0,
      ),
      Track(
        id: 'cybersecurity',
        name: 'Cybersecurity',
        description: 'Information security and cyber threat protection',
        icon: '🔒',
        duration: 14,
        enrolledStudents: 0,
      ),
      Track(
        id: 'digital_marketing',
        name: 'Digital Media Marketing',
        description: 'Digital marketing strategies and social media management',
        icon: '📱',
        duration: 12,
        enrolledStudents: 0,
      ),
      Track(
        id: 'ui_ux_design',
        name: 'UI/UX Design',
        description: 'User interface and user experience design principles',
        icon: '🎨',
        duration: 14,
        enrolledStudents: 0,
      ),
      Track(
        id: 'programming',
        name: 'Programming',
        description: 'Software development and programming fundamentals',
        icon: '💻',
        duration: 18,
        enrolledStudents: 0,
      ),
      Track(
        id: 'artificial_intelligence',
        name: 'Artificial Intelligence',
        description: 'Machine learning and AI development',
        icon: '🤖',
        duration: 20,
        enrolledStudents: 0,
      ),
    ];
  }

  static Track? getTrackById(String id) {
    try {
      return getTechTracks().firstWhere((track) => track.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Track> getActiveTrack() {
    return getTechTracks().where((track) => track.isActive).toList();
  }
}