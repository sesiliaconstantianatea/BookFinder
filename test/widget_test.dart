
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:book_finder/main.dart';

void main() {
  testWidgets('EmptyBookMessage menampilkan pesan selamat datang',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyBookMessage(),
        ),
      ),
    );

    expect(
      find.text('Selamat Datang di BookFinder!'),
      findsOneWidget,
    );
  });
}
