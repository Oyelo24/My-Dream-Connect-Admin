class IdGeneratorService {
  // Generate student ID in format: MDC-YYYY-C####
  static String generateStudentId() {
    final year = DateTime.now().year;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final sequence = (timestamp % 10000).toString().padLeft(4, '0');
    return 'MDC-$year-C$sequence';
  }
  
  // Validate student ID format
  static bool isValidStudentId(String id) {
    final regex = RegExp(r'^MDC-\d{4}-C\d{4}$');
    return regex.hasMatch(id);
  }
  
  // Extract year from student ID
  static int? getYearFromStudentId(String id) {
    if (!isValidStudentId(id)) return null;
    final parts = id.split('-');
    return int.tryParse(parts[1]);
  }
  
  // Extract sequence number from student ID
  static int? getSequenceFromStudentId(String id) {
    if (!isValidStudentId(id)) return null;
    final parts = id.split('-');
    final sequence = parts[2].substring(1); // Remove 'C' prefix
    return int.tryParse(sequence);
  }
}