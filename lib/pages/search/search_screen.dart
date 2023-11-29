
import 'dart:io';

import 'package:dondi/pages/search/search_user_screen.dart';
import 'package:dondi/pages/search/search_video_screen.dart';
import 'package:dondi/utils/my_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../utils/const.dart';
class SearchScreen extends StatelessWidget {
  final controller=Get.put(MyLoading());
  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController(
        initialPage:
            controller.searchPageIndex.value);
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
                height: 10,
              ),
              Row(
                children: [
                  InkWell(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 50,
                      width: 50,
                      child: Icon(
                        Icons.keyboard_arrow_left,
                        size: 35,
                        color: colorTextLight,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 15),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 45,
                      decoration: BoxDecoration(
                        color: Color(0xFF15161A),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: TextField(
                        controller: TextEditingController(
                            text: controller.searchText.value
                                ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: colorTextLight,
                            fontSize: 15,
                          ),
                        ),
                        onChanged: (value) {
                         controller
                              .setSearchText(value);
                        },
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              GetBuilder<MyLoading>(
                builder: (control) {
                  return Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
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
                                  .setSearchPageIndex(0);
                              _pageController.animateToPage(0,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.linear);
                            },
                            child: Center(
                              child: Text(
                                "Videos"
                                ,style: TextStyle(color: control.searchPageIndex.value == 0
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
                                  .setSearchPageIndex(1);

                              _pageController.animateToPage(1,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.linear);
                            },
                            child: Center(
                              child: Text(
                                "Users",
                                style: TextStyle(color: control.searchPageIndex.value == 1
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
              SizedBox(
                height: 5,
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: BouncingScrollPhysics(),
                  children: [
                    SearchVideoScreen(),
                    SearchUserScreen(),
                  ],
                  onPageChanged: (value) {
                    controller
                        .setSearchPageIndex(value);
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
