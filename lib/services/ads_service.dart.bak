import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  // Singleton pattern
  static final AdsService _instance = AdsService._internal();
  factory AdsService() => _instance;
  AdsService._internal();

  InterstitialAd? _interstitialAd;
  int _interstitialRetryAttempt = 0;
  bool _isInterstitialLoading = false;

  // Official Test Ad Unit IDs from Google
  static String get bannerAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716';
    }
    // For production, replace with real IDs
    return Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-3940256099942544/2934735716';
  }

  static String get interstitialAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-3940256099942544/4411468910';
    }
    // For production, replace with real IDs
    return Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/1033173712'
        : 'ca-app-pub-3940256099942544/4411468910';
  }

  /// Initialize the SDK
  Future<void> init() async {
  // تهيئة Google Mobile Ads
  await MobileAds.instance.initialize();

  // 🔥 تحميل الإعلان البيني لأول مرة
  loadInterstitialAd();
}

  /// Load Interstitial Ad with Retry Logic
  void loadInterstitialAd() {
    if (_isInterstitialLoading || _interstitialAd != null) return;

    _isInterstitialLoading = true;
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('AdsService: Interstitial Ad Loaded');
          _interstitialAd = ad;
          _isInterstitialLoading = false;
          _interstitialRetryAttempt = 0;
          
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('AdsService: Interstitial Ad Dismissed');
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd(); // Load next one
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('AdsService: Interstitial Failed to Show: $error');
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('AdsService: Interstitial Failed to Load: $error');
          _isInterstitialLoading = false;
          _interstitialAd = null;
          _interstitialRetryAttempt++;
          if (_interstitialRetryAttempt <= 3) {
            Future.delayed(Duration(seconds: _interstitialRetryAttempt * 2), () {
              loadInterstitialAd();
            });
          }
        },
      ),
    );
  }

  /// Show Interstitial Ad
  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      debugPrint('AdsService: Interstitial Ad not ready, loading now...');
      loadInterstitialAd();
    }
  }

  /// Dispose Resources
  void dispose() {
    _interstitialAd?.dispose();
  }
}
