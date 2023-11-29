import 'dart:developer';
import 'dart:io';

import 'package:dondi/model/country_state_data.dart';
import 'package:dondi/pages/profile/dialog_country_category.dart';
import 'package:dondi/pages/profile/dialog_gender.dart';
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
import '../../widget/custom_text.dart';
import '../../widget/dialog/loader_dialog.dart';
import 'dialog_profile_category.dart';
class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String profileImage = '';
  String? fullName = '';
  String? address = '';
  String? userName = '';
  String? userEmail = '';
  String? bio = '';
  String? fbUrl = '';
  String? instaUrl = '';
  String? youtubeUrl = '';
  String profileCategory = '';
  String? countryName = '';
  String countryId = '';
  String? stateName = '';
  String stateId = '';
  String? dob = '';
  String? gender="";
  String? profileCategoryName = '';
  String? country_icon = '';
  final controller=Get.put(MyLoading());
  final titleColor=const Color(0xFF5A5A5A);
  final locationController=Get.put(CollectLatLngController());
  @override
  void initState() {
    locationController.getLatLng();
    User user = controller.user.value;
    fullName = user.data!.fullName != null ? user.data!.fullName : '';
    userName = user.data!.userName != null ? user.data!.userName : '';
    bio = user.data!.bio != null ? user.data!.bio : '';
    fbUrl = user.data!.fbUrl != null ? user.data!.fbUrl : '';
    instaUrl = user.data!.instaUrl != null ? user.data!.instaUrl : '';
    youtubeUrl = user.data!.youtubeUrl != null ? user.data!.youtubeUrl : '';
    profileCategoryName = user.data!.profileCategoryName != null
        ? user.data!.profileCategoryName
        : 'Select';
    userEmail = user.data!.userEmail != null ? user.data!.userEmail : '';
    dob = user.data!.dob != null ? user.data!.dob : '';
    gender = user.data!.gender != null ? user.data!.gender : '';
    countryName = user.data!.country_name != null ? user.data!.country_name : '';
    stateName = user.data!.state_name != null ? user.data!.state_name : '';
    country_icon = user.data!.country_icon != null ? user.data!.country_icon : '';
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
                            'Edit Profile',
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
                        height: 20,
                      ),
                      ClipOval(
                        child: profileImage.isEmpty
                            ? SizedBox(
                                height: 100,
                                width: 100,
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      icUserPlaceHolder,
                                      height: 100,
                                      fit: BoxFit.fill,
                                      width: 100,
                                      color: Colors.white,
                                    ),
                                    Image(
                                      image: NetworkImage(
                                        ConstRes.itemBaseUrl +
                                            (controller
                                                            .user.value
                                                            .data!
                                                            .userProfile !=
                                                        null &&
                                                controller
                                                    .user.value
                                                    .data!
                                                        .userProfile!
                                                        .isNotEmpty
                                                ? controller
                                                .user.value
                                                .data!
                                                    .userProfile!
                                                : ''),
                                      ),
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.asset(
                                          icUserPlaceHolder,
                                          height: 100,
                                          fit: BoxFit.fill,
                                          width: 100,
                                          color: Colors.white,
                                        );
                                      },
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              )
                            : Image(
                                image: FileImage(
                                  File(profileImage),
                                ),
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 35,
                        width: 135,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(colorPrimary)),
                          onPressed: () {
                            ImagePicker()
                                .pickImage(
                                    source: ImageSource.gallery, imageQuality: 50)
                                .then((value) {
                              profileImage = value!.path;
                              print(profileImage);
                              setState(() {});
                            });
                          },
                          child: Text(
                            'Change',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          'Profile Category',
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
                                  profileCategoryName!.isEmpty?"Select":profileCategoryName!,
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
                                      return DialogProfileCategory(
                                        (data) {
                                          ProfileCategoryData p = data;
                                          profileCategory =
                                              p.profileCategoryId.toString();
                                          profileCategoryName =
                                              p.profileCategoryName;
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
                          'Date of Birth',
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
                                  dob!.isEmpty?"Select":dob!,
                                  style: const TextStyle(
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
                                  showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1970),
                                      lastDate: DateTime.now()).then((value)
                                  {
                                    if(value==null){
                                      showToast("Please select date of birth");
                                      return;
                                    }
                                    dob="${value.year}-${value.month}-${value.day}";
                                    setState(() {});

                                  });
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
                          'Gender',
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
                                  gender!.isEmpty?"Select":gender!,
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
                                      return DialogGender(
                                            (data) {
                                              log("dob $data");

                                          gender =
                                              data.toString();
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
                                  countryName!.isEmpty?"Select":countryName!,
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
                                  stateName!.isEmpty?"Select":stateName!,
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
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          'Full Name',
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
                          controller: TextEditingController(text: fullName),
                          onChanged: (value) => fullName = value,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Full Name',
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
                          'Username',
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
                          controller: TextEditingController(text: userName),
                          onChanged: (value) => userName = value,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Username',
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
                          'Bio',
                          style: TextStyle(
                            fontSize: 14,
                            color: titleColor
                          ),
                        ),
                      ),
                      Container(
                        height: 115,
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xFF15161A),
                        ),
                        child: TextField(
                          controller: TextEditingController(text: bio),
                          onChanged: (value) {
                            bio = value;
                            print(bio);
                          },
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Present yourself',
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
                          'Social',
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
                        child: Row(
                          children: [
                            ClipOval(
                              child: Container(
                                color: titleColor,
                                height: 22,
                                width: 22,
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Image(
                                    image: AssetImage(icFaceBook),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: TextField(
                                controller: TextEditingController(text: fbUrl),
                                onChanged: (value) => fbUrl = value,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'facebook',
                                  hintStyle: TextStyle(
                                    color: colorTextLight,
                                  ),
                                ),
                                style: TextStyle(
                                  color: colorTextLight,
                                ),
                              ),
                            ),
                          ],
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
                        child: Row(
                          children: [
                            ClipOval(
                              child: Container(
                                color: titleColor,
                                height: 22,
                                width: 22,
                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Image(
                                    image: AssetImage(icInstagram),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: TextField(
                                controller: TextEditingController(text: instaUrl),
                                onChanged: (value) => instaUrl = value,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'instagram',
                                  hintStyle: TextStyle(
                                    color: colorTextLight,
                                  ),
                                ),
                                style: TextStyle(
                                  color: colorTextLight,
                                ),
                              ),
                            ),
                          ],
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
                        child: Row(
                          children: [
                            ClipOval(
                              child: Container(
                                color: titleColor,
                                height: 22,
                                width: 22,
                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Image(
                                    image: AssetImage(icYouTube),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: TextField(
                                controller:
                                    TextEditingController(text: youtubeUrl),
                                onChanged: (value) => youtubeUrl = value,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'youtube',
                                  hintStyle: TextStyle(
                                    color: colorTextLight,
                                  ),
                                ),
                                style: TextStyle(
                                  color: colorTextLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(onPressed: (){
                        showDialog(
                          context: context,
                          builder: (context) => LoaderDialog(),
                        );
                        ApiService()
                            .updateProfile(
                            fullName!,
                            userName!,
                            userEmail!,
                            bio!,
                            fbUrl!,
                            instaUrl!,
                            youtubeUrl!,
                            gender!,
                            dob!,
                            profileCategory,
                            profileImage.isNotEmpty
                                ? File(profileImage)
                                : null)
                            .then(
                              (value) {
                            if (value.status == 200) {
                              controller
                                  .setUser(value);

                              Navigator.pop(context);
                              Navigator.pop(context);
                              showToast('Update profile successfully..!');
                            }
                          },
                        );
                        ApiService().editAddress(locationController.lat.value,
                            locationController.lng.value, countryId, stateId, stateName??"", address??"Address");

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
