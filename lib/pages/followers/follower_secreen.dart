
import 'dart:io';

import 'package:dondi/utils/my_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../model/user.dart';
import 'package:get/get.dart';

import '../../utils/assert_image.dart';
import '../../utils/const.dart';
import 'item_followers_page.dart';
// ignore: must_be_immutable
class FollowerScreen extends StatelessWidget {
  PageController? _pageController;
  final Data? userData;

  FollowerScreen(this.userData);
  final controller=Get.put(MyLoading());

  @override
  Widget build(BuildContext context) {
    _pageController = PageController(
        initialPage: controller
            .followerPageIndex.value);
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
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.chevron_left_rounded,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Center(
                        child: Wrap(
                          children: [
                            Container(
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                                color: Color(0xFF15161A),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 110,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  ClipOval(
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Image(
                                            image: AssetImage(icUserPlaceHolder),
                                            color: colorLightWhite,
                                          ),
                                        ),
                                        Container(
                                          height: 25,
                                          width: 25,
                                          child: ClipOval(
                                            child: Image.network(
                                              ConstRes.itemBaseUrl +
                                                  userData!.userProfile!,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container();
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '@${userData!.userName}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 0,
                  color: colorTextLight,
                  margin: EdgeInsets.only(bottom: 5),
                ),
                GetBuilder<MyLoading>(
                  builder: (controll) {
                    return Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: InkWell(
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            onTap: () {
                              _pageController!.animateToPage(0,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.linear);
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Color(0xFF15161A),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),

                              child: Center(
                                child: Text(
                                  '${userData!.followersCount} Followers',
                                  style: TextStyle(
                                    color: controll.followerPageIndex.value == 0
                                        ? Colors.white
                                        : colorTextLight,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Expanded(
                          child: InkWell(
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            onTap: () {
                              _pageController!.animateToPage(1,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.linear);
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Color(0xFF15161A),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Center(
                                child: Text(
                                  '${userData!.followingCount} Following',
                                  style: TextStyle(
                                    color: controller.followerPageIndex.value == 1
                                        ? Colors.white
                                        : colorTextLight,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: BouncingScrollPhysics(),
                    children: [
                      ItemFollowersPage(userData!.userId, 0),
                      ItemFollowersPage(userData!.userId, 1),
                    ],
                    onPageChanged: (value) {
                      controller
                          .setFollowerPageIndex(value);
                    },
                  ),
                ),
              ],
            ),

        ),
      ),
    );
  }
}
