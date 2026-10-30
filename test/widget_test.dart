import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuclear_quizdefinitivo/screens/welcome_screen.dart';
import 'package:nuclear_quizdefinitivo/theme/app_theme.dart';

void main() {
  testWidgets('Tela de boas-vindas exibe os botões principais', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const WelcomeScreen(),
      ),
    );

    expect(find.text('NucleAR Quiz'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Cadastrar-se'), findsOneWidget);
  });
}
