import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dondi/model/category_explorer.dart';
import 'package:dondi/utils/my_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../api/api_service.dart';
import '../../utils/assert_image.dart';
import '../../utils/common_fun.dart';
import '../../utils/const.dart';
import '../../utils/session_manager.dart';
import '../../widget/data_not_found.dart';
import '../live_stream/screen/live_stream_screen.dart';
import '../login/dialog_login.dart';
import '../qrcode/scan_qr_code_screen.dart';
import '../search/search_screen.dart';
import 'package:get/get.dart';

import 'item_explore.dart';
class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int start = 0;

  var _streamController = StreamController<List<ExplorerCategory>?>();
  ScrollController _scrollController = ScrollController();

  List<ExplorerCategory> exploreList = [];

  final controller=Get.put(MyLoading());

  bool isLoading = true;
  @override
  void dispose() {
    super.dispose();
    _anchoredAdaptiveAd?.dispose();
  }
  @override
  void initState() {

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (!isLoading) {
          isLoading = true;
          callApiExploreHashTag();
        }
      }
    });
    callApiExploreHashTag();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          statusBarIconBrightness: Platform.isAndroid?Brightness.light:Brightness.dark,
          statusBarBrightness: Platform.isAndroid?Brightness.light:Brightness.dark,
          statusBarColor: Colors.black
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchScreen(),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        height: 45,
                        decoration: const BoxDecoration(
                          color: Color(0xFF262626),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Search',
                              style: TextStyle(
                                color: colorTextLight,
                                fontSize: 15,
                              ),
                            ),
                            Image(
                              height: 20,
                              image: AssetImage(icSearch),
                              color: colorTextLight,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (SessionManager.userId == -1) {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ),
                          ),
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return DialogLogin();
                          },
                        ).then(
                          (value) =>
                              controller
                                  .setSelectedItem(1),
                        );
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LiveStreamScreen(),),
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xFFFF5722),
                              Color(0xFFFF5722).withOpacity(0.5),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30)),
                      child: Row(
                        children: [
                          Image.asset(
                            liveRound,
                            height: 20,
                            width: 20,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Lives'.toUpperCase(),
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.white,),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScanQrCodeScreen(),
                      ),
                    ),
                    child: Image(
                      height: 20,
                      image: AssetImage(icQrCode),
                      color: colorTextLight,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: _streamController.stream,
                  builder: (context, snapshot) {
                    List<ExplorerCategory>? userVideo = [];
                    if (snapshot.data != null) {
                      userVideo = (snapshot.data as List<ExplorerCategory>?)!;
                      exploreList.addAll(userVideo);
                    }
                    return exploreList.isEmpty
                        ? DataNotFound():
                    GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1 / 0.65,
                      ),
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      children:  List.generate(exploreList.length,
                              (index) => ItemExplore(exploreList[index])),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              _getAdWidget(),
              // if (bannerAd != null)
              //   Container(
              //     alignment: Alignment.center,
              //     child: AdWidget(ad: bannerAd!),
              //     width: bannerAd?.size.width.toDouble(),
              //     height: bannerAd?.size.height.toDouble(),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;
  late Orientation _currentOrientation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentOrientation = MediaQuery.of(context).orientation;
    _loadAd();
  }

  /// Load another ad, disposing of the current ad if there is one.
  Future<void> _loadAd() async {
    await _anchoredAdaptiveAd?.dispose();
    setState(() {
      _anchoredAdaptiveAd = null;
      _isLoaded = false;
    });

    final AnchoredAdaptiveBannerAdSize? size =
    await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    _anchoredAdaptiveAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716',
      size: size,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$ad loaded: ${ad.responseInfo}');
          setState(() {
            // When the ad is loaded, get the ad size and use it to set
            // the height of the ad container.
            _anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Anchored adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
    return _anchoredAdaptiveAd!.load();
  }

  /// Gets a widget containing the ad, if one is loaded.
  ///
  /// Returns an empty container if no ad is loaded, or the orientation
  /// has changed. Also loads a new ad if the orientation changes.
  Widget _getAdWidget() {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (_currentOrientation == orientation &&
            _anchoredAdaptiveAd != null &&
            _isLoaded) {
          return Container(
            color: Colors.green,
            width: _anchoredAdaptiveAd!.size.width.toDouble(),
            height: _anchoredAdaptiveAd!.size.height.toDouble(),
            child: AdWidget(ad: _anchoredAdaptiveAd!),
          );
        }
        // Reload the ad if the orientation changes.
        if (_currentOrientation != orientation) {
          _currentOrientation = orientation;
          _loadAd();
        }
        return Container();
      },
    );
  }

  BannerAd? bannerAd;
//Use RequestConfiguration.Builder().setTestDeviceIds(Arrays.asList("DE992FA119FEA50941F99886890F7195")) to get test ads on this device.
//   void getBannerAd() {
//     log("hmm $bannerAd");
//     CommonFun.bannerAd((ad) {
//       log("hmm1 $bannerAd");
//       bannerAd = ad as BannerAd;
//       setState(() {});
//     });
//   }

  void callApiExploreHashTag() {
    ApiService()
        .getCategoryOfExplorer(start.toString(), ConstRes.count.toString())
        .then((value) {
      start += ConstRes.count;
      isLoading = false;
      _streamController.add(value.data);
    });
    // getLiveStreamUser();
  }
}
