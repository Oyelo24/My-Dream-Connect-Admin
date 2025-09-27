import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/app_theme.dart';
import 'utils/app_routes.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'services/environment_service.dart';
import 'viewmodels/dashboard_viewmodel.dart';
import 'viewmodels/student_dashboard_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvironmentService.initialize();
  runApp(const MDCApp());
}

class MDCApp extends StatelessWidget {
  const MDCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModelAdmin()),
        ChangeNotifierProvider(create: (_) => StudentDashboardViewModel()),
      ],
      child: MaterialApp(
        title: EnvironmentService.appName,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.roleSelector,
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        debugShowCheckedModeBanner: kDebugMode ? false : false,
      ),
    );
  }
}
