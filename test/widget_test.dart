// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_gorouter_providerscope/main.dart';
import 'package:riverpod_gorouter_providerscope/providers.dart';

String getIdentifier(WidgetTester tester) {
  Text text = tester.firstWidget(find.byKey(keyIdentifier));
  final identifier = text.data ?? "";
  return identifier;
}

void main() {
  testWidgets('bug page', (WidgetTester tester) async {
    final container = ProviderContainer();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    // navigate to page with bug
    await tester.tap(find.text("bug"));
    await tester.pumpAndSettle();

    final identifier = getIdentifier(tester);

    // trigger a refresh of GoRouter
    container.read(refreshProvider).refresh();
    await tester.pumpAndSettle();

    // the identifier rendered on screen should not change after a refresh
    expect(identifier, equals(getIdentifier(tester)));
  });

  testWidgets('no bug page', (WidgetTester tester) async {
    final container = ProviderContainer();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    // navigate to next page
    await tester.tap(find.text("no bug"));
    await tester.pumpAndSettle();

    expect(find.byKey(keyIdentifier), findsOneWidget);

    Text text = tester.firstWidget(find.byKey(keyIdentifier));
    final identifier = text.data ?? "";

    container.read(refreshProvider).refresh();

    await tester.pumpAndSettle();

    expect(find.text(identifier), findsOneWidget);
  });
}
