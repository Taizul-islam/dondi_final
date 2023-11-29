import 'dart:math';
import 'package:get/get.dart';

import '../location_service/location_service.dart';
class UserVideo {
  int? _status;
  String? _message;
  List<Data>? _data;
  int? _totalVideos;

  int? get status => _status;

  String? get message => _message;

  List<Data>? get data => _data;

  int? get totalVideos => _totalVideos;

  UserVideo(
      {int? status, String? message, List<Data>? data, int? totalVideos}) {
    _status = status;
    _message = message;
    _data = data;
    _totalVideos = totalVideos;
  }

  UserVideo.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    _totalVideos = json["total_videos"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    if (_data != null) {
      map["data"] = _data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Data {
  int? _postId;
  int? _userId;
  String? _fullName;
  String? _userName;
  String? _userProfile;
  int? _isVerify;
  int? _isTrending;
  String? _postDescription;
  String? _postHashTag;
  String? _postVideo;
  String? _postImage;
  String? _profileCategoryName;
  int? _soundId;
  String? _soundTitle;
  String? _duration;
  String? _singer;
  String? _soundImage;
  String? _sound;
  int? _postLikesCount;
  int? _postCommentsCount;
  int? _postViewCount;
  String? _createdDate;
  int? _videoLikesOrNot;
  int? _followOrNot;
  int? _isBookmark;
  int? _canComment;
  int? _canDuet;
  int? _canSave;
  String? _user_country_flag;
  double? _user_lat;
  double? _user_lng;

  int? get postId => _postId;

  int? get userId => _userId;

  String? get fullName => _fullName;

  String? get userName => _userName;

  String? get userProfile => _userProfile;

  int? get isVerify => _isVerify;

  int? get isTrending => _isTrending;

  String? get postDescription => _postDescription;

  String? get postHashTag => _postHashTag;

  String? get postVideo => _postVideo;

  String? get postImage => _postImage;

  String? get profileCategoryName => _profileCategoryName;

  int? get soundId => _soundId;

  String? get soundTitle => _soundTitle;

  String? get duration => _duration;

  String? get singer => _singer;

  String? get soundImage => _soundImage;

  void setVideoLikesOrNot(int value) {
    _videoLikesOrNot = value;
    if (value == 0) {
      _postLikesCount = _postLikesCount! - 1;
    } else {
      _postLikesCount = _postLikesCount! + 1;
    }
  }

  void setPostCommentCount(bool isAdd) {
    if (isAdd) {
      _postCommentsCount = _postCommentsCount! + 1;
    } else {
      _postCommentsCount = _postCommentsCount! - 1;
    }
  }

  String? get sound => _sound;

  int? get postLikesCount => _postLikesCount;

  int? get postCommentsCount => _postCommentsCount;

  int? get postViewCount => _postViewCount;

  String? get createdDate => _createdDate;

  int? get videoLikesOrNot => _videoLikesOrNot;

  int? get followOrNot => _followOrNot;

  int? get isBookmark => _isBookmark;

  int? get canComment => _canComment;

  int? get canDuet => _canDuet;

  int? get canSave => _canSave;
  String? get user_country_flag => _user_country_flag;
  double? get user_lat => _user_lat;
  double? get user_lng => _user_lng;

  Data(
      {int? postId,
      int? userId,
      String? fullName,
      String? userName,
      String? userProfile,
      int? isVerify,
      int? isTrending,
      String? postDescription,
      String? postHashTag,
      String? postVideo,
      String? postImage,
      String? profileCategoryId,
      String? profileCategoryName,
      int? soundId,
      String? soundTitle,
      String? duration,
      String? singer,
      String? soundImage,
      String? sound,
      int? postLikesCount,
      int? postCommentsCount,
      int? postViewCount,
      String? createdDate,
      int? videoLikesOrNot,
      int? followOrNot,
      int? isBookmark,
      int? canComment,
      int? canDuet,
      int? canSave,
      String? user_country_flag,
      double? user_lat,
      double? user_lng,
      int? distance,
      }) {
    _postId = postId;
    _userId = userId;
    _fullName = fullName;
    _userName = userName;
    _userProfile = userProfile;
    _isVerify = isVerify;
    _isTrending = isTrending;
    _postDescription = postDescription;
    _postHashTag = postHashTag;
    _postVideo = postVideo;
    _postImage = postImage;
    _profileCategoryName = profileCategoryName;
    _soundId = soundId;
    _soundTitle = soundTitle;
    _duration = duration;
    _singer = singer;
    _soundImage = soundImage;
    _sound = sound;
    _postLikesCount = postLikesCount;
    _postCommentsCount = postCommentsCount;
    _postViewCount = postViewCount;
    _createdDate = createdDate;
    _videoLikesOrNot = videoLikesOrNot;
    _followOrNot = followOrNot;
    _isBookmark = isBookmark;
    _canComment = canComment;
    _canDuet = canDuet;
    _canSave = canSave;
    _user_country_flag = user_country_flag;
    _user_lat = user_lat;
    _user_lng = user_lng;

  }

  Data.fromJson(dynamic json) {
    _postId = json["post_id"];
    _userId = json["user_id"];
    _fullName = json["full_name"];
    _userName = json["user_name"];
    _userProfile = json["user_profile"];
    _isVerify = json["is_verify"];
    _isTrending = json["is_trending"];
    _postDescription = json["post_description"];
    _postHashTag = json["post_hash_tag"];
    _postVideo = json["post_video"];
    _postImage = json["post_image"];
    _profileCategoryName = json["profile_category_name"];
    var sound=json["sound_id"]??0;
    if(sound is int){
      _soundId = json["sound_id"];
    }else{
      _soundId = int.parse(json["sound_id"]);
    }
    
    _soundTitle = json["sound_title"];
    _duration = json["duration"];
    _singer = json["singer"];
    _soundImage = json["sound_image"];
    _sound = json["sound"];
    _postLikesCount = json["post_likes_count"];
    _postCommentsCount = json["post_comments_count"];
    _postViewCount = json["post_view_count"];
    _createdDate = json["created_date"];
    _videoLikesOrNot = json["video_likes_or_not"];
    _followOrNot = json["follow_or_not"];
    _isBookmark = json["is_bookmark"];
    _canComment = json["can_comment"];
    _canDuet = json["can_duet"];
    _canSave = json["can_save"];
    _user_country_flag = json["user_country_flag"];
    _user_lat = double.parse(json["user_lat"]??"0.0");
    _user_lng = double.parse(json["user_lng"]??"0.0");

  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["post_id"] = _postId;
    map["user_id"] = _userId;
    map["full_name"] = _fullName;
    map["user_name"] = _userName;
    map["user_profile"] = _userProfile;
    map["is_verify"] = _isVerify;
    map["is_trending"] = _isTrending;
    map["post_description"] = _postDescription;
    map["post_hash_tag"] = _postHashTag;
    map["post_video"] = _postVideo;
    map["post_image"] = _postImage;
    map["profile_category_name"] = _profileCategoryName;
    map["sound_id"] = _soundId;
    map["sound_title"] = _soundTitle;
    map["duration"] = _duration;
    map["singer"] = _singer;
    map["sound_image"] = _soundImage;
    map["sound"] = _sound;
    map["post_likes_count"] = _postLikesCount;
    map["post_comments_count"] = _postCommentsCount;
    map["post_view_count"] = _postViewCount;
    map["created_date"] = _createdDate;
    map["video_likes_or_not"] = _videoLikesOrNot;
    map["follow_or_not"] = _followOrNot;
    map["is_bookmark"] = _isBookmark;
    map["can_comment"] = _canComment;
    map["can_duet"] = _canDuet;
    map["can_save"] = _canSave;
    return map;
  }
}


