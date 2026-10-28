import 'package:flutter_test/flutter_test.dart';
import 'package:nuclear_quizdefinitivo/main.dart';

void main() {
  testWidgets('Tela de boas-vindas exibe os botões principais', (tester) async {
    await tester.pumpWidget(const NucleARApp());

    expect(find.text('NucleAR Quiz'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Cadastrar-se'), findsOneWidget);
  });
}
