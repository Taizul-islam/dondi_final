

import 'dart:io';

import 'package:dondi/pages/login/dialog_login.dart';
import 'package:dondi/pages/login/login_page.dart';
import 'package:dondi/pages/splash/splash_page.dart';
import 'package:dondi/utils/my_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:share_plus/share_plus.dart';

import '../../api/api_service.dart';
import '../../model/user.dart';
import '../../utils/assert_image.dart';
import '../../utils/const.dart';
import '../../utils/session_manager.dart';
import '../../widget/dialog/simple_dialog.dart';
import '../qrcode/my_qr_code_screen.dart';
import '../verification/verification_screen.dart';
import '../wallet/wallet_screen.dart';
import '../webview/webview_screen.dart';

class SettingScreen extends StatelessWidget {
  final controller=Get.put(MyLoading());
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        'Settings',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CenterArea(
                shareLink: shareLink,
              )
            ],
          ),
        ),
      ),
    );
  }

  void shareLink(BuildContext context) async {
    showLoader();
    User user = controller.user.value;
    BranchUniversalObject buo = BranchUniversalObject(
        canonicalIdentifier: 'flutter/branch',
        title: user.data!.userName!,
        imageUrl: ConstRes.itemBaseUrl + user.data!.userProfile!,
        contentDescription: '',
        publiclyIndex: true,
        locallyIndex: true,
        contentMetadata: BranchContentMetaData()
          ..addCustomMetadata('user_id', user.data!.userId));
    BranchLinkProperties lp = BranchLinkProperties(
        channel: 'facebook',
        feature: 'sharing',
        stage: 'new share',
        tags: ['one', 'two', 'three']);
    lp.addControlParam('url', 'http://www.google.com');
    lp.addControlParam('url2', 'http://flutter.dev');
    BranchResponse response =
        await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);
    if (response.success) {
      Get.back();
      Share.share(
        'Check out my profile ${response.result} 😋😋',
        subject: 'Look ${user.data!.userName}',
      );
    } else {
      print('Error : ${response.errorCode} - ${response.errorMessage}');
    }
  }
}

class CenterArea extends StatefulWidget {
  final Function(BuildContext context) shareLink;

  const CenterArea({Key? key, required this.shareLink}) : super(key: key);

  @override
  State<CenterArea> createState() => _CenterAreaState();
}

class _CenterAreaState extends State<CenterArea> {
  SessionManager sessionManager = SessionManager();
  int followers = 0;
  final controller=Get.put(MyLoading());


  @override
  void initState() {
    prefData();
    super.initState();
  }

  void prefData() async {
    await sessionManager.initPref();
    followers = sessionManager.getUser()?.data?.followersCount ?? 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 13,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Settings',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7)
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(
                      color: colorPrimary,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          padding: const EdgeInsets.only(left: 10, right: 20),
                          child: Row(
                            children: [
                              Image.asset(
                                icNotificationBorder,
                                height: 17,
                                color: Color(0xFF404040),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              const Text(
                                'Notify me',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: colorTextLight,
                                ),
                              ),
                              const Spacer(),
                              Container(),
                              NotificationSwitch()
                            ],
                          ),
                        ),
                        InkWell(
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          onTap: () => widget.shareLink(context),
                          child: ItemSetting('Share profile', icShareBorder),
                        ),
                        InkWell(
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyQrScanCodeScreen())),
                          child: ItemSetting('My QR Code', icQrCode),
                        ),
                        InkWell(
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WalletScreen())),
                          child: ItemSetting('Wallet', icWallet),
                        ),
                        Visibility(
                          visible: controller.user.value.data!.isVerify == 0,
                          child: InkWell(
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            overlayColor: MaterialStateProperty.all(Colors.transparent),
                            onTap: () {
                              print(SettingRes.minFansVerification);
                              print(followers);
                              if (int.parse(SettingRes.minFansVerification!) > followers) {
                                return flutterToast('Minimum follower ${SettingRes.minFansVerification}');
                              } else {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => VerificationScreen()));
                              }
                            },
                            child: ItemSetting('Request verification', icVerified),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'General Settings',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7)
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: colorPrimary,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WebViewScreen(1),
                                  ),
                                ),
                            child: ItemSetting('Help', icHelp)),
                        InkWell(
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WebViewScreen(2),
                                  ),
                                ),
                            child: ItemSetting('Terms of use', icTerms)),
                        InkWell(
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebViewScreen(3),
                            ),
                          ),
                          child: ItemSetting('Privacy policy', icPrivacy),
                        ),
                        InkWell(
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => SimpleCustomDialog(
                                title: 'Are You Sure',
                                message:
                                    'All of your data: including Posts,\n Likes, Follows and everything which is\n connected to your identity, will be deleted \nfrom our platform. This actions can\'t be undone.',
                                negativeText: 'Cancel',
                                positiveText: 'Confirm',
                                onButtonClick: (clickType) {
                                  if (clickType == 1) {
                                    ApiService().deleteAccount().then(
                                      (value) {
                                        Navigator.pop(context);
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SplashPage()),
                                            (Route<dynamic> route) => false);
                                      },
                                    );
                                  } else {}
                                },
                              ),
                            );
                          },
                          child: ItemSetting('Delete Account', icRemoveAccount),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30,),
            Center(
              child: Container(
                width: 130,
                margin: const EdgeInsets.only(bottom: 15),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => SimpleCustomDialog(
                        title: 'Are You Sure',
                        message: 'Do yo really \nwant to log out ?',
                        negativeText: 'Cancel',
                        positiveText: 'Confirm',
                        onButtonClick: (clickType) async {
                          if (clickType == 1) {
                            if (controller
                                    .user.value
                                    .data!
                                    .loginType ==
                                "0") {
                              logOutUser(context);
                            } else if (controller
                                    .user.value
                                    .data!
                                    .loginType ==
                                "1") {
                              FacebookAuth.instance.logOut().then((value) {
                                logOutUser(context);
                              });
                            } else {
                              GoogleSignIn().signOut().then((value) {
                                logOutUser(context);
                              });
                            }
                          }
                        },
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                      MaterialStateProperty.all(
                      Color(0xFF15161A)),
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                       Image.asset("assets/images/icLogout.png",height: 20,),

                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Log Out'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void flutterToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }

  void logOutUser(BuildContext context) {
    ApiService().logoutUser().then(
      (value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SplashPage()),
            (Route<dynamic> route) => false);
      },
    );
  }
}

class NotificationSwitch extends StatefulWidget {
  @override
  _NotificationSwitchState createState() => _NotificationSwitchState();
}

class _NotificationSwitchState extends State<NotificationSwitch> {
  var currentValue = true;
  SessionManager _sessionManager = SessionManager();

  @override
  void initState() {
    initSessionManager();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      activeTrackColor: const Color(0xFFFF5722),
      thumbColor: MaterialStateProperty.all(Colors.black),
      activeColor: Color(0xFFFF5722),
      onChanged: (value) {
        currentValue = value;
        ApiService().setNotificationSettings(currentValue
            ? _sessionManager.getString(ConstRes.deviceToken)
            : 'destroy');
        setState(() {});
      },
      value: currentValue,
    );
  }

  void initSessionManager() async {
    await _sessionManager.initPref();
  }
}

class ItemSetting extends StatelessWidget {
  final String image;
  final String text;

  ItemSetting(this.text, this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 10, right: 20),
      child: Row(
        children: [
          Image.asset(
            image,
            height: 20,
            color: Color(0xFF404040),
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: colorTextLight,
            ),
          ),
        ],
      ),
    );
  }
}
