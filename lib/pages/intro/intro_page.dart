
import 'dart:io';

import 'package:dondi/pages/bottom_navigation/main_screen.dart';
import 'package:dondi/utils/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/const.dart';
import '../login/login_page.dart';
import 'package:get/get.dart';


class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final controller = PageController();
  int currentPage = 0;
  SessionManager sessionManager=SessionManager();
  var imageList=[
    "images/img1.png",
    "images/img2.png",
    "images/img3.png",
    "images/img4.png",
  ];
  var titleList=[
    "Videos by Current Location",
    "Live Video Streaming",
    "Post Videos",
    "Chatting",
  ];
  var descriptionList=[
    "Description about videos by current location",
    "This app help to manage live streaming videos",
    "Description about post videos",
    "Power full chat feature are end to end encryption and able to keep connection with friends through",
  ];
  AnimatedContainer _buildDots({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
        color: currentPage == index ? Colors.white:const Color(0xFFDADADA),
      ),
      margin: const EdgeInsets.only(right: 6),
      height: 9,
      curve: Curves.easeIn,
      width: currentPage==index?24:9,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarIconBrightness: Platform.isAndroid?Brightness.light:Brightness.dark,
          statusBarBrightness: Platform.isAndroid?Brightness.light:Brightness.dark,
          statusBarColor: Colors.black
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body:  SafeArea(
          child: Container(
            margin: const EdgeInsets.only(top: 80),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                      controller: controller,
                      onPageChanged: (value) => setState(() => currentPage = value),
                      itemCount: titleList.length,
                      itemBuilder: (context,index){
                        return Column(
                          children: [
                            Expanded(child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  radius: 110,
                                  backgroundColor: Colors.white.withOpacity(0.6),
                                  backgroundImage: AssetImage(imageList[index]),
                                ),
                                const SizedBox(height: 5,),
                              ],

                            ),),
                            Column(
                              children: [
                                Text(titleList[index],style: const TextStyle(fontSize: 24,fontWeight: FontWeight.w400,color: Colors.white),),
                                const SizedBox(height: 13,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 44),
                                  child: Text(descriptionList[index],textAlign: TextAlign.center,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.white.withOpacity(0.5)),),
                                ),
                              ],
                            ),
                            const SizedBox(height:38,)
                            //
                          ],
                        );
                      }
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    imageList.length,
                        (int index) => _buildDots(index: index),
                  ),
                ),
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26,vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(onPressed: ()async{
                        await sessionManager.initPref();
                        sessionManager.saveBoolean(INTRODONE, true);
                        Get.offAll(()=>MainScreen(),transition: Transition.fade);
                      }, child: const Text("Skip",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: Colors.white),)),

                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side:  BorderSide(color: Colors.white,width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            elevation: 0
                          ),
                          onPressed: ()async{
                        if(currentPage==3){
                          await sessionManager.initPref();
                          sessionManager.saveBoolean(INTRODONE, true);
                          Get.offAll(()=>MainScreen(),transition: Transition.fade);

                        }else{
                          setState(() {
                            currentPage++;
                            controller.animateToPage(currentPage, duration: const Duration(milliseconds: 200), curve: Curves.easeIn,);
                          });
                        }
                      }, child: currentPage==3?const Text("Get Started",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.black),):const Icon(Icons.keyboard_arrow_right_sharp,size: 30,)),

                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ),

    );
  }
}
