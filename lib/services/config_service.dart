import 'package:flutter/foundation.dart';

class ConfigService {
  // Environment configuration - Update these URLs with your actual PocketBase instance
  static const String _devBaseUrl = 'http://127.0.0.1:8090';
  static const String _prodBaseUrl =
      'https://your-pocketbase-instance.com'; // TODO: Replace with your actual PocketBase URL

  // Collection names
  static const String _adminCollection = 'admins';
  static const String _usersCollection = 'users';
  static const String _defaultCollection =
      'admins'; // Default to admins collection for admin-only login

  // Get base URL based on environment
  static String get baseUrl {
    if (kReleaseMode) {
      return _prodBaseUrl;
    }
    return _devBaseUrl;
  }

  // Get API base URL
  static String get apiBaseUrl => '$baseUrl/api';

  // Get collection URLs
  static String get adminCollectionUrl => '$_adminCollection';
  static String get usersCollectionUrl => '$_usersCollection';
  static String get defaultCollectionUrl => '$_defaultCollection';

  // Auth endpoints
  static String getAuthWithPasswordUrl(String collection) =>
      '$apiBaseUrl/collections/$collection/auth-with-password';

  static String getRequestPasswordResetUrl(String collection) =>
      '$apiBaseUrl/collections/$collection/request-password-reset';

  static String getRefreshAuthUrl(String collection) =>
      '$apiBaseUrl/collections/$collection/auth-refresh';

  // Admin specific endpoints
  static String get adminAuthUrl => getAuthWithPasswordUrl(_adminCollection);
  static String get adminPasswordResetUrl =>
      getRequestPasswordResetUrl(_adminCollection);
  static String get adminRefreshUrl => getRefreshAuthUrl(_adminCollection);

  // Users collection endpoints
  static String get usersAuthUrl => getAuthWithPasswordUrl(_usersCollection);
  static String get usersPasswordResetUrl =>
      getRequestPasswordResetUrl(_usersCollection);
  static String get usersRefreshUrl => getRefreshAuthUrl(_usersCollection);

  // Default collection endpoints (users)
  static String get defaultAuthUrl =>
      getAuthWithPasswordUrl(_defaultCollection);
  static String get defaultPasswordResetUrl =>
      getRequestPasswordResetUrl(_defaultCollection);
  static String get defaultRefreshUrl => getRefreshAuthUrl(_defaultCollection);

  // Get collection URL by name
  static String getCollectionUrl(String collectionName) {
    switch (collectionName) {
      case 'admins':
        return _adminCollection;
      case 'users':
        return _usersCollection;
      default:
        return _defaultCollection;
    }
  }

  // Environment helpers
  static bool get isDevelopment => !kReleaseMode;
  static bool get isProduction => kReleaseMode;

  // Get current environment name
  static String get environmentName =>
      isProduction ? 'production' : 'development';
}
