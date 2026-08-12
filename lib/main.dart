import 'package:factrack_mobile/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'core/utils/custom_loading.dart';
import 'features/auth/auth_provider.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/bills/bill_provider.dart';
import 'features/dashboard/dashboard_provider.dart';
import 'features/setup/setup_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(

    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => BillProvider()),
      ],
      child: const FacTrackApp(),
    ),
  );
}

class FacTrackApp extends StatelessWidget {
  const FacTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FacTrack',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.defaultTheme,
      home: const AuthGate(),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.status == AuthStatus.unknown) {
      return const CustomLoading();
    }

    if (auth.status == AuthStatus.unauthenticated) {
      return const LoginScreen();
    }

    if (!auth.hasOrganization) {
      return const SetupScreen();
    }

    return const MainScreen();
  }
}