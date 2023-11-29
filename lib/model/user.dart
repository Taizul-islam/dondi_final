class User {
  int? _status;
  String? _message;
  Data? _data;

  int? get status => _status;

  String? get message => _message;

  Data? get data => _data;

  User({int? status, String? message, Data? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  User.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    _data = json["data"] != null ? Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    if (_data != null) {
      map["data"] = _data!.toJson();
    }
    return map;
  }
}

class Data {
  int? _userId;
  String? _fullName;
  String? _userName;
  String? _userEmail;
  String? _userMobileNo;
  String? _userProfile;
  String? _loginType;
  String? _identity;
  var _platform;
  String? _deviceToken;
  var _isVerify;
  int? _totalReceived;
  int? _totalSend;
  int? _myWallet;
  int? _spenInApp;
  int? _checkIn;
  int? _uploadVideo;
  int? _fromFans;
  int? _purchased;
  String? _bio;
  String? _fbUrl;
  String? _instaUrl;
  String? _youtubeUrl;
  String? _c_lat;
  int? _isFollowingEachOther;
  int? _status;
  int? _blockOrNot;
  int? _freezOrNot;
  String? _token;
  int? _followersCount;
  int? _followingCount;
  int? _myPostLikes;
  int? _isFollowing;
  String? _profileCategoryName;
  String? _dob;
  String? _gender;
  String? _country_name;
  String? _state_name;
  String? _address;
  String? _country_icon;

  int? get userId => _userId;

  String? get fullName => _fullName;

  String? get userName => _userName;

  String? get userEmail => _userEmail;

  String? get userMobileNo => _userMobileNo;

  String? get userProfile => _userProfile;

  String? get loginType => _loginType;

  String? get identity => _identity;

  get platform => _platform;

  String? get deviceToken => _deviceToken;

  get isVerify => _isVerify;

  int? get totalReceived => _totalReceived;

  int? get totalSend => _totalSend;

  int? get myWallet => _myWallet;

  int? get spenInApp => _spenInApp;

  int? get checkIn => _checkIn;

  int? get uploadVideo => _uploadVideo;

  int? get fromFans => _fromFans;

  int? get purchased => _purchased;

  String? get bio => _bio;

  String? get fbUrl => _fbUrl;

  String? get instaUrl => _instaUrl;

  String? get youtubeUrl => _youtubeUrl;

  String? get c_lat => _c_lat;

  int? get isFollowingEachOther => _isFollowingEachOther;

  int? get status => _status;

  int? get blockOrNot => _blockOrNot;

  int? get freezOrNot => _freezOrNot;

  String? get token => _token;

  int? get followersCount => _followersCount;

  int? get followingCount => _followingCount;

  int? get myPostLikes => _myPostLikes;

  int? get isFollowing => _isFollowing;

  String? get profileCategoryName => _profileCategoryName;
  String? get dob => _dob;
  String? get gender => _gender;
  String? get country_name => _country_name;
  String? get state_name => _state_name;
  String? get address => _address;
  String? get country_icon => _country_icon;

  Data(
      {int? userId,
      String? fullName,
      String? userName,
      String? userEmail,
      String? userMobileNo,
      String? userProfile,
      String? loginType,
      String? identity,
      var platform,
      String? deviceToken,
      var isVerify,
      int? totalReceived,
      int? totalSend,
      int? myWallet,
      int? spenInApp,
      int? checkIn,
      int? uploadVideo,
      int? fromFans,
      int? purchased,
      String? bio,
      int? profileCategory,
      String? fbUrl,
      String? instaUrl,
      String? youtubeUrl,
      String? c_lat,
      int? isFollowingEachOther,
      int? status,
      int? blockOrNot,
      int? freezOrNot,
      String? token,
      int? followersCount,
      int? followingCount,
      int? myPostLikes,
      int? isFollowing,
      String? profileCategoryName,
      String? dob,
      String? gender,
      String? country_name,
      String? state_name,
      String? address,
      String? country_icon,
      }) {
    _userId = userId;
    _fullName = fullName;
    _userName = userName;
    _userEmail = userEmail;
    _userMobileNo = userMobileNo;
    _userProfile = userProfile;
    _loginType = loginType;
    _identity = identity;
    _platform = platform;
    _deviceToken = deviceToken;
    _isVerify = isVerify;
    _totalReceived = totalReceived;
    _totalSend = totalSend;
    _myWallet = myWallet;
    _spenInApp = spenInApp;
    _checkIn = checkIn;
    _uploadVideo = uploadVideo;
    _fromFans = fromFans;
    _purchased = purchased;
    _bio = bio;
    _fbUrl = fbUrl;
    _instaUrl = instaUrl;
    _youtubeUrl = youtubeUrl;
    _c_lat = c_lat;
    _isFollowingEachOther = isFollowingEachOther;
    _status = status;
    _blockOrNot = blockOrNot;
    _freezOrNot = freezOrNot;
    _token = token;
    _followersCount = followersCount;
    _followingCount = followingCount;
    _myPostLikes = myPostLikes;
    _profileCategoryName = profileCategoryName;
    _isFollowing = isFollowing;
    _dob = dob;
    _gender = gender;
    _country_name = country_name;
    _state_name = state_name;
    _address = address;
    _country_icon = country_icon;
  }

  Data.fromJson(dynamic json) {
    _userId = json["user_id"];
    _fullName = json["full_name"];
    _userName = json["user_name"];
    _userEmail = json["user_email"];
    _userMobileNo = json["user_mobile_no"];
    _userProfile = json["user_profile"];
    _loginType = json["login_type"];
    _identity = json["identity"];
    _platform = json["platform"];
    _deviceToken = json["device_token"];
    _isVerify = json["is_verify"];
    var hmm = json["total_received"];

    if(hmm is String){
      _totalReceived=int.parse(hmm);
    }
    var hmm1=json['total_send'];
    if(hmm1 is String){
      _totalSend=int.parse(hmm1);
    }
    var wal = json["my_wallet"];
    if(wal is String){
      _myWallet=int.parse(wal);
    }else{
      _myWallet = json["my_wallet"];
    }

    var sp=json["spen_in_app"];
    if(sp is int){
      _spenInApp = json["spen_in_app"];
    }else{
      _spenInApp = int.parse(json["spen_in_app"]);
    }
    
    _checkIn = json["check_in"];
    _uploadVideo = json["upload_video"];
    _fromFans = json["from_fans"];
    _purchased = json["purchased"];
    _bio = json["bio"];
    _fbUrl = json["fb_url"];
    _instaUrl = json["insta_url"];
    _youtubeUrl = json["youtube_url"];
    _c_lat = json["c_lat"]??"";
    _isFollowingEachOther = json["is_following_eachOther"];
    _status = json["status"];
    _blockOrNot = json["block_or_not"];
    _freezOrNot = json["freez_or_not"];
    _token = json["token"];
    _followersCount = json["followers_count"];
    _followingCount = json["following_count"];
    _myPostLikes = json["my_post_likes"];
    _isFollowing = json["is_following"];
    _profileCategoryName = json["profile_category_name"];
    _dob = json["dob"];
    _gender = json["gender"];
    _country_name = json["country_name"];
    _state_name = json["state_name"];
    _address = json["address"];
    _country_icon = json["country_icon"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["user_id"] = _userId;
    map["full_name"] = _fullName;
    map["user_name"] = _userName;
    map["user_email"] = _userEmail;
    map["user_mobile_no"] = _userMobileNo;
    map["user_profile"] = _userProfile;
    map["login_type"] = _loginType;
    map["identity"] = _identity;
    map["platform"] = _platform;
    map["device_token"] = _deviceToken;
    map["is_verify"] = _isVerify;
    map["total_received"] = _totalReceived;
    map["total_send"] = _totalSend;
    map["my_wallet"] = _myWallet;
    map["spen_in_app"] = _spenInApp;
    map["check_in"] = _checkIn;
    map["upload_video"] = _uploadVideo;
    map["from_fans"] = _fromFans;
    map["purchased"] = _purchased;
    map["bio"] = _bio;
    map["fb_url"] = _fbUrl;
    map["insta_url"] = _instaUrl;
    map["youtube_url"] = _youtubeUrl;
    map["c_lat"] = _c_lat;
    map["is_following_eachOther"] = _isFollowingEachOther;
    map["status"] = _status;
    map["block_or_not"] = _blockOrNot;
    map["freez_or_not"] = _freezOrNot;
    map["token"] = _token;
    map["followers_count"] = _followersCount;
    map["following_count"] = _followingCount;
    map["my_post_likes"] = _myPostLikes;
    map["is_following"] = _isFollowing;
    map["profile_category_name"] = _profileCategoryName;
    return map;
  }

  void setToken(String? accessToken) {
    _token = accessToken;
  }

  void addFollowerCount() {
    _followersCount = _followersCount! + 1;
  }

  void removeFollowerCount() {
    _followersCount = _followersCount! - 1;
  }
}
