import 'dart:developer';

import 'package:dondi/api/api_service.dart';
import 'package:dondi/utils/session_manager.dart';
import 'package:location/location.dart';
import 'package:get/get.dart';

import '../model/user.dart';
import '../utils/my_loading.dart';


class CollectLatLngController extends GetxController{
  var lat=0.0.obs;
  var lng=0.0.obs;
  final controller=Get.put(MyLoading());
  SessionManager sessionManager=SessionManager();

  @override
  void onInit() {
    getLatLng();
    super.onInit();
  }

  Future getLatLng() async {
    await sessionManager.initPref();
    if(sessionManager.getUser()==null){
      return;
    }
    var location = Location();


    if (!await location.serviceEnabled()) {
      if (!await location.requestService()) {
        return;
      }
    }

    var permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) {
        return;
      }
    }

    var loc = await location.getLocation();
    lat.value=loc.latitude!;
    lng.value=loc.longitude!;
    if(sessionManager.getUser()!=null&&sessionManager.getUser()!.data!.token!.isNotEmpty){
      await ApiService().updateLocation(lat.value, lng.value);
    }


  }





}