import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nuclear_quizdefinitivo/routes/app_routes.dart';
import 'package:nuclear_quizdefinitivo/data/competition_catalog.dart';
import 'package:nuclear_quizdefinitivo/data/app_progress.dart';
import 'package:nuclear_quizdefinitivo/theme/app_theme.dart';
import 'package:nuclear_quizdefinitivo/screens/home_screen.dart';
import 'package:nuclear_quizdefinitivo/screens/login_screen.dart';
import 'package:nuclear_quizdefinitivo/screens/register_screen.dart';
import 'package:nuclear_quizdefinitivo/screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final progress = AppProgress();
  await progress.load();
  final catalog = await CompetitionCatalog.load();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProgress>.value(value: progress),
        Provider<CompetitionCatalog>.value(value: catalog),
      ],
      child: NucleARApp(initialRoute: progress.displayName.trim().isEmpty ? AppRoutes.welcome : AppRoutes.home),
    ),
  );
}

class NucleARApp extends StatelessWidget {
  const NucleARApp({super.key, required this.initialRoute});
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NucleAR Quiz',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: initialRoute == AppRoutes.home
          ? HomeScreen(userName: context.read<AppProgress>().displayName)
          : const WelcomeScreen(),
      routes: {
        AppRoutes.welcome: (_) => const WelcomeScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.home: (_) => HomeScreen(userName: context.read<AppProgress>().displayName),
      },
      onGenerateRoute: AppRoutes.onGenerate,
      themeMode: context.watch<AppProgress>().selectedThemeMode,
    );
  }
}
