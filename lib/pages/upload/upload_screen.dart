import 'dart:developer';
import 'dart:io';

import 'package:dondi/pages/upload/UploadController.dart';
import 'package:dondi/pages/upload/dialog_video_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../api/api_service.dart';
import '../../model/country_state_data.dart';
import '../../utils/const.dart';
import '../../utils/session_manager.dart';
import '../../widget/dialog/loader_dialog.dart';
import '../webview/webview_screen.dart';
import 'package:get/get.dart';
class UploadPage extends StatefulWidget {
  final String? postVideo;
  final String? thumbNail;
  final String? sound;
  final String? soundId;

  const UploadPage({super.key, this.postVideo, this.thumbNail, this.sound, this.soundId});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadPage> {
  ValueNotifier<int> textSize = ValueNotifier<int>(0);
  String postDes = '';
  String currentHashTag = '';
  List<String> hashTags = [];
  String categoryId="";
  String categoryName="";
  SessionManager _sessionManager = SessionManager();
  final titleColor=const Color(0xFF5A5A5A);
  final controller=Get.put(UploadController());
  @override
  void initState() {
    initSessionManager();
    super.initState();
  }
  @override
  void dispose() {
    Get.delete<UploadController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 525,
      decoration: BoxDecoration(
        color: colorPrimaryDark,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorPrimary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Upload Video',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                child: InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: Image(
                      height: 160,
                      width: 110,
                      fit: BoxFit.cover,
                      image: FileImage(File(widget.thumbNail!)),
                    ),
                  ),
                  Obx(() {
                    if(controller.uploading.isTrue){
                      return Positioned(
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 10,),
                                Obx(() => CircularProgressIndicator(
                                  color: Colors.white,
                                  value: controller.progressValue.value,
                                ),),
                                SizedBox(height: 10,),
                                Obx(() => Text(
                                  controller.progressPercentage.value,style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white
                                ),
                                )
                                )
                              ],
                            ),

                          ));
                    }else{
                      return SizedBox();
                    }
                  })
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      overlayColor:
                      MaterialStateProperty.all(Colors.transparent),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 10),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xFF15161A),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                categoryName.isEmpty?"Select":categoryName,
                                style: TextStyle(
                                  color: colorTextLight,
                                ),
                              ),
                            ),
                            InkWell(
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) {
                                    return DialogVideoCategory(
                                          (data) {
                                            categoryName = data.name.toString();
                                        categoryId =
                                            data.id.toString();
                                        Navigator.pop(context);
                                        setState(() {});
                                      },
                                    );
                                  },
                                );
                              },
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: titleColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Text(
                      'Describe',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: colorPrimary,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      padding: EdgeInsets.only(left: 15, right: 15),
                      height: 130,
                      child: TextField(

                        textInputAction: TextInputAction.done,
                        style: TextStyle(color: Colors.white),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(175),
                        ],
                        enableSuggestions: false,
                        maxLines: 8,
                        onChanged: (value) {

                          textSize.value = value.length;
                          postDes = value;
                          currentHashTag = value.split("#")[1];
                          if (currentHashTag.isNotEmpty) {
                            hashTags.add(currentHashTag);
                            currentHashTag = '';
                          }
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Awesome caption',
                          hintStyle: TextStyle(
                            color: colorTextLight,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 15,
              ),
            ],
          ),
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: Padding(
              padding: EdgeInsets.only(right: 15),
              child: ValueListenableBuilder(
                valueListenable: textSize,
                builder: (context, dynamic value, child) => Text(
                  '$value/175',
                  style: TextStyle(
                    color: colorTextLight,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: InkWell(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              onTap: () {
                if(controller.enable.isFalse){
                  showToast("Please wait...");
                  return;
                }
                if (currentHashTag.isNotEmpty) {
                  hashTags.add(currentHashTag);
                  currentHashTag = '';
                }
                if(categoryId.isEmpty){
                  showToast("Please select category");
                  return;
                }
                print(hashTags.join(","));
                controller.uploading.value=true;
                controller.enable.value=false;
                if (widget.soundId != null) {
                  ApiService()
                      .addPost(
                    postVideo: File(widget.postVideo!),
                    thumbnail: File(widget.thumbNail!),
                    duration: '1',
                    isOrignalSound: '0',
                    postDescription: postDes,
                    postHashTag: hashTags.join(","),
                    soundId: widget.soundId,
                    categoryId: categoryId,
                    controller: controller,
                  )
                      .then(
                    (value) {

                      // if (value.status == 200) {
                      if(value=="success"){
                        showToast('Post Upload Successfully');
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }else{
                        showToast("Video upload failed!");
                        controller.enable.value=true;
                      }

                      //   Navigator.pop(context);
                      //   showToast('Post Upload Successfully');
                      // } else if (value.status == 401) {
                      //   showToast("${value.message}");
                      //   Navigator.pop(context);
                      // }
                    },
                  );
                } else {
                  ApiService()
                      .addPost(
                    postVideo: File(widget.postVideo!),
                    thumbnail: File(widget.thumbNail!),
                    postSound: File(widget.sound!),
                    duration: '1',
                    isOrignalSound: widget.soundId != null ? '0' : '1',
                    postDescription: postDes,
                    postHashTag: hashTags.join(","),
                    singer: _sessionManager.getUser()?.data?.fullName,
                    soundImage: File(widget.thumbNail!),
                    soundTitle: 'Original Sound',
                    soundId: widget.soundId,
                    categoryId: categoryId,
                    controller: controller,
                  )
                      .then(
                    (value) {
                      print("return value $value");
                      log("return value $value");
                      if(value=="success"){
                        showToast('Post Upload Successfully');
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }else{
                        showToast("Video upload failed!");
                        controller.enable.value=true;
                      }
                      //   showToast('Post Upload Successfully');
                      // } else if (value.status == 401) {
                      //   showToast("${value.message}");
                      // }
                    },
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorTheme,
                      colorPink,
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                width: 150,
                height: 40,
                child: Center(
                  child: Text(
                    'Publish'.toUpperCase(),
                    style: TextStyle(
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'By continuing, you agree to our terms of use\nand confirm that you have read our privacy policy.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: colorTextLight,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          InkWell(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WebViewScreen(3),
              ),
            ),
            child: Text(
              'Policy center',
              style: TextStyle(
                color: colorTheme,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }

  void initSessionManager() async {
    await _sessionManager.initPref();
  }
}
