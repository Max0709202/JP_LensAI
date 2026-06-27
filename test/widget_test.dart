import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japan_lens_ai/app.dart';

void main() {
  testWidgets('home screen shows MVP features', (tester) async {
    await tester.pumpWidget(const JapanLensAiApp());

    expect(find.text('Japan Lens AI'), findsOneWidget);
    expect(find.text('Point your camera. Understand Japan.'), findsOneWidget);
    expect(find.text('Scan Japanese Sign'), findsOneWidget);
    expect(find.text('Menu Helper'), findsOneWidget);
    expect(find.text('Emergency Phrases'), findsOneWidget);
    expect(find.text('Etiquette Q&A'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Saved Phrases'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Saved Phrases'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('settings screen opens from home', (tester) async {
    await tester.pumpWidget(const JapanLensAiApp());

    await tester.scrollUntilVisible(
      find.text('Settings'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsWidgets);
    expect(find.text('Mock mode active'), findsOneWidget);
  });
}
