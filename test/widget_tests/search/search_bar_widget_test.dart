import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Search Bar Widget Tests', () {
    testWidgets('should display search text field', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SearchBarWidget())),
      );

      // Assert
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should call onSearch when text is entered', (tester) async {
      // Arrange
      String? searchQuery;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(onSearch: (query) => searchQuery = query),
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextField), 'pizza');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      // Assert
      expect(searchQuery, 'pizza');
    });

    testWidgets('should show clear button when text is entered', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SearchBarWidget())),
      );

      // Assert - initially no clear button
      expect(find.byIcon(Icons.clear), findsNothing);

      // Act
      await tester.enterText(find.byType(TextField), 'burger');
      await tester.pump();

      // Assert - clear button appears
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('should clear text when clear button is tapped', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SearchBarWidget())),
      );

      // Act
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      // Assert
      expect(find.text('test'), findsNothing);
    });
  });
}

// Mock widget
class SearchBarWidget extends StatefulWidget {
  final Function(String)? onSearch;

  const SearchBarWidget({Key? key, this.onSearch}) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSearch() {
    widget.onSearch?.call(_controller.text);
  }

  void _clearSearch() {
    setState(() {
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onSubmitted: (value) => _handleSearch(),
      decoration: InputDecoration(
        hintText: 'Search...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(icon: const Icon(Icons.clear), onPressed: _clearSearch)
            : null,
      ),
      onChanged: (value) => setState(() {}),
    );
  }
}
