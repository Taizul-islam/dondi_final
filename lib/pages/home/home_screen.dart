import 'dart:io';
import 'dart:ui';

import 'package:dondi/pages/home/location_screen.dart';
import 'package:dondi/pages/profile/location_update_screen.dart';
import 'package:dondi/utils/my_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../model/setting.dart';
import '../../utils/assert_image.dart';
import '../../utils/const.dart';
import '../../utils/session_manager.dart';
import 'package:get/get.dart';
import '../webview/webview_screen.dart';
import 'for_u_screen.dart';
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SessionManager sessionManager = SessionManager();
  final control=Get.put(MyLoading());

  @override
  void initState() {

    //homeScreenDialog();
    //prefData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PageController controller= PageController(initialPage: 0, keepPage: true);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          statusBarIconBrightness: Platform.isAndroid?Brightness.light:Brightness.dark,
          statusBarBrightness: Platform.isAndroid?Brightness.light:Brightness.dark,
          statusBarColor: Colors.black
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PageView(
              physics: BouncingScrollPhysics(),
              controller: controller,
              children: [
                LocationScreen(),
                //FollowingScreen(),
                ForYouScreen(),
              ],
              onPageChanged: (value) {
                control.setIsForYouSelected(value);
              },
            ),
            GetBuilder<MyLoading>(
              builder: (con) {
                return Padding(
                  padding: EdgeInsets.only(top: 55),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                        onTap: () {
                          controller.animateToPage(0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInToLinear);
                        },
                        child: Text(
                          "Location",
                          style: TextStyle(
                            fontSize: 18,
                            color: con.selectedHomeScreen.value==0 ? Colors.white : Colors.white.withOpacity(0.7),
                            shadows: [
                              Shadow(
                                offset: Offset(0.5, 0.5),
                                color: con.selectedHomeScreen.value==0 ? Colors.black54 : Colors.transparent,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Container(
                      //   margin: EdgeInsets.symmetric(horizontal: 15),
                      //   height: 25,
                      //   width: 2,
                      //   color: Color(0xFFFF5722),
                      // ),
                      // InkWell(
                      //   focusColor: Colors.transparent,
                      //   hoverColor: Colors.transparent,
                      //   highlightColor: Colors.transparent,
                      //   overlayColor: MaterialStateProperty.all(Colors.transparent),
                      //   onTap: () {
                      //     controller.animateToPage(1,
                      //         duration: Duration(milliseconds: 500),
                      //         curve: Curves.easeInToLinear);
                      //   },
                      //   child: Text(
                      //     "Following",
                      //     style: TextStyle(
                      //       fontSize: 18,
                      //
                      //       color: con.selectedHomeScreen.value==1 ? Colors.white : colorTextLight,
                      //       shadows: [
                      //         Shadow(offset: Offset(1, 1), color: con.selectedHomeScreen.value==1 ? Colors.black54 : Colors.transparent, blurRadius: 5,),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        height: 25,
                        width: 2,
                        color: Color(0xFFFF5722),
                      ),
                      InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                        onTap: () {
                          controller.animateToPage(1,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInToLinear);
                        },
                        child: Text(
                          "For You",
                          style: TextStyle(
                            fontSize: 18,
                            color: con.selectedHomeScreen.value==1 ? Colors.white : Colors.white.withOpacity(0.7),
                            shadows: [
                              Shadow(offset: const Offset(1, 1), color: con.selectedHomeScreen.value==1 ? Colors.black54 : Colors.transparent, blurRadius: 5,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> homeScreenDialog() async {
    await Future.delayed(Duration.zero);
    control.isHomeDialogOpen.isTrue
        ? showDialog(
            context: context,
            builder: (context) {
              return WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Dialog(
                    insetPadding: EdgeInsets.symmetric(horizontal: 55),
                    backgroundColor: Colors.transparent,
                    child: AspectRatio(
                      aspectRatio: 1 / 1.2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorPrimaryDark,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            Spacer(),
                            Text(
                              'Please Accept',
                              style: TextStyle(
                                fontSize: 20,
                                decoration: TextDecoration.none,
                                color: Colors.white,
                              ),
                            ),
                            Spacer(),
                            Image(
                              image: AssetImage(icLogo),
                              height: 70,
                            ),
                            Spacer(),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                'Please check these Privacy Policy and Terms Of Use before using the app and accept it.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  decoration: TextDecoration.none,
                                  color: colorTextLight,
                                ),
                              ),
                            ),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewScreen(2),));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      'Terms & Conditions',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        decoration: TextDecoration.none,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  width: 2,
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewScreen(3),));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      'Privacy Policy',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        decoration: TextDecoration.none,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            InkWell(
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              overlayColor: MaterialStateProperty.all(Colors.transparent),
                              onTap: () {
                                control.setIsHomeDialogOpen(false);
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  color: colorPrimary,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20)),
                                ),
                                child: Center(
                                  child: Text(
                                    'Accept',
                                    style: TextStyle(
                                      fontSize: 14,
                                      decoration: TextDecoration.none,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            barrierDismissible: true)
        : SizedBox();
  }

  void prefData() async {
    await sessionManager.initPref();
    Setting? setting = sessionManager.getSetting();
    SettingRes.admobBanner = setting?.data?.admobBanner;
    SettingRes.admobInt = setting?.data?.admobInt;
    SettingRes.admobIntIos = setting?.data?.admobIntIos;
    SettingRes.admobBannerIos = setting?.data?.admobBannerIos;
    SettingRes.maxUploadDaily = setting?.data?.maxUploadDaily;
    SettingRes.liveMinViewers = setting?.data?.liveMinViewers;
    SettingRes.liveTimeout = setting?.data?.liveTimeout;
    SettingRes.rewardVideoUpload = setting?.data?.rewardVideoUpload;
    SettingRes.minFansForLive = setting?.data?.minFansForLive;
    SettingRes.minFansVerification = setting?.data?.minFansVerification;
    SettingRes.minRedeemCoins = setting?.data?.minRedeemCoins;
    SettingRes.coinValue = setting?.data?.coinValue;
    SettingRes.currency = setting?.data?.currency;
    SettingRes.agoraAppId = setting?.data?.agoraAppId;
    SettingRes.gifts = setting?.data?.gifts;
  }
}
