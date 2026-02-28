import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../core/constants/app_constants.dart';

class AdMobService {
  static BannerAd? _bannerAd;
  static InterstitialAd? _interstitialAd;
  static bool _interstitialShownThisSession = false;

  static void initialize() {
    _loadInterstitialAd();
  }

  // ── BANNER AD ──────────────────────────────────────────────
  static BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: AppConstants.bannerAdId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
  }

  // ── INTERSTITIAL AD ────────────────────────────────────────
  static void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AppConstants.interstitialAdId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Show interstitial – max once per session, never on preview/PDF screens
  static void showInterstitialAfterInvoiceCreation() {
    if (_interstitialShownThisSession) return;
    if (_interstitialAd == null) return;

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitialAd(); // preload for next time
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitialAd();
      },
    );

    _interstitialAd!.show();
    _interstitialShownThisSession = true;
  }

  static void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
  }
}
