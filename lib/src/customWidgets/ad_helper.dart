import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialization;
  AdState(this.initialization);
  String get homeBannerAd => Platform.isAndroid
      ? "ca-app-pub-1433006549087304/2896318627"
      : "To implement for ios";

  String interstitialAdUnitId = Platform.isAndroid
      ? "ca-app-pub-1433006549087304/8449766315"
      : "To implement for ios";

  BannerAdListener get bannerAdListener => _bannerAdListener;

  BannerAdListener _bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => print('Ad loaded: ${ad.adUnitId} '),
    onAdClosed: (ad) => print('Ad closed: ${ad.adUnitId} '),
    onAdFailedToLoad: (ad, error) {
      print('Ad failed to load ${ad.adUnitId}, $error ');
      ad.dispose();
    },
    onAdOpened: (ad) => print('Ad opened: ${ad.adUnitId} '),
  );
}
