import 'dart:async';
import 'dart:io';

import 'package:dondi/ads.dart';
import 'package:dondi/utils/my_loading.dart';
import 'package:dondi/utils/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../api/api_service.dart';
import '../../notification/notification_api.dart';
import '../../utils/const.dart';
import 'package:flutter_facebook_keyhash/flutter_facebook_keyhash.dart';

import '../bottom_navigation/main_screen.dart';
import '../intro/intro_page.dart';
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final controller=Get.put(MyLoading());
  SessionManager sessionManager=SessionManager();
  FirebaseMessaging firebaseMessaging=FirebaseMessaging.instance;
  @override
  void initState(){
    NotificationAPI.init();
    saveTokenUpdate();
    //getUserData();
    // await Future.delayed(Duration(seconds: 1));
    // Get.offAll(()=>Ads(),transition: Transition.fade);
    super.initState();
  }
  void saveTokenUpdate() async {
    log("execute_token");
    await sessionManager.initPref();
    var token=await firebaseMessaging.getToken();
    print("device token $token");
    sessionManager.saveString(ConstRes.deviceToken, token);
    print("return token ${sessionManager.getString(ConstRes.deviceToken)}");
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
        NotificationAPI.showSimpleNotification(title: message.data['title'],body: message.data['body']);
      }

    });
    getUserData();

  }
  void getUserData() async {
    await sessionManager.initPref();
    if (sessionManager.getUser() != null && sessionManager.getUser()!.data != null) {
      SessionManager.userId = sessionManager.getUser()!.data!.userId ?? sessionManager.getUser()!.data!.userId;
      SessionManager.accessToken = sessionManager.getUser()!.data!.token ?? sessionManager.getUser()!.data!.token;
      print(SessionManager.accessToken);
      controller.setUser(sessionManager.getUser()!);
    }
    ApiService().fetchSettingsData();
    ConstRes.isDialog == false ? const SizedBox() :
    controller.setIsHomeDialogOpen(true);
    controller.setSelectedItem(0);
    ApiService().getNotificationList("0", "100").then((value) {
      log("hmmm $value");
      if (value.status == 401 && (value.data == null || value.data!.isEmpty)) {
        ApiService().logoutUser();
      }

    });
    // Future.delayed(const Duration(seconds: 2)).then((value) {
    //   var done=sessionManager.getBool(INTRODONE);
    //   if(done!=null&&done==true){
    //     // Get.offAll(()=>MainScreen(),transition: Transition.fade);
    //     //await Future.delayed(Duration(seconds: 2));
    //     Get.offAll(()=>const Ads(),transition: Transition.fade);
    //   }else{
    //     // Get.offAll(()=>const IntroPage(),transition: Transition.fade);
    //     // await Future.delayed(Duration(seconds: 2));
    //     Get.offAll(()=>const Ads(),transition: Transition.fade);
    //   }
    // });
    Timer(const Duration(seconds: 2),(){
      var done=sessionManager.getBool(INTRODONE);
      if(done!=null&&done==true){
         Get.offAll(()=>MainScreen(),transition: Transition.fade);
        //await Future.delayed(Duration(seconds: 2));
        //Get.off(()=>const Ads(),transition: Transition.fade);
      }else{
         Get.offAll(()=>const IntroPage(),transition: Transition.fade);
        // await Future.delayed(Duration(seconds: 2));
        //Get.off(()=>const Ads(),transition: Transition.fade);
      }
    });




  }
  void printKeyHash() async{

    String? key=await FlutterFacebookKeyhash.getFaceBookKeyHash ??
        'Unknown platform version';
    print(key??"");

  }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Platform.isAndroid?Brightness.light:Brightness.dark,
        statusBarIconBrightness: Platform.isAndroid?Brightness.light:Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Image.asset("assets/images/logo.png",width: Get.width*0.6,),
        )
      ),
    );
  }

}
