import 'dart:developer';
import 'dart:io';

import 'package:dondi/utils/const.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsController extends GetxController{
  dynamic banner;
  void getBannerAd() {
    log("hmm $banner");
    bannerAd((ad) {
      log("hmm1 $banner");
      banner = ad as BannerAd;
    });
  }
   void bannerAd(Function(Ad ad) ad) {
    BannerAd(
      adUnitId: Platform.isIOS
          ? "${SettingRes.admobBannerIos}"
          : "${SettingRes.admobBanner}",
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: ad,
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }
}