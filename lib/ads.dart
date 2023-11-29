import 'package:dondi/utils/common_fun.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Ads extends StatefulWidget {
  const Ads({Key? key}) : super(key: key);

  @override
  State<Ads> createState() => _AdsState();
}

class _AdsState extends State<Ads> {
  BannerAd? bannerAd;

  void getBannerAd() async{
    await MobileAds.instance.initialize();
    var list=['931E51213F2888018E89ED2BBCCBA8BC'];
    RequestConfiguration configuration =
    RequestConfiguration(testDeviceIds: list);
    MobileAds.instance.updateRequestConfiguration(configuration);
    CommonFun.bannerAd((ad) {
      bannerAd = ad as BannerAd;
      setState(() {});
    });
  }
  @override
  void initState() {
    getBannerAd();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          child: AdWidget(ad: bannerAd!),
          width: bannerAd?.size.width.toDouble(),
          height: bannerAd?.size.height.toDouble(),
        ),
      ),
    );
  }
}
