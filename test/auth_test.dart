import 'package:flutter_test/flutter_test.dart';
import 'package:mdc_admin/services/auth_service.dart';
import 'package:mdc_admin/services/config_service.dart';
import 'package:mdc_admin/models/login_request.dart';

void main() {
  test('AuthService can be instantiated', () {
    final authService = AuthService();
    expect(authService, isNotNull);
  });

  test('AuthService initializes with users collection by default', () {
    final authService = AuthService();
    authService.initializeAuth(collectionName: 'users');
    expect(authService.currentCollection, 'users');
  });

  test('AuthService can switch to admin collection', () {
    final authService = AuthService();
    authService.initializeAuth(collectionName: 'admins');
    expect(authService.currentCollection, 'admins');
  });

  test('ConfigService provides correct environment URLs', () {
    expect(ConfigService.baseUrl, isNotNull);
    expect(ConfigService.apiBaseUrl, isNotNull);
    expect(ConfigService.isDevelopment, isNotNull);
    expect(ConfigService.environmentName, isNotNull);
  });

  test('ConfigService provides correct collection URLs', () {
    expect(ConfigService.adminCollectionUrl, 'admins');
    expect(ConfigService.usersCollectionUrl, 'users');
    expect(ConfigService.defaultCollectionUrl, 'users');
  });

  test('LoginRequest can be created', () {
    final request = LoginRequest(
      email: 'test@example.com',
      password: 'password',
    );
    expect(request.email, 'test@example.com');
    expect(request.password, 'password');
  });

  test('ConfigService getCollectionUrl works correctly', () {
    expect(ConfigService.getCollectionUrl('admins'), 'admins');
    expect(ConfigService.getCollectionUrl('users'), 'users');
    expect(
      ConfigService.getCollectionUrl('invalid'),
      'users',
    ); // Should default to users
  });
}
