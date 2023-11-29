

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../model/setting.dart';
import '../widget/dialog/loader_dialog.dart';
const colorPrimary = Colors.black;
const colorPrimaryDark = Color(0xFF15161a);
const colorTheme = Color(0xFF6e33f7);
const colorIcon = Color(0xFF9706ff);
const colorPink = Color(0xFF9706ff);
const colorTextLight = Color(0xFF666D7E);
const colorLightWhite = Color(0xFFf1f1f3);
const PrivacyUrl = 'https://flutter.io';
const isNotificationOn = 'is_notification_on';
const INTRODONE="INTRODONE";
const LOCATIONUPDATED="LOCATIONUPDATED";
showToast(String message) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}

void showLoader() {
  showDialog(
    context: Get.context!,
    builder: (context) => LoaderDialog(),
  );
}

//Strings
const byFlutterMaster = 'By FlutterMaster';
const following = 'Following';
const forYou = 'For You';

class ConstRes {
  static final String baseUrl = 'http://fari.us-east-1.elasticbeanstalk.com/api/';
  static const String apiKey = "dev123";
  static const String itemBase = "https://dondi-media.s3.amazonaws.com/";
  static final String itemBaseUrl = '${itemBase}bubbly/';
  static final String chatItemBaseUrl = '${itemBase}bubbly/';
   //static final String itemBaseUrl1 = 'http://retry.s3.amazonaws.com/uploads/';
  ///RegisterUser
  static final String registerUser = baseUrl + 'User/Registration';
  static final String deviceToken = 'device_token';
  static final String userEmail = 'user_email';
  static final String fullName = 'full_name';
  static final String loginType = 'login_type';
  static final String userName = 'user_name';
  static final String identity = 'identity';
  static final String platform = 'platform';
  ///getUserVideos getUserLikesVideos
  static final String getUserVideos = baseUrl + 'Post/getUserVideos';
  static final String getUserLikesVideos = baseUrl + 'Post/getUserLikesVideos';
  static final String start = 'start';
  static final String limit = 'limit';
  static final String userId = 'user_id';
  static final String myUserId = 'my_user_id';
  /// getPostList
  ///type follow and related
  static final String getPostList = baseUrl + 'Post/getPostList';
  static final String type = 'type';
  static final String following = 'follow';
  static final String trending = 'trending';
  static final String related = 'related';
  ///LikeUnlikeVideo
  static final String likeUnlikePost = baseUrl + 'Post/LikeUnlikePost';
  static final String postId = 'post_id';
  ///CommentListByPostId
  static final String getCommentByPostId = baseUrl + 'Post/getCommentByPostId';
  ///addComment
  static final String addComment = baseUrl + 'Post/addComment';
  static final String comment = 'comment';
  ///deleteComment
  static final String deleteComment = baseUrl + 'Post/deleteComment';
  static final String commentId = 'comments_id';
  ///getVideoByHashTag
  //static final String videosByHashTag = baseUrl + 'Post/getSingleHashTagPostList';
  static final String videosByHashTag = baseUrl + 'categoryWiseVideos';
  static final String hashTag = 'hash_tag';
  ///getVideoBySoundId
  static final String getPostBySoundId = baseUrl + 'Post/getPostBySoundId';
  static final String soundId = 'sound_id';
  ///sendCoin
  static final String sendCoin = baseUrl + 'Wallet/sendCoin';
  static final String coin = 'coin';
  static final String toUserId = 'to_user_id';
  ///getExploreHashTag
  static final String getExploreHashTag = baseUrl + 'Post/getExploreHashTagPostList';
  ///getUserSearchPostList
  static final String getUserSearchPostList = baseUrl + 'Post/getUserSearchPostList';
  static final String keyWord = 'keyword';
  ///getSearchPostList
  static final String getSearchPostList = baseUrl + 'Post/getSearchPostList';
  ///getNotificationList
  static final String getNotificationList = baseUrl + 'User/getNotificationList';
  ///setNotificationSettings
  static final String setNotificationSettings = baseUrl + 'User/setNotificationSettings';
  ///getCoinRateList
  static final String getCoinRateList = baseUrl + 'Wallet/getCoinRateList';
  ///getRewardingActionList
  static final String getRewardingActionList = baseUrl + 'Wallet/getRewardingActionList';
  ///getMyWalletCoin
  static final String getMyWalletCoin = baseUrl + 'Wallet/getMyWalletCoin';
  ///redeemRequest
  static final String redeemRequest = baseUrl + 'Wallet/redeemRequest';
  static final String amount = 'amount';
  static final String redeemRequestType = 'redeem_request_type';
  static final String account = 'account';
  ///verifyRequest
  static final String verifyRequest = baseUrl + 'User/verifyRequest';
  static final String idNumber = 'id_number';
  static final String name = 'name';
  static final String address = 'address';
  static final String photoIdImage = 'photo_id_image';
  static final String photoWithIdImage = 'photo_with_id_image';
  ///getProfile
  static final String getProfile = baseUrl + 'User/getProfile';
  ///getProfileCategoryList
  static final String getProfileCategoryList = baseUrl + 'User/getProfileCategoryList';
  ///updateProfile
  static final String updateProfile = baseUrl + 'User/updateProfile';
  static final String bio = 'bio';
  static final String fbUrl = 'fb_url';
  static final String instaUrl = 'insta_url';
  static final String youtubeUrl = 'youtube_url';
  static final String userProfile = 'user_profile';
  static final String profileCategory = 'profile_category';
  ///FollowUnFollowPost
  static final String followUnFollowPost = baseUrl + 'Post/FollowUnfollowPost';
  ///getFollowerList
  static final String getFollowerList = baseUrl + 'Post/getFollowerList';
  ///getFollowingList
  static final String getFollowingList = baseUrl + 'Post/getFollowingList';
  ///getSoundList
  static final String getSoundList = baseUrl + 'Post/getSoundList';
  ///getFavouriteSoundList
  static final String getFavouriteSoundList = baseUrl + 'Post/getFavouriteSoundList';
  ///getSearchSoundList
  static final String getSearchSoundList = baseUrl + 'Post/getSearchSoundList';
  ///generateAgoraToken
  static final String generateAgoraToken = baseUrl + 'User/generateAgoraToken';
  static final String updateLocation = baseUrl + 'User/updateLocation';
  static final String getCountryApi = baseUrl + 'countries';
  static final String channelName = 'channelName';
  ///addPost
  static final String addPost = baseUrl + 'Post/addPost';
  static final String postDescription = 'post_description';
  static final String postHashTag = 'post_hash_tag';
  static final String postVideo = 'post_video';
  static final String postImage = 'post_image';
  static final String isOrignalSound = 'is_orignal_sound';
  static final String postSound = 'post_sound';
  static final String soundTitle = 'sound_title';
  static final String duration = 'duration';
  static final String singer = 'singer';
  static final String soundImage = 'sound_image';
  ///Logout
  static final String logoutUser = baseUrl + 'User/Logout';
  ///DeleteAccount
  static final String deleteAccount = baseUrl + 'User/deleteMyAccount';
  ///DeletePost
  static final String deletePost = baseUrl + 'Post/deletePost';
  ///ReportPost
  static final String reportPostOrUser = baseUrl + 'Post/ReportPost';
  static final String reportType = 'report_type';
  static final String reason = 'reason';
  static final String description = 'description';
  static final String contactInfo = 'contact_info';
  ///BlockUser
  static final String blockUser = baseUrl + 'User/blockUser';
  ///getPostListById
  static final String getPostListById = baseUrl + 'Post/getPostListById';
  ///getCoinPlanList
  static final String getCoinPlanList = baseUrl + 'Wallet/getCoinPlanList';
  ///addCoin
  static final String addCoin = baseUrl + 'Wallet/addCoin';
  static final String rewardingActionId = 'rewarding_action_id';
  ///purchaseCoin
  static final String purchaseCoin = baseUrl + 'Wallet/purchaseCoin';
  ///IncreasePostViewCount
  static final String increasePostViewCount = baseUrl + 'Post/IncreasePostViewCount';
  ///fetchSettingsData
  static final String fetchSettingsData = baseUrl + 'fetchSettingsData';
  /// uploadFileGivenPath
  static final String fileGivenPath = baseUrl + 'uploadFileGivePath';
  static final String urlCategory = baseUrl + 'categories';
  static final String urlCategoryWiseVideoCount = baseUrl + 'categoryWiseVideoCount';
  static final String uniqueKey = 'unique-key';
  static final String authorization = 'Authorization';
  static final String favourite = 'favourite';
  static final int count = 10;
  static final String isLogin = 'is_login';
  static final String camera = '';
  static final String bubblyCamera = 'bubbly_camera';
  static final String isAccepted = 'is_accepted';
  static final String helpUrl = 'https://flutter.io';
  static final String privacyUrl = 'https://flutter.io';
  static final String termsOfUseUrl = 'https://flutter.io';

  static final bool isDialog = false;
}

class FirebaseConst {
  static const String userChatList = 'userChatList';
  static const String userList = 'userList';
  static const String time = 'time';
  static const String lastMsg = 'lastMsg';
  static const String image = 'image';
  static const String video = 'video';
  static const String user = 'user';
  static const String chat = 'chat';
  static const String chatList = 'chatList';
  static const String blockFromOther = 'blockFromOther';
  static const String block = 'block';
  static const String noDeletedId = 'not_deleted_identities';
  static const String liveStreamUser = 'liveStreamUser';
  static const String id = 'id';
  static const String comment = 'comment';
  static const String watchingCount = 'watchingCount';
  static const String collectedDiamond = 'collectedDiamond';
  static const String timing = 'timing';
  static const String watching = 'watching';
  static const String collected = 'collected';
  static const String profileImage = 'profileImage';
  static const String joinedUser = 'joinedUser';
}
double calculateDistance(lat1, lon1, lat2, lon2){
  double R = 6371.0;
  print("video ${lat2}");
  print("video ${lon2}");
  double dLat = (lat2-lat1)*pi/180.0;
  double dLon = (lon2-lon1)*pi/180.0;
  lat1 = lat1*pi/180.0;
  lat2 = lat2*pi/180.0;

  double a = sin(dLat/2.0) * sin(dLat/2.0) +
      sin(dLon/2.0) * sin(dLon/2.0) * cos(lat1) * cos(lat2);
  double c = 2 * atan2(sqrt(a), sqrt(1-a));
  double d = R * c;

  return d;
}
class SettingRes {
  static String? admobBanner = 'ca-app-pub-3940256099942544/6300978111';
  static String? admobInt = '';
  static String? admobIntIos = '';
  static String? admobBannerIos = '';
  static String? maxUploadDaily = '';
  static String? liveMinViewers = '';
  static String? liveTimeout = '';
  static String? rewardVideoUpload = '';
  static String? minFansForLive = '';
  static String? minFansVerification = '';
  static String? minRedeemCoins = '';
  static String? coinValue = '';
  static String? currency = '';
  static String? agoraAppId = '';
  static List<Gifts>? gifts = [];
}

class AgoraRes {
  static String channelName = "";
  static String token = "";
}
