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

  /// Shake threshold (gForce) - typically 2.4 for normal shakes
  final double shakeThreshold;

  /// Threshold for change in gForce (delta) between readings
  /// Typically 0.5 to 1.0 - detects rapid acceleration changes
  final double gForceDeltaThreshold;

  /// Minimum number of shakes required to trigger callback
  final int minimumShakeCount;

  /// Time window for counting shakes (in milliseconds, typically 800ms)
  final int shakeWindowMs;

  /// Cooldown period after successful detection (in seconds)
  /// Lower value = more responsive, higher value = fewer false positives
  final int cooldownSeconds;

  // Private state
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  DateTime? _lastShakeTime;
  int _shakeCount = 0;
  DateTime? _firstShakeTime;
  double _lastGForce = 0.0;

  ShakeService({
    required this.onShakeDetected,
    this.shakeThreshold = 2.4, // Optimal: ~2.4 gForce for normal shake
    this.gForceDeltaThreshold = 0.7, // Optimal: 0.5-1.0 for delta detection
    this.minimumShakeCount = 2, // Number of shakes to detect
    this.shakeWindowMs = 800, // Optimal: ~800ms time window
    this.cooldownSeconds = 1, // Optimal: ~1 second cooldown
  }) {
    assert(
      shakeThreshold >= 1.5 && shakeThreshold <= 3.5,
      'Shake threshold must be between 1.5 and 3.5 gForce',
    );
    assert(
      gForceDeltaThreshold >= 0.3 && gForceDeltaThreshold <= 2.0,
      'gForce delta threshold must be between 0.3 and 2.0',
    );
    assert(minimumShakeCount >= 1, 'Minimum shake count must be at least 1');
    assert(
      shakeWindowMs >= 500 && shakeWindowMs <= 1000,
      'Shake window must be between 500-1000ms',
    );
    assert(
      cooldownSeconds >= 0 && cooldownSeconds <= 5,
      'Cooldown must be between 0-5 seconds',
    );
  }

  /// Start listening to accelerometer events
  void startListening() {
    _lastShakeTime = DateTime.now();
    _accelerometerSubscription =
        accelerometerEventStream(
          samplingPeriod: SensorInterval.uiInterval,
        ).listen(
          _handleAccelerometerEvent,
          onError: (e) {
            print('❌ ShakeService: Accelerometer error - $e');
          },
        );
    print('🔔 ShakeService: Started listening for shake gestures');
    print(
      '🔔 ShakeService Configuration:'
      '\n  • gForce Threshold: $shakeThreshold'
      '\n  • gForce Delta Threshold: $gForceDeltaThreshold'
      '\n  • Minimum Shakes: $minimumShakeCount'
      '\n  • Time Window: ${shakeWindowMs}ms'
      '\n  • Cooldown: ${cooldownSeconds}s',
    );
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

    // Debug: Print gForce values periodically (every second)
    if (DateTime.now().millisecondsSinceEpoch % 1000 < 100) {
      print(
        '📊 gForce: ${gForce.toStringAsFixed(2)} | Delta: ${gForceDelta.toStringAsFixed(2)} | Thresholds: gF=$shakeThreshold, Δ=$gForceDeltaThreshold | Count: $_shakeCount/$minimumShakeCount',
      );
    }

    // Check both gForce absolute value AND the delta for more reliable detection
    // This prevents false positives from slow movements
    if (gForce > shakeThreshold && gForceDelta > gForceDeltaThreshold) {
      // Reset shake count if time window expired
      if (_firstShakeTime == null ||
          now.difference(_firstShakeTime!).inMilliseconds > shakeWindowMs) {
        _shakeCount = 0;
        _firstShakeTime = now;
        print('🔔 ShakeService: Shake window reset');
      }

      _shakeCount++;
      print(
        '🔔 ShakeService: Shake detected ($_shakeCount/$minimumShakeCount) - gForce: ${gForce.toStringAsFixed(2)}, Delta: ${gForceDelta.toStringAsFixed(2)}',
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
