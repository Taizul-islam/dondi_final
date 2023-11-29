import 'dart:io';

import 'package:dondi/utils/my_loading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/api_service.dart';
import '../../utils/assert_image.dart';
import '../../utils/common_fun.dart';
import '../../utils/const.dart';
import '../../utils/session_manager.dart';
import '../../widget/dialog/loader_dialog.dart';
import 'package:get/get.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String photoWithId = '';
  String photoId = '';
  String idNumber = '';
  String nameOnId = '';
  String fullAddress = '';
  InterstitialAd? interstitialAd;

  final controller=Get.put(MyLoading());
  var sessionManager = SessionManager();

  @override
  void initState() {
    initPref();
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 60,
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
                      'Request Verification',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 0.3,
              color: colorTextLight,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Text(
                        'Your photo(Holding your ID card)',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ClipOval(
                        child: Image(
                          image: (photoWithId.isEmpty
                                  ? AssetImage(icImgHoldingId)
                                  : FileImage(File(photoWithId)))
                              as ImageProvider<Object>,
                          fit: photoWithId.isEmpty
                              ? BoxFit.fitWidth
                              : BoxFit.cover,
                          height: 125,
                          width: 125,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: 150,
                        height: 35,
                        child: ElevatedButton(
                          onPressed: () {
                            ImagePicker()
                                .pickImage(
                                    source: ImageSource.camera,
                                    imageQuality: 100)
                                .then((value) {
                              photoWithId = value!.path;
                              setState(() {});
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(colorPrimary),
                          ),
                          child: Text(
                            'Capture',
                            style: TextStyle(
                              color: colorIcon,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Photo of ID(Clear Photo)',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Image(
                        image: (photoId.isEmpty
                                ? AssetImage(icBgId)
                                : FileImage(File(photoId)))
                            as ImageProvider<Object>,
                        height: 95,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: 150,
                        height: 35,
                        child: ElevatedButton(
                          onPressed: () {
                            ImagePicker()
                                .pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 100)
                                .then((value) {
                              photoId = value!.path;
                              setState(() {});
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(colorPrimary),
                          ),
                          child: Text(
                            'Attach',
                            style: TextStyle(
                              color: colorIcon,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          'ID Number',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: colorPrimary,
                        ),
                        child: TextField(
                          onChanged: (value) => idNumber = value,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'XX-XXXX-XXXXXXXX',
                            hintStyle: TextStyle(
                              color: colorTextLight,
                            ),
                          ),
                          style: TextStyle(
                            color: colorTextLight,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          'Name On ID',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: colorPrimary,
                        ),
                        child: TextField(
                          onChanged: (value) => nameOnId = value,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Same as ID',
                            hintStyle: TextStyle(
                              color: colorTextLight,
                            ),
                          ),
                          style: TextStyle(
                            color: colorTextLight,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          'Full Address',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        height: 115,
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: colorPrimary,
                        ),
                        child: TextField(
                          onChanged: (value) => fullAddress = value,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Same as ID',
                            hintStyle: TextStyle(
                              color: colorTextLight,
                            ),
                          ),
                          style: TextStyle(
                            color: colorTextLight,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        onTap: () {
                          if (photoWithId.isEmpty) {
                            showToast('Please capture image...!');
                          } else if (photoId.isEmpty) {
                            showToast('Please attach your id card...!');
                          } else if (idNumber.isEmpty) {
                            showToast('Please enter your id number...!');
                          } else if (nameOnId.isEmpty) {
                            showToast('Please enter your name...!');
                          } else if (fullAddress.isEmpty) {
                            showToast('Please enter your full address...!');
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => LoaderDialog(),
                            );
                            ApiService()
                                .verifyRequest(idNumber, nameOnId, fullAddress,
                                    File(photoWithId), File(photoId))
                                .then((value) {
                              if (value.status == 200) {
                                showToast(
                                    'Request for verification successfully...!');

                                    controller.setUser(sessionManager.getUser()!);
                                if (interstitialAd != null) {
                                  interstitialAd?.show().then((value) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  });
                                } else {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              }
                            });
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 175,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            gradient: LinearGradient(
                              colors: [
                                colorTheme,
                                colorPink,
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Submit'.toUpperCase(),
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
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

  void initPref() async {
    await sessionManager.initPref();
  }
}
