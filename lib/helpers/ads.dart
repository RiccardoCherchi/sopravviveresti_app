import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';

const bool isAdsEnable = true;

String getAppId() {
  return Platform.isIOS
      ? "ca-app-pub-6180833306474768~7857468863"
      : "ca-app-pub-6180833306474768~7530165807";
}

class Ads {
  String getSopravviverestiInterstitialId() {
    return Platform.isIOS
        ? "ca-app-pub-6180833306474768/2470438483"
        : "ca-app-pub-6180833306474768/8460104099";
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: isAdsEnable
          ? getSopravviverestiInterstitialId()
          : InterstitialAd.testAdUnitId,
      // adUnitId: InterstitialAd.testAdUnitId,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }
}
