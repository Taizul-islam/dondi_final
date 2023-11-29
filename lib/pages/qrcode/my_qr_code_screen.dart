import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bubbly_camera/bubbly_camera.dart';
import 'package:dondi/utils/my_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../utils/assert_image.dart';
import '../../utils/common_fun.dart';
import '../../utils/const.dart';
import '../../utils/session_manager.dart';
import 'package:get/get.dart';

class MyQrScanCodeScreen extends StatefulWidget {
  @override
  State<MyQrScanCodeScreen> createState() => _MyQrScanCodeScreenState();
}

class _MyQrScanCodeScreenState extends State<MyQrScanCodeScreen> {
  InterstitialAd? interstitialAd;
  final controller=Get.put(MyLoading());
  @override
  void initState() {
    _ads();
    super.initState();
  }

  void _ads() {
    CommonFun.interstitialAd((ad) {
      interstitialAd = ad;
    });
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
          child: Column(
            children: [
              SizedBox(
                height: 55,
                child: Stack(
                  children: [
                    InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.chevron_left_rounded,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'My Code',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 40),
                  child: Column(
                    children: [
                      RepaintBoundary(
                        key: screenshotKey,
                        child: Container(
                          width: double.infinity,
                          margin:
                              EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            color: colorPrimary,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional.topCenter,
                                    child: Container(
                                      padding:
                                          EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                        color: Color(0xFF171717)
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(15)),
                                        child: QrImage(
                                          backgroundColor: Colors.white,
                                          data: SessionManager.userId.toString(),
                                          version: QrVersions.auto,
                                          size: 200.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ClipOval(
                                    child: Image(
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                      image: NetworkImage(ConstRes.itemBaseUrl +
                                          controller
                                              .user.value
                                              .data!
                                              .userProfile!),
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '@${controller.user.value.data!.userName}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    controller
                                        .user.value
                                        .data!
                                        .bio!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: colorTextLight,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),

                                  Image(
                                    image: AssetImage("assets/images/logo.png"),
                                    height: 60,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            onTap: () => _takeScreenShot(context),
                            child: Column(
                              children: [
                                ClipOval(
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Image(
                                        image: AssetImage(icDownload),
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Save Code',
                                  style: TextStyle(
                                    color: colorTextLight,
                                    fontSize: 18
                                  ),
                                )
                              ],
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final GlobalKey screenshotKey = GlobalKey();

  void _takeScreenShot(BuildContext context) async {
    RenderRepaintBoundary boundary = screenshotKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 10);
    ByteData? byteData =
        await (image.toByteData(format: ui.ImageByteFormat.png));
    if (byteData == null) return;
    Uint8List pngBytes = byteData.buffer.asUint8List();
    convertImageToFile(pngBytes, context);
  }

  Future convertImageToFile(Uint8List image, BuildContext context) async {
    if (Platform.isAndroid) {
      final file = File(
          '/storage/emulated/0/Download/${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(image);
    } else {
      var f = await getApplicationDocumentsDirectory();
      print(f);
      final file = File('${f.path}/myqrcode.png');
      await file.writeAsBytes(image);
      BubblyCamera.saveImage(file.path);
    }
    if (interstitialAd != null) {
      interstitialAd?.show().then((value) {
        Navigator.pop(context);
      });
    } else {
      Navigator.pop(context);
    }
    Fluttertoast.showToast(
      msg: 'File saved successfully...!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }
}
