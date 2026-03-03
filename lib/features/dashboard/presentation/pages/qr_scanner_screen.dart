import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
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
    // Assuming QR code contains something like "table5" or "Table: 5"
    final tableRegex = RegExp(r'table(\d+)', caseSensitive: false);
    final match = tableRegex.firstMatch(qrValue);
    if (match != null) {
      return 'Table ${match.group(1)}';
    }

    // Try another format: "Table: 5"
    final tableColonRegex = RegExp(r'Table:\s*(\d+)', caseSensitive: false);
    final colonMatch = tableColonRegex.firstMatch(qrValue);
    if (colonMatch != null) {
      return 'Table ${colonMatch.group(1)}';
    }

    return null;
  }

  void _navigateToMenu(String tableNumber) {
    // Stop scanning
    controller.stop();

    // Show confirmation dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) => AlertDialog(
        title: const Text('Confirm Table'),
        content: Text('Are you in $tableNumber?'),
        actions: [
          TextButton(
            onPressed: () {
              // No - close dialog and restart scanning
              Navigator.of(context).pop(); // Close dialog
              controller.start(); // Restart scanning
              setState(() => _isScanning = true);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              // Yes - close dialog and navigate to dashboard
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(
                context,
              ).pop(tableNumber); // Go back to dashboard with table info
            },
            child: const Text('Yes'),
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
