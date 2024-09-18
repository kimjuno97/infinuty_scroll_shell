import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_scroll_shell/infinity_scroll_shell.dart';

void main() {
  testWidgets(
    'InfinityScrollShell displays',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: InfinityScrollShell(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 100,
              itemBuilder: (context, index) =>
                  ListTile(title: Text('Item $index')),
            ),
          ),
        ),
      );

      // Verify that the child ListView is rendered
      expect(find.byType(InfinityScrollShell), findsOneWidget);
      expect(find.text('Item 0'), findsOneWidget);
    },
  );
}
