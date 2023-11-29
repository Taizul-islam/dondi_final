import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dondi/model/category_explorer.dart';
import 'package:dondi/model/country_state_data.dart';
import 'package:dondi/pages/upload/UploadController.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as FireBaseAuth1;
import 'package:http_parser/http_parser.dart';
import '../model/agora_token.dart';
import '../model/comment.dart';
import '../model/explore_hash_tag.dart';
import '../model/file_path.dart';
import '../model/follower_following_data.dart';
import '../model/my_wallet.dart';
import '../model/notification.dart';
import '../model/plan/coin_plans.dart';
import '../model/profile_category.dart';
import '../model/rest_response.dart';
import '../model/search_user.dart';
import '../model/setting.dart';
import '../model/single_post.dart';
import '../model/sound/fav/favourite_music.dart';
import '../model/sound/sound.dart';
import '../model/user.dart';
import '../model/user_video.dart';
import '../utils/const.dart';
import '../utils/session_manager.dart';

class ApiService {
  var client = http.Client();
  Future<String> fetchSettingsData() async {
    final response = await client.post(
      Uri.parse(ConstRes.fetchSettingsData),
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        "Accept":"application/json"
      },
    );
    SessionManager sessionManager = SessionManager();
    await sessionManager.initPref();
    sessionManager.saveSetting(response.body);
    return response.body;
  }
  Future<UserNotifications> getNotificationList(String start, String limit) async {
    client = http.Client();
    // print(SessionManager.accessToken);
    final response = await client.post(
      Uri.parse(ConstRes.getNotificationList),
      body: {
        ConstRes.start: start,
        ConstRes.limit: limit,
      },
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        ConstRes.authorization: SessionManager.accessToken!,
        "Accept":"application/json"
      },
    );
    log(response.statusCode.toString());
    final responseJson = jsonDecode(response.body);
    return UserNotifications.fromJson(responseJson);
  }
  Future<RestResponse> logoutUser() async {
    SessionManager sessionManager = SessionManager();
    await sessionManager.initPref();
    final response = await client.post(
      Uri.parse(ConstRes.logoutUser),
      body: {
        ConstRes.userId: SessionManager.userId.toString(),
      },
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        ConstRes.authorization: SessionManager.accessToken!,
        "Accept":"application/json"
      },
    );
    // print(response.body);
    final responseJson = jsonDecode(response.body);
    sessionManager.clean();
    return RestResponse.fromJson(responseJson);
  }
  Future<RestResponse> deletePost(String postId) async {
    final response = await client.post(
      Uri.parse(ConstRes.deletePost),
      body: {
        ConstRes.postId: postId,
      },
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        ConstRes.authorization: SessionManager.accessToken!,
        "Accept":"application/json"
      },
    );

    // print(response.body);
    final responseJson = jsonDecode(response.body);
    return RestResponse.fromJson(responseJson);
  }
  Future<UserVideo> getUserVideos(
      String star, String limit, String? userId, int type) async {
    final response = await client.post(
      Uri.parse(
          type == 0 ? ConstRes.getUserVideos : ConstRes.getUserLikesVideos),
      body: {
        ConstRes.start: star,
        ConstRes.limit: limit,
        ConstRes.userId: userId,
        ConstRes.myUserId: SessionManager.userId.toString()
      },
      headers: {ConstRes.uniqueKey: ConstRes.apiKey,"Accept":"application/json"},
    );
    // print(response.body);
    final responseJson = jsonDecode(response.body);
    return UserVideo.fromJson(responseJson);
  }
  Future<FilePath> filePath({File? filePath}) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ConstRes.fileGivenPath),
    );
    request.headers.addAll({
      ConstRes.uniqueKey: ConstRes.apiKey,
      ConstRes.authorization: SessionManager.accessToken!,
      "Accept":"application/json"
    });
    if (filePath != null) {
      request.files.add(
        http.MultipartFile(
            'file', filePath.readAsBytes().asStream(), filePath.lengthSync(),
            filename: filePath.path.split("/").last),
      );
    }
    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    final responseJson = jsonDecode(respStr);
    print(responseJson);
    FilePath path = FilePath.fromJson(responseJson);
    return path;
  }
  Future<RestResponse> setNotificationSettings(String? deviceToken) async {
    client = http.Client();
    final response = await client.post(
      Uri.parse(ConstRes.setNotificationSettings),
      body: {
        ConstRes.deviceToken: deviceToken,
      },
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        ConstRes.authorization: SessionManager.accessToken!,
        "Accept":"application/json"
      },
    );
    // print(response.body);
    final responseJson = jsonDecode(response.body);
    return RestResponse.fromJson(responseJson);
  }
  Future<RestResponse> verifyRequest(String idNumber, String name,
      String address, File? photoIdImage, File? photoWithIdImage) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(ConstRes.verifyRequest),
    );
    request.headers[ConstRes.uniqueKey] = ConstRes.apiKey;
    request.headers[ConstRes.authorization] = SessionManager.accessToken!;
    request.headers["Accept"] = "application/json";
    request.fields[ConstRes.idNumber] = idNumber;
    request.fields[ConstRes.name] = name;
    request.fields[ConstRes.address] = address;
    if (photoIdImage != null) {
      request.files.add(
        http.MultipartFile(ConstRes.photoIdImage,
            photoIdImage.readAsBytes().asStream(), photoIdImage.lengthSync(),
            filename: photoIdImage.path.split("/").last),
      );
    }
    if (photoWithIdImage != null) {
      request.files.add(
        http.MultipartFile(
            ConstRes.photoWithIdImage,
            photoWithIdImage.readAsBytes().asStream(),
            photoWithIdImage.lengthSync(),
            filename: photoWithIdImage.path.split("/").last),
      );
    }

    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    await getProfile(SessionManager.userId.toString());
    return RestResponse.fromJson(jsonDecode(respStr));
  }

  Future<RestResponse> increasePostViewCount(String postId) async {
    final response = await client.post(
      Uri.parse(ConstRes.increasePostViewCount),
      body: {ConstRes.postId: postId},
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        ConstRes.authorization: SessionManager.accessToken!,
        "Accept":"application/json"
      },
    );

    // print(response.body);
    final responseJson = jsonDecode(response.body);
    return RestResponse.fromJson(responseJson);
  }
  Future<RestResponse> sendCoin(String coin, String toUserId) async {
    final response = await client.post(
      Uri.parse(ConstRes.sendCoin),
      body: {
        ConstRes.coin: coin,
        ConstRes.toUserId: toUserId,
      },
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        ConstRes.authorization: SessionManager.accessToken!,
        "Accept":"application/json"
      },
    );
    // print(response.body);
    final responseJson = jsonDecode(response.body);
    await getProfile(SessionManager.userId.toString());
    return RestResponse.fromJson(responseJson);
  }
  Future<UserVideo> getPostBySoundId(
      String start, String limit, String? soundId) async {
    final response = await client.post(
      Uri.parse(ConstRes.getPostBySoundId),
      body: {
        ConstRes.start: start,
        ConstRes.limit: limit,
        ConstRes.userId: SessionManager.userId.toString(),
        ConstRes.soundId: soundId,
      },
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        "Accept":"application/json"
      },
    );
    final responseJson = jsonDecode(response.body);
    // print(responseJson);
    return UserVideo.fromJson(responseJson);
  }
  Future<RestResponse> likeUnlikePost(String postId) async {
    // print(SessionManager.accessToken);
    final response = await client.post(
      Uri.parse(ConstRes.likeUnlikePost),
      body: {
        ConstRes.postId: postId,
      },
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        ConstRes.authorization: SessionManager.accessToken!,
        "Accept":"application/json"
      },
    );

    final responseJson = jsonDecode(response.body);
    // print(responseJson);
    return RestResponse.fromJson(responseJson);
  }
  Future<UserVideo> getPostsByType({
    required int? pageDataType,
    required String start,
    required String limit,
    String? userId,
    String? soundId,
    String? hashTag,
    String? keyWord,
  }) {
    ///PagedDataType
    ///1 = UserVideo
    ///2 = UserLikesVideo
    ///3 = PostsBySound
    ///4 = PostsByHashTag
    ///5 = PostsBySearch
    switch (pageDataType) {
      case 1:
        return getUserVideos(start, limit, userId, 0);
      case 2:
        return getUserVideos(start, limit, userId, 1);
      case 3:
        return getPostBySoundId(start, limit, soundId);
      case 4:
        return getPostByHashTag(start, limit, hashTag!.replaceAll('#', ''));
      case 5:
        return getSearchPostList(start, limit, userId, keyWord);
    }
    return getPostByHashTag(start, limit, hashTag);
  }
  Future<UserVideo> getSearchPostList(
      String start, String limit, String? userId, String? keyWord) async {
    client = http.Client();
    final response = await client.post(
      Uri.parse(ConstRes.getSearchPostList),
      body: {
        ConstRes.start: start,
        ConstRes.limit: limit,
        ConstRes.userId: userId,
        ConstRes.keyWord: keyWord,
      },
      headers: {ConstRes.uniqueKey: ConstRes.apiKey,"Accept":"application/json",'connection': 'keep-alive',},
    );
    // print(response.body);
    final responseJson = jsonDecode(response.body);
    return UserVideo.fromJson(responseJson);
  }
  Future<CoinPlans> getCoinPlanList() async {
    final response = await client.get(
      Uri.parse(ConstRes.getCoinPlanList),
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        ConstRes.authorization: SessionManager.accessToken!,
        "Accept":"application/json"
      },
    );

    // print(response.body);
    final responseJson = jsonDecode(response.body);
    return CoinPlans.fromJson(responseJson);
  }
  Future<RestResponse> purchaseCoin(String coin) async {
    // print(SessionManager.accessToken + coin);
    final response = await client.post(
      Uri.parse(ConstRes.purchaseCoin),
      body: {ConstRes.coin: coin},
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        ConstRes.authorization: SessionManager.accessToken!,
        "Accept":"application/json"
      },
    );
    // print(response.body);
    final responseJson = jsonDecode(response.body);
    await getProfile(SessionManager.userId.toString());
    return RestResponse.fromJson(responseJson);
  }
  Future<RestResponse> redeemRequest(String amount, String redeemRequestType,
      String account, String coin) async {
    client = http.Client();
    final response = await client.post(
      Uri.parse(ConstRes.redeemRequest),
      body: {
        ConstRes.amount: amount,
        ConstRes.redeemRequestType: redeemRequestType,
        ConstRes.account: account,
        ConstRes.coin: coin,
      },
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        ConstRes.authorization: SessionManager.accessToken!,
        "Accept":"application/json"
      },
    );
    final responseJson = jsonDecode(response.body);
    await getProfile(SessionManager.userId.toString());
    return RestResponse.fromJson(responseJson);
  }
  Future<UserVideo> getPostList(String start, String limit, String userId, String type) async {
    print("start $start");
    print("limit $limit");
    print("userId $userId");
    print("type $type");
    final response = await client.post(
      Uri.parse(ConstRes.getPostList),
      body: {
        ConstRes.start: start,
        ConstRes.limit: limit,
        ConstRes.userId: userId,
        ConstRes.type: type,
      },
      headers: {ConstRes.uniqueKey: ConstRes.apiKey,"Accept":"application/json"},
    );
    print(response.request!.headers);
     print(response.body);
    final responseJson = jsonDecode(response.body);
    return UserVideo.fromJson(responseJson);
  }
  Future<SearchUser> getSearchUser(
      String start, String limit, String keyWord) async {
    try {
      client = http.Client();
      final response = await client.post(
        Uri.parse(ConstRes.getUserSearchPostList),
        body: {
          ConstRes.start: start,
          ConstRes.limit: limit,
          ConstRes.keyWord: keyWord,
        },
        headers: {
          ConstRes.uniqueKey: ConstRes.apiKey,
          "Accept": "application/json",
          'connection': 'keep-alive',
        },
      );

      final responseJson = jsonDecode(response.body);
      return SearchUser.fromJson(responseJson);
    }catch(e){
      throw Exception("");
    }
  }
  Future<MyWallet> getMyWalletCoin() async {
    client = http.Client();
    final response = await client.get(
      Uri.parse(ConstRes.getMyWalletCoin),
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        ConstRes.authorization: SessionManager.accessToken!,
        "Accept":"application/json"
      },
    );
    final responseJson = jsonDecode(response.body);
    return MyWallet.fromJson(responseJson);
  }
  Future<ExploreHashTag> getExploreHashTag(String start, String limit) async {
    final response = await client.post(
      Uri.parse(ConstRes.getExploreHashTag),
      body: {
        ConstRes.start: start,
        ConstRes.limit: limit,
      },
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        "Accept":"application/json"
      },
    );
    // print(response.body);
    final responseJson = jsonDecode(response.body);
    return ExploreHashTag.fromJson(responseJson);
  }
  Future<CategoryOfExplorer> getCategoryOfExplorer(String start, String limit) async {
    final response = await client.get(
      Uri.parse("${ConstRes.urlCategoryWiseVideoCount}?start=$start&limit=$limit"),
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        "Accept":"application/json"
      },
    );
    // print(response.body);
    final responseJson = jsonDecode(response.body);
    return CategoryOfExplorer.fromJson(responseJson);
  }
  Future<UserVideo> getPostByHashTag(
      String start, String limit, String? hashTag) async {
    // print(hashTag);
    final response = await client.get(
      Uri.parse("${ConstRes.videosByHashTag}/$hashTag?start=$start&limit=$limit"),
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        "Accept":"application/json"
      },
    );
    final responseJson = jsonDecode(response.body);
     print(responseJson);
    return UserVideo.fromJson(responseJson);
  }
  Future<RestResponse> deleteComment(String commentID) async {
    final response = await client.post(
      Uri.parse(ConstRes.deleteComment),
      body: {
        ConstRes.commentId: commentID,
      },
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        ConstRes.authorization: SessionManager.accessToken!,
        "Accept":"application/json"
      },
    );

    final responseJson = jsonDecode(response.body);
    return RestResponse.fromJson(responseJson);
  }
  Future<RestResponse> addComment(String comment, String postId) async {
    final response = await client.post(
      Uri.parse(ConstRes.addComment),
      body: {
        ConstRes.postId: postId,
        ConstRes.comment: comment,
      },
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        ConstRes.authorization: SessionManager.accessToken!,
        "Accept":"application/json"
      },
    );

    final responseJson = jsonDecode(response.body);
    // print(responseJson);
    return RestResponse.fromJson(responseJson);
  }
  Future<Comment> getCommentByPostId(
      String start, String limit, String postId) async {
    final response = await client.post(
      Uri.parse(ConstRes.getCommentByPostId),
      body: {
        ConstRes.postId: postId,
        ConstRes.start: start,
        ConstRes.limit: limit,
      },
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        "Accept":"application/json"
      },
    );

    final responseJson = jsonDecode(response.body);
    // print(responseJson);
    return Comment.fromJson(responseJson);
  }
  Future pushNotification(
      {required String authorization,
        required String title,
        required String body,
        required String token}) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Authorization': 'key=$authorization',
        'content-type': 'application/json'

      },
      body: json.encode(
        {
          'notification': {
            'title': title,
            'body': body,
            "sound": "default",
            "badge": "1"
          },
          'to': '/token/$token',
        },
      ),
    );
  }
  Future<FollowerFollowingData> getFollowersList(
      String userId, String start, String count, int type) async {
    final response = await client.post(
      Uri.parse(
          type == 0 ? ConstRes.getFollowerList : ConstRes.getFollowingList),
      body: {
        ConstRes.userId: userId,
        ConstRes.start: start,
        ConstRes.limit: count,
      },
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        ConstRes.authorization: SessionManager.accessToken!,
        "Accept":"application/json"
      },
    );

    final responseJson = jsonDecode(response.body);
    // print(responseJson);
    return FollowerFollowingData.fromJson(responseJson);
  }
  Future<RestResponse> reportUserOrPost(
      String reportType,
      String? postIdOrUserId,
      String? reason,
      String description,
      String contactInfo,
      ) async {
    final response = await client.post(
      Uri.parse(ConstRes.reportPostOrUser),
      body: {
        ConstRes.reportType: reportType,
        reportType == '1' ? ConstRes.userId : ConstRes.postId: postIdOrUserId,
        ConstRes.reason: reason,
        ConstRes.description: description,
        ConstRes.contactInfo: contactInfo,
      },
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        ConstRes.authorization: SessionManager.accessToken!,
        "Accept":"application/json"
      },
    );

    // print(response.body);
    final responseJson = jsonDecode(response.body);
    return RestResponse.fromJson(responseJson);
  }
  Future<RestResponse> deleteAccount() async {
    SessionManager sessionManager = new SessionManager();
    await sessionManager.initPref();
    await FireBaseAuth1.FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    //FacebookAuth.instance.logOut();
    // print(SessionManager.accessToken);
    final response = await client.post(
      Uri.parse(ConstRes.deleteAccount),
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        ConstRes.authorization: SessionManager.accessToken!,
        "Accept":"application/json"
      },
    );

    // print(response.body);
    final responseJson = jsonDecode(response.body);
    sessionManager.clean();
    return RestResponse.fromJson(responseJson);
  }

  Future<User> registerUser(Map<String, String?> params) async {
    final response = await client.post(
      Uri.parse(ConstRes.registerUser),
      body: params,
      headers: {ConstRes.uniqueKey: ConstRes.apiKey,"Accept":"application/json"},
    );
    final responseJson = jsonDecode(response.body);
    SessionManager sessionManager = SessionManager();
    await sessionManager.initPref();
    print("user_response: ${jsonEncode(User.fromJson(responseJson))}");
    sessionManager.saveUser(
      jsonEncode(
        User.fromJson(responseJson),
      ),
    );
    return User.fromJson(responseJson);
  }

  Future<FavouriteMusic> getFavouriteSoundList() async {
    SessionManager sessionManager = new SessionManager();
    await sessionManager.initPref();
    final response = await client.post(
      Uri.parse(ConstRes.getFavouriteSoundList),
      body: jsonEncode(<String, List<String>>{
        'sound_ids': sessionManager.getFavouriteMusic(),
      }),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        ConstRes.uniqueKey: ConstRes.apiKey,
        ConstRes.authorization: SessionManager.accessToken!,
        "Accept":"application/json"
      },
    );

    // print(response.body);
    final responseJson = jsonDecode(response.body);
    return FavouriteMusic.fromJson(responseJson);
  }

  Future<String> addPost({
    required String postDescription,
    String? postHashTag,
    required String isOrignalSound,
    String? soundTitle,
    String? duration,
    String? singer,
    String? soundId,
    File? postVideo,
    File? thumbnail,
    File? postSound,
    File? soundImage,
    required String categoryId,
    required UploadController controller
  }) async {
    try {
      dio.Dio dioClient = dio.Dio();
      dio.FormData formData = dio.FormData();
      formData.fields.add(MapEntry("category_id", categoryId));
      formData.fields.add(MapEntry(ConstRes.postDescription, postDescription));
      formData.fields.add(MapEntry(ConstRes.isOrignalSound, isOrignalSound));
      formData.fields.add(MapEntry(ConstRes.postHashTag,
          postHashTag == null || postHashTag.isEmpty
              ? 'bubbletok'
              : postHashTag));
      if (isOrignalSound == '1') {
        formData.fields.add(MapEntry(ConstRes.soundTitle, soundTitle!));
        formData.fields.add(MapEntry(ConstRes.duration, duration!));
        formData.fields.add(MapEntry(ConstRes.singer, singer!));
        if (postSound != null) {
          formData.files.add(MapEntry(ConstRes.postSound,
              await dio.MultipartFile.fromFile(
                  postSound.path, filename: postSound.path
                  .split('/')
                  .last,
                  contentType: MediaType("audio", "wav"))));
        }
        if (soundImage != null) {
          formData.files.add(MapEntry(ConstRes.soundImage,
              await dio.MultipartFile.fromFile(
                  soundImage.path, filename: soundImage.path
                  .split('/')
                  .last,
                  contentType: MediaType("image", "png"))));
        }
      } else {
        formData.fields.add(MapEntry(ConstRes.soundId, soundId!));
      }
      if (postVideo != null) {
        formData.files.add(MapEntry(ConstRes.postVideo,
            await dio.MultipartFile.fromFile(
                postVideo.path, filename: postVideo.path
                .split('/')
                .last,
                contentType: MediaType("video", "mp4"))));
      }
      if (thumbnail != null) {
        formData.files.add(MapEntry(ConstRes.postImage,
            await dio.MultipartFile.fromFile(
                thumbnail.path, filename: thumbnail.path
                .split('/')
                .last,
                contentType: MediaType("image", "png"))));
      }
      dioClient.options.headers["Accept"] = "application/json";
      dioClient.options.headers[ConstRes.uniqueKey] = ConstRes.apiKey;
      dioClient.options.headers[ConstRes.authorization] =
      SessionManager.accessToken!;
      dioClient.options.contentType='multipart/form-data';
      dioClient.options.followRedirects = false;
      dioClient.options.validateStatus = (status) => true;
      var res = await dioClient.post(
          ConstRes.addPost, data: formData, onSendProgress: (sent, total) {
        controller.progressPercentage.value =
        "${(sent / total * 100).toStringAsFixed(0)}%";
        controller.progressValue.value = (sent / total).toDouble();
      });
      print("siam ${res.statusCode}");
      print("siam ${res.data}");
      log("siam ${res.data}");
      addCoin();
      if(res.statusCode==200){
        return "success";
      }else{
        return "failed";
      }

    }on dio.DioError catch(e){
      return "failed";
    }

  }

  Future<CoinPlans> addCoin() async {
    final response = await client.post(
      Uri.parse(ConstRes.addCoin),
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        ConstRes.authorization: SessionManager.accessToken!,
        "Accept":"application/json"
      },
      body: {ConstRes.rewardingActionId: '3'},
    );

    // print(response.body);
    final responseJson = jsonDecode(response.body);
    await getProfile(SessionManager.userId.toString());
    return CoinPlans.fromJson(responseJson);
  }
  Future<void> updateLocation(double lat,double lng) async {
    var body={
      "c_lat":lat.toString(),
      "c_lng":lng.toString(),
    };
    final response = await client.post(
      Uri.parse(ConstRes.updateLocation),
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        ConstRes.authorization: SessionManager.accessToken!,
        "Accept":"application/json"
      },
      body: body,
    );
    print(response.body);

  }
  Future<void> editAddress(double lat,double lng,String countryId,String stateId,String city,String address) async {
    var body={
      "c_lat":lat.toString(),
      "c_lng":lng.toString(),
      "country_id":countryId,
      "state_id":stateId,
      "city":city,
      "address":address
    };
    final response = await client.post(
      Uri.parse(ConstRes.updateLocation),
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        ConstRes.authorization: SessionManager.accessToken!,
        "Accept":"application/json"
      },
      body: body,
    );
    print(response.body);
    log(response.body);

  }
  Future<User> getProfile(String? userId) async {
    Map<String, dynamic> map = {};
    if (SessionManager.userId != -1) {
      map[ConstRes.myUserId] = SessionManager.userId.toString();
    }
    map[ConstRes.userId] = userId;
    final response = await client.post(
      Uri.parse(ConstRes.getProfile),
      body: map,
      headers: {ConstRes.uniqueKey: ConstRes.apiKey,"Accept":"application/json"},
    );
    final responseJson = jsonDecode(response.body);
     print(responseJson);
    if (userId == SessionManager.userId.toString()) {
      SessionManager sessionManager = SessionManager();
      await sessionManager.initPref();
      // print(response.body);
      User user = User.fromJson(responseJson);
      if (SessionManager.accessToken != null &&
          SessionManager.accessToken!.isNotEmpty) {
        user.data?.setToken(SessionManager.accessToken);
      }
      sessionManager.saveUser(jsonEncode(user));
    }

    // print(response.body);
    return User.fromJson(responseJson);
  }

  Future<Sound> getSoundList() async {
    final response = await client.get(
      Uri.parse(ConstRes.getSoundList),
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        ConstRes.authorization: SessionManager.accessToken!,
        "Accept":"application/json"
      },
    );

    final responseJson = jsonDecode(response.body);
    // print(responseJson);
    return Sound.fromJson(responseJson);
  }
  Future<SinglePost> getPostByPostId(String postId) async {
    final response = await client.post(
      Uri.parse(ConstRes.getPostListById),
      body: {
        ConstRes.postId: postId,
      },
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        "Accept":"application/json"
      },
    );

    // print(response.body);
    final responseJson = jsonDecode(response.body);
    return SinglePost.fromJson(responseJson);
  }

  Future<FavouriteMusic> getSearchSoundList(String keyword) async {
    client = http.Client();
    SessionManager sessionManager = new SessionManager();
    await sessionManager.initPref();
    final response = await client.post(
      Uri.parse(ConstRes.getSearchSoundList),
      body: {
        ConstRes.keyWord: keyword,
      },
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        ConstRes.authorization: SessionManager.accessToken!,
        "Accept":"application/json"
      },
    );

    // print(response.body);
    final responseJson = jsonDecode(response.body);
    return FavouriteMusic.fromJson(responseJson);
  }
  Future<RestResponse> blockUser(String? userId) async {
    final response = await client.post(
      Uri.parse(ConstRes.blockUser),
      body: {
        ConstRes.userId: userId,
      },
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        ConstRes.authorization: SessionManager.accessToken!,
        "Accept":"application/json"
      },
    );

    // print(response.body);
    final responseJson = jsonDecode(response.body);
    return RestResponse.fromJson(responseJson);
  }
  Future<RestResponse> followUnFollowUser(String toUserId) async {
    final response = await client.post(
      Uri.parse(ConstRes.followUnFollowPost),
      body: {
        ConstRes.toUserId: toUserId,
      },
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        ConstRes.authorization: SessionManager.accessToken!,
        "Accept":"application/json"
      },
    );

    final responseJson = jsonDecode(response.body);
    // print(responseJson);
    return RestResponse.fromJson(responseJson);
  }
  Future<User> updateProfile(
      String fullName,
      String userName,
      String userEmail,
      String bio,
      String fbUrl,
      String instaUrl,
      String youtubeUrl,
      String gender,
      String dob,
      String profileCategory,
      File? profileImage,
      ) async {

    var request = http.MultipartRequest(
      "POST",
      Uri.parse(ConstRes.updateProfile),
    );
    request.headers[ConstRes.uniqueKey] = ConstRes.apiKey;
    request.headers[ConstRes.authorization] = SessionManager.accessToken!;
    request.headers["Accept"] = "application/json";
    request.fields[ConstRes.fullName] = fullName;
    request.fields[ConstRes.userName] = userName;
    request.fields[ConstRes.userEmail] = userEmail;
    request.fields[ConstRes.bio] = bio;
    request.fields["dob"] = dob;
    request.fields["gender"] = gender;
    request.fields[ConstRes.fbUrl] = fbUrl;
    request.fields[ConstRes.instaUrl] = instaUrl;
    request.fields[ConstRes.youtubeUrl] = youtubeUrl;
    if (profileCategory.isNotEmpty) {
      request.fields[ConstRes.profileCategory] = profileCategory;
    }
    if (profileImage != null) {
      request.files.add(
        http.MultipartFile(ConstRes.userProfile,
            profileImage.readAsBytes().asStream(), profileImage.lengthSync(),
            filename: profileImage.path.split("/").last),
      );
    }

    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    User user = User.fromJson(jsonDecode(respStr));
    if (user.data!.userId.toString() == SessionManager.userId.toString()) {
      SessionManager sessionManager = SessionManager();
      await sessionManager.initPref();
      if (SessionManager.accessToken != null &&
          SessionManager.accessToken!.isNotEmpty) {
        user.data!.setToken(SessionManager.accessToken);
      }
      sessionManager.saveUser(jsonEncode(user));
    }
    return User.fromJson(jsonDecode(respStr));
  }
  Future<ProfileCategory> getProfileCategoryList() async {
    client = http.Client();
    final response = await client.get(
      Uri.parse(ConstRes.getProfileCategoryList),
      headers: {
        ConstRes.uniqueKey: ConstRes.apiKey,
        ConstRes.authorization: SessionManager.accessToken!,
        "Accept":"application/json"
      },
    );
    final responseJson = jsonDecode(response.body);
    return ProfileCategory.fromJson(responseJson);
  }
  Future<CountryStateData> getCountryList() async {
    client = http.Client();
    final response = await client.get(
      Uri.parse(ConstRes.getCountryApi),
      headers: {
        "Accept":"application/json"
      },
    );
    final responseJson = jsonDecode(response.body);
    return CountryStateData.fromJson(responseJson);
  }

  Future<CountryStateData> getVideoCategoryList() async {
    client = http.Client();
    final response = await client.get(
      Uri.parse(ConstRes.urlCategory),
      headers: {
        "Accept":"application/json"
      },
    );
    final responseJson = jsonDecode(response.body);
    return CountryStateData.fromJson(responseJson);
  }
  
  Future<CountryStateData> getSateList(String countryId) async {
    client = http.Client();
    final response = await client.get(
      Uri.parse("${ConstRes.getCountryApi}/$countryId/states"),
      headers: {
        "Accept":"application/json"
      },
    );
    final responseJson = jsonDecode(response.body);
    return CountryStateData.fromJson(responseJson);
  }
  Future<AgoraToken> generateAgoraToken(String? channelName) async {
    final response =
    await client.post(Uri.parse(ConstRes.generateAgoraToken), headers: {
      ConstRes.authorization: SessionManager.accessToken!,
      ConstRes.uniqueKey: ConstRes.apiKey,
      "Accept":"application/json"
    }, body: {
      ConstRes.channelName: channelName
    });
    print(response.body);
    return AgoraToken.fromJson(jsonDecode(response.body));
  }






}
