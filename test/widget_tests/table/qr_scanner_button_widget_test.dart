import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QR Scanner Button Widget Tests', () {
    testWidgets('should display scan button', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: QRScannerButton())),
      );

      // Assert
      expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
      expect(find.text('Scan Table QR'), findsOneWidget);
    });

    testWidgets('should call onScan when button is tapped', (tester) async {
      // Arrange
      bool wasScanCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QRScannerButton(onScan: () => wasScanCalled = true),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Scan Table QR'));
      await tester.pumpAndSettle();

      // Assert
      expect(wasScanCalled, true);
    });

    testWidgets('should show loading indicator when scanning', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: QRScannerButton())),
      );

      // Act - tap to start scanning
      await tester.tap(find.text('Scan Table QR'));
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for scanning to complete
      await tester.pumpAndSettle();
    });

    testWidgets('should display table info after successful scan', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: QRScannerButton(onScanSuccess: (tableId) {})),
        ),
      );

      // Act
      await tester.tap(find.text('Scan Table QR'));
      await tester.pumpAndSettle(); // Wait for scan completion

      // Assert
      expect(find.textContaining('Table'), findsWidgets);
    });
  });
}

// Mock widget
class QRScannerButton extends StatefulWidget {
  final VoidCallback? onScan;
  final Function(String)? onScanSuccess;

  const QRScannerButton({Key? key, this.onScan, this.onScanSuccess})
    : super(key: key);

  @override
  State<QRScannerButton> createState() => _QRScannerButtonState();
}

class _QRScannerButtonState extends State<QRScannerButton> {
  bool _isScanning = false;
  String? _scannedTableId;

  Future<void> _handleScan() async {
    widget.onScan?.call();

    setState(() {
      _isScanning = true;
    });

    // Simulate scanning
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isScanning = false;
      _scannedTableId = 'TABLE_001';
    });

    widget.onScanSuccess?.call(_scannedTableId!);
  }

  @override
  Widget build(BuildContext context) {
    if (_scannedTableId != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 48),
              const SizedBox(height: 8),
              Text('Table: $_scannedTableId'),
            ],
          ),
        ),
      );
    }

    if (_isScanning) {
      return const Center(child: CircularProgressIndicator());
    }

    return ElevatedButton.icon(
      onPressed: _handleScan,
      icon: const Icon(Icons.qr_code_scanner),
      label: const Text('Scan Table QR'),
    );
  }
}
