import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icon/flutter_icon.dart';

void main() {
  testWidgets('MorphSidebarTabBarIcon renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: MorphSidebarTabBarIcon(),
          ),
        ),
      ),
    );

    expect(find.byType(MorphSidebarTabBarIcon), findsOneWidget);
  });
}
