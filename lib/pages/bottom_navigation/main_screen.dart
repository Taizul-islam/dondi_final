import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:dondi/ads_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../api/api_service.dart';
import '../../location_service/location_service.dart';
import '../../model/user_video.dart';
import '../../utils/common_fun.dart';
import '../../utils/const.dart';
import '../../utils/my_loading.dart';
import '../../utils/session_manager.dart';
import '../../widget/dialog/loader_dialog.dart';
import '../camera/camera_screen.dart';
import '../explore/explore_screen.dart';
import '../home/home_screen.dart';
import '../login/dialog_login.dart';
import '../notification/notifiation_screen.dart';
import '../profile/proifle_screen.dart';
import '../video/video_list_screen.dart';
import 'package:get/get.dart';
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> mListOfWidget = [
    HomeScreen(),
    ExploreScreen(),
    NotificationScreen(),
    ProfileScreen(0, SessionManager.userId != null ? SessionManager.userId.toString() : ''),
  ];

  SessionManager _sessionManager = SessionManager();
  final controller=Get.put(CollectLatLngController());
  //final adsController=Get.put(AdsController());
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    //adsController.getBannerAd();
    getBannerAd();
    late final PlatformWebViewControllerCreationParams params=const PlatformWebViewControllerCreationParams();
    final WebViewController controller1 = WebViewController.fromPlatformCreationParams(params);


    controller1
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse('https://flutter.dev'));

    // #docregion platform_features

    // #enddocregion platform_features

    _controller = controller1;
    controller.getLatLng();
    //initPref();
    initPlugin();
    FlutterBranchSdk.initSession().listen((data) {
        if (data.containsKey("+clicked_branch_link") &&
            data["+clicked_branch_link"] == true) {
          if (data['post_id'] != null) {
            showDialog(
              context: context,
              builder: (context) => LoaderDialog(),
            );
            ApiService().getPostByPostId(data['post_id'].toString()).then((value) {
              List<Data> list = List<Data>.generate(1, (index) => Data.fromJson(value.data!.toJson()));
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => VideoListScreen(list: list, index: 0, type: 6)));
            });
          } else if (data['user_id'] != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(2, data['user_id'])));
          }
        }
      },
      onError: (error) {
        PlatformException platformException = error as PlatformException;
        print('initSession_error: ${platformException.code} - ${platformException.message}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GetBuilder<MyLoading>(
              builder: (controller) {
                return Stack(
                  children: [
                    mListOfWidget[controller.selectedItem.value >= 2 ? controller.selectedItem.value - 1 : controller.selectedItem.value],
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: MediaQuery.of(context).viewPadding.bottom+2,
                      child: Container(
                          height: 55,
                          padding: EdgeInsets.symmetric(horizontal:21 ),
                          decoration:  BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: const Color(0xFF262626),width: 1),
                              color: Colors.black.withOpacity(0.70)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Material(
                                color: Colors.transparent,
                                shape: const CircleBorder(),
                                child: InkWell(
                                  splashColor: Colors.white.withOpacity(0.5),
                                  onTap: () {
                                    controller.setSelectedItem(0);
                                  },
                                  customBorder: const CircleBorder(),
                                  child: Ink(
                                    padding: EdgeInsets.all(5),
                                    decoration: const BoxDecoration(shape: BoxShape.circle),
                                    height: 40,
                                    width: 40,
                                    child:  Image.asset("assets/images/home.png",height: 30,width: 30,color: controller.selectedItem.value==0?Color(0xFFFF5722):Color(0xFFFF5722).withOpacity(0.4),),
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                shape: const CircleBorder(),
                                child: InkWell(
                                  splashColor: Colors.white.withOpacity(0.5),
                                  onTap: () {
                                    controller.setSelectedItem(1);
                                  },
                                  customBorder: const CircleBorder(),
                                  child: Ink(
                                    padding: EdgeInsets.all(5),
                                    decoration: const BoxDecoration(shape: BoxShape.circle),
                                    height: 40,
                                    width: 40,
                                    child:  Image.asset("assets/images/dondi.png",height: 30,width: 30,color:controller.selectedItem.value==1?Color(0xFFFF5722):Color(0xFFFF5722).withOpacity(0.4),),
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                shape: const CircleBorder(),
                                child: InkWell(
                                  splashColor: Colors.white.withOpacity(0.5),
                                  onTap: () async{
                                    controller.setSelectedItem(2);
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
                                      ).then((value) => controller.setSelectedItem(0));
                                    } else {

                                      PermissionStatus status = await Permission.camera.request();
                                      if (Platform.isAndroid && status.isGranted) {
                                        PermissionStatus status = await Permission.microphone.request();
                                        if (status.isGranted) {
                                          PermissionStatus status = await Permission.storage.request();
                                          if (status.isGranted) {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen()));
                                          }
                                        }
                                      } else {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen()));
                                      }
                                    }

                                  },
                                  customBorder: const CircleBorder(),
                                  child: Ink(
                                    padding: EdgeInsets.all(5),
                                    decoration: const BoxDecoration(shape: BoxShape.circle),
                                    height: 40,
                                    width: 40,
                                    child:  Image.asset("assets/images/circle.png",height: 30,width: 30),
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                shape: const CircleBorder(),
                                child: InkWell(
                                  splashColor: Colors.white.withOpacity(0.5),
                                  onTap: () {
                                    if (SessionManager.userId == -1) {
                                      showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        shape: const RoundedRectangleBorder(
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
                                      ).then((value) => controller.setSelectedItem(3));
                                    }else{
                                      controller.setSelectedItem(3);
                                    }
                                  },
                                  customBorder: const CircleBorder(),
                                  child: Ink(
                                    padding: EdgeInsets.all(5),
                                    decoration: const BoxDecoration(shape: BoxShape.circle),
                                    height: 40,
                                    width: 40,
                                    child:  Image.asset("assets/images/notification.png",height: 30,width: 30,color: controller.selectedItem.value==3?Color(0xFFFF5722):Color(0xFFFF5722).withOpacity(0.4),),
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                shape: const CircleBorder(),
                                child: InkWell(
                                  splashColor: Colors.white.withOpacity(0.5),
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
                                      ).then((value) => controller.setSelectedItem(4));
                                    }else{
                                      controller.setSelectedItem(4);
                                    }


                                  },
                                  customBorder: const CircleBorder(),
                                  child: Ink(
                                    padding: EdgeInsets.all(5),
                                    decoration: const BoxDecoration(shape: BoxShape.circle),
                                    height: 40,
                                    width: 40,
                                    child:  Image.asset("assets/images/user.png",height: 30,width: 30,color: controller.selectedItem.value==4?Color(0xFFFF5722):Color(0xFFFF5722).withOpacity(0.4),),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),

                  ],
                );
              },
            ),
          ),
          bannerAd != null?
            Container(
              alignment: Alignment.center,
              child: AdWidget(ad: bannerAd!),
              width: bannerAd?.size.width.toDouble(),
              height: bannerAd?.size.height.toDouble(),
            ):Text("SIAM ",style: TextStyle(color: Colors.black),),
        ],
      ),
    );
  }
  BannerAd? bannerAd;
  void getBannerAd() {
    log("hmm $bannerAd");
    CommonFun.bannerAd((ad) {
      log("hmm1 $bannerAd");
      bannerAd = ad as BannerAd;
      print("banner add $bannerAd");
      setState(() {});
    });
  }

  void initPref() async {
    await _sessionManager.initPref();
    if (Platform.isIOS && !_sessionManager.getBool(ConstRes.isAccepted)!) {
      Timer(Duration(seconds: 1), () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: false,
            backgroundColor: Colors.transparent,
            enableDrag: false,
            builder: (context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.964,
                decoration: BoxDecoration(
                  color: colorPrimaryDark,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                        color: colorPrimary,
                      ),
                      child: Center(
                        child: Text(
                          'End User License Agreement',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: WebViewWidget(

                         controller: _controller,
                      ),
                    ),
                    InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                      onTap: () {
                        _sessionManager.saveBoolean(ConstRes.isAccepted, true);
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        child: Center(
                          child: Text('Accept'),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlugin() async {
    final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
    // If the system can show an authorization request dialog
    if (status == TrackingStatus.notDetermined) {
      // Request system's tracking authorization dialog
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print("UUID: $uuid");
  }
}
