import 'package:app/components/chem_tile.dart';
import 'package:app/scanner/scannerapp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/menupage.dart';

void main() {
  testWidgets('Menupage widget test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: Menupage(),
    ));

    // Verify that Menupage has a title.
    expect(find.text('Scanner'), findsOneWidget);

    // Verify that the scan button is present.
    expect(find.text('Scan'), findsOneWidget);

    // Tap on the scan button and verify navigation.
    await tester.tap(find.text('Scan'));
    await tester.pumpAndSettle(); // Wait for the navigation to complete.
    expect(find.byType(App), findsOneWidget); // Check if App screen is displayed after navigation.
    
    // Verify that Chemicals section is present.
    expect(find.text('Chemicals'), findsOneWidget);

    // Verify that Chemical tiles are present.
    expect(find.byType(ChemTile), findsNWidgets(3)); // Assuming there are 3 chemical tiles in the list.

    // Verify that the Prediction section is present.
    expect(find.text('Prediction'), findsOneWidget);

    // Verify that the Go button is present.
    expect(find.text('Go'), findsOneWidget);
  });
}
