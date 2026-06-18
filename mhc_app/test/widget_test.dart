import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mhc_app/main.dart';
import 'package:mhc_app/providers/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App loads home and toggles language', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final settings = AppSettings();
    await settings.load();

    await tester.pumpWidget(MhcApp(settings: settings));
    await tester.pump();

    expect(find.text('UPCOMING EVENTS'), findsOneWidget);

  final langButton = find.widgetWithText(Container, 'EN');
    await tester.tap(langButton);
    await tester.pump();
    expect(find.text('ಮುಂಬರುವ ಕಾರ್ಯಕ್ರಮಗಳು'), findsOneWidget);

    await tester.tap(find.widgetWithText(Container, 'ಕ'));
    await tester.pump();
    expect(find.text('UPCOMING EVENTS'), findsOneWidget);
  });
}
