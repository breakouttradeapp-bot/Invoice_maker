import 'package:google_mobile_ads/google_mobile_ads.dart';

class ConsentManager {
  static bool _canRequestAds = true;

  static Future<void> initialize() async {
    // Simplified initialization for google_mobile_ads ^4.0.0
    // UMP API removed due to compatibility issues.
    _canRequestAds = true;
  }

  static Future<bool> canRequestAds() async {
    return _canRequestAds;
  }

  /// Reset for testing
  static Future<void> resetForTesting() async {
    // No-op for now
  }
}
