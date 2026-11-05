import 'package:flutter_test/flutter_test.dart';
import 'package:lords_mobile_assistant/main.dart';

void main() {
  testWidgets('mostra o painel e os quatro módulos', (tester) async {
    await tester.pumpWidget(const LordsAssistantApp());
    await tester.pumpAndSettle();
    expect(find.text('LORDS ASSISTANT'), findsOneWidget);
    expect(find.text('Temporizadores'), findsOneWidget);
    expect(find.text('Recursos'), findsOneWidget);
    expect(find.text('Escudos'), findsOneWidget);
    expect(find.text('Calendário'), findsOneWidget);
  });
}
