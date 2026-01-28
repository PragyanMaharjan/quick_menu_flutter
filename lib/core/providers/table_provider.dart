
import 'package:flutter_riverpod/legacy.dart';

/// Provider to manage the current table ID after QR code scanning
/// This stores the table ID extracted from the QR code and persists it
/// throughout the user session until logout
final tableIdProvider = StateProvider<String?>((ref) {
  return null; // Initially null until a QR code is scanned
});

/// Provider to manage loading state during QR scanning and processing
final qrScanLoadingProvider = StateProvider<bool>((ref) {
  return false;
});

/// Provider to manage error messages during QR scanning
final qrScanErrorProvider = StateProvider<String?>((ref) {
  return null;
});
