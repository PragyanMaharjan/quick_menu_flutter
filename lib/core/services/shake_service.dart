import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Service to detect deliberate phone shakes for calling waiter
///
/// Usage:
/// ```dart
/// _shakeService = ShakeService(
///   onShakeDetected: () => _showCallWaiterDialog(),
/// );
/// _shakeService.startListening();
/// ```
class ShakeService {
  /// Callback triggered when deliberate shake is detected
  final VoidCallback onShakeDetected;

  /// Shake threshold (2.8-3.0 for deliberate shakes only)
  final double shakeThreshold;

  /// Minimum number of shakes required to trigger
  final int minimumShakeCount;

  /// Time window for counting shakes (in milliseconds)
  final int shakeWindowMs;

  /// Cooldown period after successful detection (in seconds)
  final int cooldownSeconds;

  // Private state
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  DateTime? _lastShakeTime;
  int _shakeCount = 0;
  DateTime? _firstShakeTime;
  double _lastGForce = 0.0;

  ShakeService({
    required this.onShakeDetected,
    this.shakeThreshold = 2.9,
    this.minimumShakeCount = 2,
    this.shakeWindowMs = 750,
    this.cooldownSeconds = 3,
  }) {
    assert(
      shakeThreshold >= 2.8 && shakeThreshold <= 3.0,
      'Shake threshold must be between 2.8 and 3.0',
    );
    assert(minimumShakeCount >= 2, 'Minimum shake count must be at least 2');
    assert(
      shakeWindowMs >= 700 && shakeWindowMs <= 800,
      'Shake window must be between 700-800ms',
    );
  }

  /// Start listening to accelerometer events
  void startListening() {
    _lastShakeTime = DateTime.now();
    _accelerometerSubscription = accelerometerEventStream(
      samplingPeriod: SensorInterval.uiInterval,
    ).listen(_handleAccelerometerEvent);
    print('🔔 ShakeService: Started listening for shake gestures');
  }

  /// Stop listening to accelerometer events
  void stopListening() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
    print('🔔 ShakeService: Stopped listening');
  }

  /// Handle accelerometer events
  void _handleAccelerometerEvent(AccelerometerEvent event) {
    final now = DateTime.now();

    // Global cooldown - prevent processing during cooldown period
    if (_lastShakeTime != null &&
        now.difference(_lastShakeTime!).inSeconds < cooldownSeconds) {
      return;
    }

    // Calculate gForce properly: sqrt(x² + y² + z²) / 9.8
    final gForce = _calculateGForce(event.x, event.y, event.z);

    // Detect significant change in gForce (deliberate shake)
    final gForceDelta = (gForce - _lastGForce).abs();

    // Debug: Print gForce values periodically
    if (DateTime.now().millisecondsSinceEpoch % 1000 < 100) {
      print(
        '📊 Current gForce: ${gForce.toStringAsFixed(2)}, Delta: ${gForceDelta.toStringAsFixed(2)}, Threshold: $shakeThreshold',
      );
    }

    if (gForceDelta > shakeThreshold) {
      // Reset shake count if time window expired
      if (_firstShakeTime == null ||
          now.difference(_firstShakeTime!).inMilliseconds > shakeWindowMs) {
        _shakeCount = 0;
        _firstShakeTime = now;
        print('🔔 ShakeService: Shake window reset');
      }

      _shakeCount++;
      print(
        '🔔 ShakeService: Shake detected ($_shakeCount/$minimumShakeCount) - gForce: ${gForce.toStringAsFixed(2)}',
      );

      // Trigger callback if minimum shake count reached
      if (_shakeCount >= minimumShakeCount) {
        print(
          '✅ ShakeService: Deliberate shake confirmed! Triggering callback...',
        );
        onShakeDetected();
        _resetShakeDetection(now);
      }
    }

    _lastGForce = gForce;
  }

  /// Calculate gForce from accelerometer values
  /// Formula: sqrt(x² + y² + z²) / 9.8
  double _calculateGForce(double x, double y, double z) {
    final acceleration = sqrt(x * x + y * y + z * z);
    return acceleration / 9.8; // Convert to g-force
  }

  /// Reset shake detection state
  void _resetShakeDetection(DateTime now) {
    _lastShakeTime = now;
    _shakeCount = 0;
    _firstShakeTime = null;
    print(
      '🔔 ShakeService: Reset complete. Cooldown: $cooldownSeconds seconds',
    );
  }

  /// Dispose service and cancel subscriptions
  void dispose() {
    stopListening();
    _shakeCount = 0;
    _firstShakeTime = null;
    _lastShakeTime = null;
    print('🔔 ShakeService: Disposed');
  }
}
