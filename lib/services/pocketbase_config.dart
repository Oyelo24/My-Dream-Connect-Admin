/// PocketBase Configuration Helper
///
/// This file helps you configure your PocketBase backend connection.
/// Update the URLs below with your actual PocketBase instance details.
///
/// Example PocketBase setup:
/// 1. Create a new collection called 'admins' for admin users
/// 2. Create a new collection called 'users' for regular users
/// 3. Add fields: email, password, name, role (for admins)
///
/// Schema for 'admins' collection:
/// - email (email type)
/// - password (text type, but will be hashed by PocketBase)
/// - name (text type)
/// - role (select type with options: admin, student)
///
/// Schema for 'users' collection:
/// - email (email type)
/// - password (text type, but will be hashed by PocketBase)
/// - name (text type)
/// - role (select type with options: student, defaults to student)
///

class PocketBaseConfig {
  // TODO: Replace these URLs with your actual PocketBase instance
  static const String developmentUrl = 'http://127.0.0.1:8090';
  static const String productionUrl = 'https://your-pocketbase-instance.com';

  // Collection names (these should match your PocketBase collections)
  static const String adminCollection = 'admins';
  static const String userCollection = 'users';

  // Helper method to get the current environment URL
  static String getCurrentUrl() {
    // In development, use localhost
    // In production, use your deployed PocketBase instance
    return developmentUrl; // Change this based on your environment
  }

  // Helper method to get collection name based on user type
  static String getCollectionForUserType(String userType) {
    switch (userType.toLowerCase()) {
      case 'admin':
        return adminCollection;
      case 'user':
      case 'student':
      default:
        return userCollection;
    }
  }
}
