import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/app_theme.dart';
import 'utils/app_routes.dart';
import 'viewmodels/auth_viewmodel.dart';

void main() {
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        // Initialize auth service with users collection (shared for admins and students)
        final authViewModel = AuthViewModel();
        authViewModel.setUserType(
          'users',
        ); // Use users collection for all logins
        return authViewModel;
      },
      child: MaterialApp(
        title: 'MDC Admin Panel',
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.login,
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        debugShowCheckedModeBanner: kDebugMode ? false : false,
      ),
    );
  }
}
