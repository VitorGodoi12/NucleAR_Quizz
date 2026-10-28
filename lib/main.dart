import 'package:flutter/material.dart';
import 'package:nuclear_quizdefinitivo/screens/welcome_screen.dart';
import 'package:nuclear_quizdefinitivo/data/app_progress.dart';
import 'package:nuclear_quizdefinitivo/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppProgress.instance.load();
  runApp(const NucleARApp());
}

class NucleARApp extends StatelessWidget {
  const NucleARApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NucleAR Quiz',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const WelcomeScreen(),
    );
  }
}
