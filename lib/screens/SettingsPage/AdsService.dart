import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialization;
  AdState(this.initialization);
  String get rewardedad => Platform.isAndroid
      ? "ca-app-pub-1433006549087304~2238616181"
      : "To implement for ios";
}
