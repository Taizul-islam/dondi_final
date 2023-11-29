
import 'dart:io';

import 'package:dondi/pages/notification/widget/chat_list.dart';
import 'package:dondi/pages/notification/widget/notification_list.dart';
import 'package:dondi/utils/my_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';
import '../../utils/common_fun.dart';
import '../../utils/const.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  PageController controller = PageController();
  final stateController=Get.put(MyLoading());

  @override
  void initState() {
    controller = PageController(
        initialPage: stateController
            .notificationPageIndex.value,
        keepPage: true);
    //getBannerAd();
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
          child: Column(
            children: [
              GetBuilder<MyLoading>(
                builder: (control) {
                  return Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(40),topLeft: Radius.circular(40)),
                        color: Color(0xFF15161A)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            overlayColor: MaterialStateProperty.all(
                                Colors.transparent),
                            onTap: () {
                              control
                                  .setProfilePageIndex(0);
                              controller.animateToPage(0,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.linear);
                            },
                            child: Center(
                              child: Text(
                               "Notifications"
                                  ,style: TextStyle(color: control.notificationPageIndex.value == 0
                                  ? Color(0xFFFF5722)
                                  : colorTextLight,fontSize: 16),

                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: InkWell(
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            overlayColor: MaterialStateProperty.all(
                                Colors.transparent),
                            onTap: () {
                              control
                                  .setProfilePageIndex(1);

                              controller.animateToPage(1,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.linear);
                            },
                            child: Center(
                              child: Text(
                                "Chat",
                  style: TextStyle(color: control.notificationPageIndex.value == 1
                  ? Color(0xFFFF5722)
                      : colorTextLight,fontSize: 16
                  ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Expanded(
                child: PageView(
                  controller: controller,
                  onPageChanged: (value) {
                    stateController
                        .setNotificationPageIndex(value);
                  },
                  children: [NotificationList(), ChatList()],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (bannerAd != null)
                Container(
                  alignment: Alignment.center,
                  child: AdWidget(ad: bannerAd!),
                  width: bannerAd?.size.width.toDouble(),
                  height: bannerAd?.size.height.toDouble(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  BannerAd? bannerAd;

  void getBannerAd() {
    CommonFun.bannerAd((ad) {
      bannerAd = ad as BannerAd;
      setState(() {});
    });
  }
}
