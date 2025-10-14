import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/signup_request.dart';
import 'storage_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<AccessResponse> login(LoginRequest request) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: request.email,
        password: request.password,
      );
      
      if (credential.user != null) {
        final userDoc = await _firestore.collection('users').doc(credential.user!.uid).get();
        final userData = userDoc.data();
        
        final response = AccessResponse(
          token: await credential.user!.getIdToken(),
          username: userData?['name'] ?? credential.user!.displayName,
          role: userData?['role'] ?? 'student',
          userData: userData,
        );
        
        await StorageService.saveUserData(
          response.username ?? 'User',
          response.role ?? 'student',
        );
        
        return response;
      }
      throw Exception('Login failed');
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  Future<AccessResponse> signup(SignupRequest request) async {
    try {
      print('AuthService: Creating user with role ${request.role}');
      final credential = await _auth.createUserWithEmailAndPassword(
        email: request.email,
        password: request.password,
      );
      
      if (credential.user != null) {
        print('AuthService: Saving user data to Firestore with role ${request.role}');
        await _firestore.collection('users').doc(credential.user!.uid).set({
          'name': request.username,
          'email': request.email,
          'role': request.role,
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        final response = AccessResponse(
          token: await credential.user!.getIdToken(),
          username: request.username,
          role: request.role,
        );
        
        print('AuthService: Saving to storage with role ${request.role}');
        await StorageService.saveUserData(request.username, request.role);
        return response;
      }
      throw Exception('Signup failed');
    } catch (e) {
      throw Exception('Signup error: $e');
    }
  }

  Future<bool> validateToken() async {
    return _auth.currentUser != null;
  }

  Future<void> logout() async {
    await _auth.signOut();
    await StorageService.clearAuthData();
  }

  Future<bool> get isAdmin async {
    final role = await StorageService.getRole();
    return role == 'admin';
  }

  Future<String?> getCurrentUserRole() async {
    return await StorageService.getRole();
  }
}
