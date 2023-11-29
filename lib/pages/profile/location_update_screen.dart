import 'dart:io';

import 'package:dondi/model/country_state_data.dart';
import 'package:dondi/pages/profile/dialog_country_category.dart';
import 'package:dondi/pages/profile/dialog_state_category.dart';
import 'package:dondi/utils/my_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

import '../../api/api_service.dart';
import '../../location_service/location_service.dart';
import '../../model/profile_category.dart';
import '../../model/user.dart';
import '../../utils/assert_image.dart';
import '../../utils/const.dart';
import '../../utils/session_manager.dart';
import '../../widget/custom_text.dart';
import '../../widget/dialog/loader_dialog.dart';
import 'dialog_profile_category.dart';
class UpdateLocationScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<UpdateLocationScreen> {
  String address="";
  String countryName = '';
  String countryId = '';
  String stateName = '';
  String stateId = '';
  SessionManager sessionManager=SessionManager();
  final controller=Get.put(MyLoading());
  final titleColor=const Color(0xFF5A5A5A);
  final locationController=Get.put(CollectLatLngController());
  @override
  void initState() {
    locationController.getLatLng();
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
                    Container(
                      height: 55,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Edit Location',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),

                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          'Country',
                          style: TextStyle(
                              fontSize: 14,
                              color: titleColor
                          ),
                        ),
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
                                  countryName.isEmpty?"Select":countryName,
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
                                      return DialogCountryCategory(
                                            (data) {
                                          CountryState p = data;
                                          countryName =
                                              p.name.toString();
                                          countryId =
                                              p.id.toString();
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
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          'State',
                          style: TextStyle(
                              fontSize: 14,
                              color: titleColor
                          ),
                        ),
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
                                  stateName.isEmpty?"Select":stateName,
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
                                  if(countryId.isEmpty){
                                    showToast("Please select country");
                                    return;
                                  }
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) {
                                      return DialogStateCategory(
                                            (data) {
                                          CountryState p = data;
                                          stateName =
                                              p.name.toString();
                                          stateId =
                                              p.id.toString();
                                          Navigator.pop(context);
                                          setState(() {});
                                        },countryId
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
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          'Address',
                          style: TextStyle(
                              fontSize: 14,
                              color: titleColor
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xFF15161A),
                        ),
                        child: TextField(
                          controller: TextEditingController(text: address),
                          onChanged: (value) => address = value,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Address',
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





                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(onPressed: (){
                        showDialog(
                          context: context,
                          builder: (context) => LoaderDialog(),
                        );

                        ApiService().editAddress(locationController.lat.value,
                            locationController.lng.value, countryId, stateId, stateName, address??"Address").then((value) async{

                              await sessionManager.initPref();
                          sessionManager.saveBoolean(LOCATIONUPDATED, true);
                          Navigator.pop(context,true);
                          Navigator.pop(context,true);
                          showToast('Location updated successfully..!');
                        });

                      },style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.maxFinite, 48),
                          backgroundColor: const Color(0xFFD0463B),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: BorderSide(color: Colors.black.withOpacity(0.15))

                          )
                      ), child: const CustomText(textAlign: TextAlign.center, fontSize: 16, fontWeight: FontWeight.w500, text: 'Update', color: Colors.white,


                      ),),

                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
}
