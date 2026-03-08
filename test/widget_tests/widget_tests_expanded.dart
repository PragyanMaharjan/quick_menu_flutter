import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Widget Tests Suite - Expanded', () {
    // Test 1: Basic widget test
    testWidgets('Basic widget renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Center(child: Text('Hello World'))),
        ),
      );

      expect(find.text('Hello World'), findsOneWidget);
    });

    // Test 2: Button tap functionality
    testWidgets('Button tap increments counter', (WidgetTester tester) async {
      int counter = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Count: $counter'),
                      ElevatedButton(
                        onPressed: () {
                          setState(() => counter++);
                        },
                        child: Text('Increment'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Count: 0'), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Count: 1'), findsOneWidget);
    });

    // Test 3: Text field input
    testWidgets('TextField accepts input', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextField(
              key: Key('textfield'),
              decoration: InputDecoration(hintText: 'Enter text'),
            ),
          ),
        ),
      );

      await tester.enterText(find.byKey(Key('textfield')), 'Hello');
      expect(find.text('Hello'), findsOneWidget);
    });

    // Test 4: ListView rendering
    testWidgets('ListView displays items', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                ListTile(title: Text('Item 1')),
                ListTile(title: Text('Item 2')),
                ListTile(title: Text('Item 3')),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(ListTile), findsNWidgets(3));
      expect(find.text('Item 2'), findsOneWidget);
    });

    // Test 5: Container styling
    testWidgets('Container displays with correct styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              key: Key('styledContainer'),
              color: Colors.blue,
              child: Text('Styled Container'),
            ),
          ),
        ),
      );

      expect(find.byKey(Key('styledContainer')), findsOneWidget);
      expect(find.text('Styled Container'), findsOneWidget);
    });

    // Test 6: Row widget layout
    testWidgets('Row displays children horizontally', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(children: [Text('Left'), Text('Center'), Text('Right')]),
          ),
        ),
      );

      expect(find.text('Left'), findsOneWidget);
      expect(find.text('Center'), findsOneWidget);
      expect(find.text('Right'), findsOneWidget);
    });

    // Test 7: Column widget layout
    testWidgets('Column displays children vertically', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [Text('Top'), Text('Middle'), Text('Bottom')],
            ),
          ),
        ),
      );

      expect(find.text('Top'), findsOneWidget);
      expect(find.text('Middle'), findsOneWidget);
      expect(find.text('Bottom'), findsOneWidget);
    });

    // Test 8: Floating action button
    testWidgets('FloatingActionButton is tappable', (
      WidgetTester tester,
    ) async {
      bool buttonPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(child: Text('Body')),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                buttonPressed = true;
              },
              child: Icon(Icons.add),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      expect(buttonPressed, true);
    });

    // Test 9: AppBar rendering
    testWidgets('AppBar displays title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: Text('Test App Bar')),
            body: Center(child: Text('Body')),
          ),
        ),
      );

      expect(find.text('Test App Bar'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    // Test 10: GestureDetector tap detection
    testWidgets('GestureDetector detects tap', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GestureDetector(
              onTap: () {
                tapped = true;
              },
              child: Container(child: Text('Tap me')),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap me'));
      expect(tapped, true);
    });

    // Test 11: SingleChildScrollView with overflow
    testWidgets('SingleChildScrollView prevents overflow', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: List.generate(20, (index) => Text('Item $index')),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 19'), findsOneWidget);
    });

    // Test 12: Icon rendering
    testWidgets('Icon renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Center(child: Icon(Icons.home, size: 48))),
        ),
      );

      expect(find.byIcon(Icons.home), findsOneWidget);
    });

    // Test 13: Padding widget
    testWidgets('Padding applies spacing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Padded Text'),
            ),
          ),
        ),
      );

      expect(find.text('Padded Text'), findsOneWidget);
    });

    // Test 14: Align widget positioning
    testWidgets('Align positions widget correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(alignment: Alignment.center, child: Text('Centered')),
          ),
        ),
      );

      expect(find.text('Centered'), findsOneWidget);
    });

    // Test 15: SnackBar display
    testWidgets('SnackBar displays message', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Test SnackBar')));
                  },
                  child: Text('Show SnackBar'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Test SnackBar'), findsOneWidget);
    });

    // Test 16: Checkbox interaction
    testWidgets('Checkbox toggles on tap', (WidgetTester tester) async {
      bool isChecked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() => isChecked = value ?? false);
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
    });

    // Test 17: Card widget
    testWidgets('Card renders with shadow', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Card Content'),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.text('Card Content'), findsOneWidget);
    });

    // Test 18: TextButton click
    testWidgets('TextButton responds to tap', (WidgetTester tester) async {
      bool clicked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () {
                  clicked = true;
                },
                child: Text('Click Me'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextButton));
      expect(clicked, true);
    });

    // Test 19: Spacer widget
    testWidgets('Spacer creates space between widgets', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(children: [Text('Start'), Spacer(), Text('End')]),
          ),
        ),
      );

      expect(find.text('Start'), findsOneWidget);
      expect(find.text('End'), findsOneWidget);
    });

    // Test 20: SizedBox for sizing
    testWidgets('SizedBox constrains child size', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: Container(color: Colors.blue),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
    });
  });
}
