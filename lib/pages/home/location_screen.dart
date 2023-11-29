
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../api/api_service.dart';
import '../../model/user_video.dart';
import '../../utils/const.dart';
import '../../utils/session_manager.dart';
import '../login/dialog_login.dart';
import '../profile/location_update_screen.dart';
import '../video/item_video.dart';
import 'package:get/get.dart';

class LocationScreen extends StatefulWidget {
  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<LocationScreen> with AutomaticKeepAliveClientMixin {
  List<Widget> mList = [];
  PageController pageController = PageController();
  bool isLocationDataEmpty = false;
  SessionManager sessionManager = SessionManager();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PageView(
      physics: BouncingScrollPhysics(),
      controller: pageController,
      pageSnapping: true,
      onPageChanged: (value) {
        print(value);
        if (value == mList.length - 1) {
          callApiFollowing();
        }
      },
      scrollDirection: Axis.vertical,
      children: mList,
    );
  }

  int start = 0;

  @override
  void initState() {
    //checkLocation();
    super.initState();
  }
  void checkLocation()async{
   await sessionManager.initPref();
    var locationUpdated=sessionManager.getBool(LOCATIONUPDATED);

    log("userid ${SessionManager.userId}");
    log("bool ${locationUpdated}");

    if(SessionManager.userId==-1&&locationUpdated==false){Future.delayed(Duration.zero,(){
        showDialog(context: Get.context!, builder: (context){
          return AlertDialog(
            title: Text("Message!"),
            content: Text("Please login and update location to watch your current area's posts"),
            actions: [
              TextButton(onPressed: (){
                Get.back();
                callApiFollowing();
              }, child: Text("Later")),
              TextButton(onPressed: (){
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  isScrollControlled: true,
                  context: Get.context!,
                  builder: (context) {
                    return DialogLogin();
                  },
                ).then((value) async{
                  log("login response $value");
                  if(value==true){
                    var locationUpdated=sessionManager.getBool(LOCATIONUPDATED);
                    if(locationUpdated!=null&&locationUpdated==true){
                      Get.back();
                      callApiFollowing();
                    }else{
                      Get.to(()=> UpdateLocationScreen(),transition: Transition.fade)!.then((value) {
                        if(value==true){
                          Get.back();
                          callApiFollowing();
                        }
                        else{
                          Get.back();
                          showDialog(context: Get.context!, builder: (context){
                            return AlertDialog(
                              title: Text("Message!"),
                              content: const Text("Okey we are assuming you will update your location later on"),
                              actions: [
                                TextButton(onPressed: (){
                                  Get.back();
                                  callApiFollowing();
                                }, child: Text("OKEY")),

                              ],
                            );
                          });
                        }

                      });
                    }
                  }
                  else{
                    Get.back();
                    callApiFollowing();
                  }

                });
              }, child: Text("Login")),
            ],
          );
        });
      });}

    else if(SessionManager.userId!=-1&&locationUpdated==false){
      Future.delayed(Duration.zero,(){
        showDialog(context: Get.context!, builder: (context){
          return AlertDialog(
            title: Text("Message!"),
            content: Text("Please update location to watch your current area's posts"),
            actions: [
              TextButton(onPressed: (){
                Get.back();
                callApiFollowing();
              }, child: Text("Later")),
              TextButton(onPressed: (){
                Get.to(()=> UpdateLocationScreen(),transition: Transition.fade)!.then((value) {
                  if(value==true){
                    Get.back();
                    callApiFollowing();
                  }
                  else{
                    Get.back();
                    showDialog(context: Get.context!, builder: (context){
                      return AlertDialog(
                        title: Text("Message!"),
                        content: const Text("Okey we are assuming you will update your location later on"),
                        actions: [
                          TextButton(onPressed: (){
                            Get.back();
                            callApiFollowing();
                          }, child: Text("OKEY")),

                        ],
                      );
                    });
                  }

                });
              }, child: Text("Update Location")),
            ],
          );
        });
      });
    }

    else{
      callApiFollowing();
    }
  }

  void callApiFollowing() {

    ApiService().getPostList(start.toString(), ConstRes.count.toString(), SessionManager.userId.toString(), SessionManager.userId==-1?"else":"location").then((value) {
      if (value.data != null && value.data!.isNotEmpty) {
        if (mList.isEmpty) {
          mList = List<Widget>.generate(value.data!.length, (index) {
            return ItemVideo(value.data![index]);
          });
          setState(() {});
        } else {
          for (Data data in value.data!) {
            mList.add(ItemVideo(data));
          }
        }
        start += ConstRes.count;
        print(mList.length);
      }
    });
  }


  @override
  bool get wantKeepAlive => true;
}
