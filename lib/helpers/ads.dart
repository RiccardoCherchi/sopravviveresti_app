import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';

String getAppId() {
  return Platform.isIOS
      ? "ca-app-pub-2044040104930184~5731156528"
      : "ca-app-pub-2044040104930184~9321248870";
}

class Ads {
  String getSopravviverestiInterstitialId() {
    return Platform.isIOS
        ? "ca-app-pub-2044040104930184/8928165502"
        : "ca-app-pub-2044040104930184/4605777118";
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: getSopravviverestiInterstitialId(),
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }
}
