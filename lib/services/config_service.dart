import '../services/environment_service.dart';

class ConfigService {
  // Get base URL from environment service
  static String get baseUrl => EnvironmentService.pocketbaseUrl;

  // Collection names from environment service
  static String get adminCollection => EnvironmentService.adminCollection;
  static String get usersCollection => EnvironmentService.userCollection;
  static String get defaultCollection => EnvironmentService.adminCollection;

  // Get API base URL
  static String get apiBaseUrl => '$baseUrl/api';

  // Get collection URLs
  static String get adminCollectionUrl => adminCollection;
  static String get usersCollectionUrl => usersCollection;
  static String get defaultCollectionUrl => defaultCollection;

  // Auth endpoints
  static String getAuthWithPasswordUrl(String collection) =>
      '$apiBaseUrl/collections/$collection/auth-with-password';

  static String getRequestPasswordResetUrl(String collection) =>
      '$apiBaseUrl/collections/$collection/request-password-reset';

  static String getRefreshAuthUrl(String collection) =>
      '$apiBaseUrl/collections/$collection/auth-refresh';

  // Admin specific endpoints
  static String get adminAuthUrl => getAuthWithPasswordUrl(adminCollection);
  static String get adminPasswordResetUrl =>
      getRequestPasswordResetUrl(adminCollection);
  static String get adminRefreshUrl => getRefreshAuthUrl(adminCollection);

  // Users collection endpoints
  static String get usersAuthUrl => getAuthWithPasswordUrl(usersCollection);
  static String get usersPasswordResetUrl =>
      getRequestPasswordResetUrl(usersCollection);
  static String get usersRefreshUrl => getRefreshAuthUrl(usersCollection);

  // Default collection endpoints
  static String get defaultAuthUrl =>
      getAuthWithPasswordUrl(defaultCollection);
  static String get defaultPasswordResetUrl =>
      getRequestPasswordResetUrl(defaultCollection);
  static String get defaultRefreshUrl => getRefreshAuthUrl(defaultCollection);

  // Get collection URL by name
  static String getCollectionUrl(String collectionName) {
    switch (collectionName) {
      case 'admins':
        return adminCollection;
      case 'users':
        return usersCollection;
      default:
        return defaultCollection;
    }
  }

  // Environment helpers
  static bool get isDevelopment => EnvironmentService.isDevelopment;
  static bool get isProduction => EnvironmentService.isProduction;

  // Get current environment name
  static String get environmentName => EnvironmentService.environmentName;
}
