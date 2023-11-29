
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../model/user.dart';
import 'const.dart';

class MyLoading extends GetxController {
  var selectedHomeScreen = 0.obs;


  setIsForYouSelected(int isForYou) {
    selectedHomeScreen.value = isForYou;
    update();
  }

  var selectedItem = 0.obs;


  setSelectedItem(int selected) {
    selectedItem.value = selected;
    update();
  }

  var profilePageIndex = 0.obs;


  setProfilePageIndex(int profilePage) {
    profilePageIndex.value = profilePage;
    update();
  }

  var notificationPageIndex = 0.obs;

  setNotificationPageIndex(int notificationPage) {
    notificationPageIndex.value = notificationPage;
    update();
  }

  var searchPageIndex = 0.obs;



  setSearchPageIndex(int searchPage) {
    searchPageIndex.value = searchPage;
    update();
  }

  var followerPageIndex = 0.obs;



  setFollowerPageIndex(int searchPageIndex) {
    followerPageIndex.value = searchPageIndex;
    update();
  }

  var musicPageIndex = 0.obs;



  setMusicPageIndex(int searchPageIndex) {
    musicPageIndex.value = searchPageIndex;

  }

  var user=User().obs;


  setUser(User u) {
    user.value= u;
    update();
  }

  var isScrollProfileVideo = false.obs;


  setScrollProfileVideo(bool isScrollProfile) {
    isScrollProfileVideo.value = isScrollProfile;
    update();
  }

  var searchText = ''.obs;



  setSearchText(String search) {
    searchText.value = search;
    update();
  }

  var musicSearchText = ''.obs;


  setMusicSearchText(String musicSearch) {
    musicSearchText.value = musicSearch;
    update();
  }

  var isSearchMusic = false.obs;


  setIsSearchMusic(bool isSearch) {
    isSearchMusic.value = isSearch;
    update();

  }

  var lastSelectSoundId = ''.obs;


  setLastSelectSoundId(String lastSelectSound) {
    lastSelectSoundId.value = lastSelectSound;
    update();

  }

  var lastSelectSoundIsPlay = false.obs;


  setLastSelectSoundIsPlay(bool lastSelectSoundIs) {
    lastSelectSoundIsPlay.value = lastSelectSoundIs;
    update();
  }

  var isDownloadClick = false.obs;


  setIsDownloadClick(bool isDownload) {
    isDownloadClick.value = isDownload;
    update();

  }

  var isUserBlockOrNot = false.obs;


  setIsUserBlockOrNot(bool isDownload) {
    isUserBlockOrNot.value = isDownload;
    update();
  }

  var isHomeDialogOpen = ConstRes.isDialog.obs;


  setIsHomeDialogOpen(bool isHome) {
    isHomeDialogOpen.value = isHome;
    update();
  }
}
