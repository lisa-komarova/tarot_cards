import 'dart:io';

///contains banner and interstitial ads
class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4619302983577718/5949942744';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-4619302983577718/5949942744';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-4619302983577718/1100068604";
    } else if (Platform.isIOS) {
      return "ca-app-pub-4619302983577718/1100068604";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
