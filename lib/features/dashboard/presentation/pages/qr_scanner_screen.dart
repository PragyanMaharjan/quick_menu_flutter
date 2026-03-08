import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quick_menu/core/providers/table_provider.dart';

class QrScannerScreen extends ConsumerStatefulWidget {
  const QrScannerScreen({super.key});

  @override
  ConsumerState<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends ConsumerState<QrScannerScreen> {
  MobileScannerController controller = MobileScannerController();
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndStart();
  }

  Future<void> _checkPermissionAndStart() async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      // Permission granted, start scanning
      setState(() => _isScanning = true);
    } else if (status.isDenied) {
      // Request permission
      final result = await Permission.camera.request();
      if (result.isGranted) {
        setState(() => _isScanning = true);
      } else if (result.isPermanentlyDenied) {
        // Permanently denied, show dialog to go to settings
        _showPermissionPermanentlyDeniedDialog();
      } else {
        // Denied, go back
        Navigator.of(context).pop();
      }
    } else if (status.isPermanentlyDenied) {
      // Permanently denied, show dialog to go to settings
      _showPermissionPermanentlyDeniedDialog();
    }
  }

  void _showPermissionPermanentlyDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Camera Permission Required'),
        content: const Text(
          'Camera permission has been permanently denied. Please go to settings to enable camera permission.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        final scannedValue = barcode.rawValue!;
        // Extract table number (assuming format like "table5")
        final tableNumber = _extractTableNumber(scannedValue);
        if (tableNumber != null) {
          _navigateToMenu(tableNumber);
        } else {
          _showInvalidQrDialog();
        }
        break; // Process only the first barcode
      }
    }
  }

  String? _extractTableNumber(String qrValue) {
    // Check if it's just a plain number (e.g., "5")
    final plainNumberRegex = RegExp(r'^\d+$');
    if (plainNumberRegex.hasMatch(qrValue.trim())) {
      return qrValue.trim();
    }

    // Assuming QR code contains something like "table5" or "Table: 5"
    final tableRegex = RegExp(r'table(\d+)', caseSensitive: false);
    final match = tableRegex.firstMatch(qrValue);
    if (match != null) {
      return match.group(1)!;
    }

    // Try another format: "Table: 5"
    final tableColonRegex = RegExp(r'Table:\s*(\d+)', caseSensitive: false);
    final colonMatch = tableColonRegex.firstMatch(qrValue);
    if (colonMatch != null) {
      return colonMatch.group(1)!;
    }

    return null;
  }

  void _navigateToMenu(String tableNumber) {
    // Stop scanning
    controller.stop();

    // Store table number in provider
    ref.read(tableIdProvider.notifier).state = tableNumber;

    // Show welcome dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) => AlertDialog(
        title: const Text('Welcome!'),
        content: Text(
          'Please be seated at Table $tableNumber until the waiter arrives.',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Close dialog and go back to dashboard
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(
                context,
              ).pop(tableNumber); // Go back to dashboard with table info
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showInvalidQrDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invalid QR Code'),
        content: const Text(
          'The scanned QR code does not contain a valid table number. Please try scanning a valid table QR code.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Table QR'),
        actions: [
          IconButton(
            onPressed: () => controller.toggleTorch(),
            icon: const Icon(Icons.flashlight_on),
          ),
          IconButton(
            onPressed: () => controller.switchCamera(),
            icon: const Icon(Icons.camera_rear),
          ),
        ],
      ),
      body: _isScanning
          ? MobileScanner(controller: controller, onDetect: _onDetect)
          : const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
