import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentService {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (!_initialized) {
      try {
        await dotenv.load(fileName: ".env");
        _initialized = true;
      } catch (e) {
        if (kDebugMode) {
          print('Warning: .env file not found, using default values');
        }
        _initialized = true;
      }
    }
  }

  // PocketBase Configuration
  static String get pocketbaseDevUrl => 
      dotenv.env['POCKETBASE_DEV_URL'] ?? 'http://127.0.0.1:8090';
  
  static String get pocketbaseProdUrl => 
      dotenv.env['POCKETBASE_PROD_URL'] ?? 'https://your-pocketbase-instance.com';

  static String get pocketbaseUrl => 
      kReleaseMode ? pocketbaseProdUrl : pocketbaseDevUrl;

  // App Configuration
  static String get appName => dotenv.env['APP_NAME'] ?? 'MDC Admin';
  static String get appSubtitle => dotenv.env['APP_SUBTITLE'] ?? 'Admin Panel';
  static String get appInitials => dotenv.env['APP_INITIALS'] ?? 'M';

  // Collection Names
  static String get adminCollection => 
      dotenv.env['ADMIN_COLLECTION'] ?? 'users';
  
  static String get userCollection => 
      dotenv.env['USER_COLLECTION'] ?? 'users';
  
  static String get studentCollection => 
      dotenv.env['STUDENT_COLLECTION'] ?? 'students';
  
  static String get attendanceCollection => 
      dotenv.env['ATTENDANCE_COLLECTION'] ?? 'attendance';
  
  static String get assessmentCollection => 
      dotenv.env['ASSESSMENT_COLLECTION'] ?? 'assessments';
  
  static String get analyticsCollection => 
      dotenv.env['ANALYTICS_COLLECTION'] ?? 'analytics';

  // Feature Flags
  static bool get enableAnalytics => 
      dotenv.env['ENABLE_ANALYTICS']?.toLowerCase() == 'true';
  
  static bool get enableBulkOperations => 
      dotenv.env['ENABLE_BULK_OPERATIONS']?.toLowerCase() == 'true';
  
  static bool get enableExport => 
      dotenv.env['ENABLE_EXPORT']?.toLowerCase() == 'true';

  // Environment helpers
  static bool get isDevelopment => !kReleaseMode;
  static bool get isProduction => kReleaseMode;
  static String get environmentName => isProduction ? 'production' : 'development';
}