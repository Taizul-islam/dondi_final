import 'dart:convert';
import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';
import '../model/setting.dart';
import '../model/user.dart';
import 'const.dart';

class SessionManager {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  SharedPreferences? sharedPreferences;
  static int? userId = -1;
  static String? accessToken = '';

  Future initPref() async {
    sharedPreferences = await _pref;
  }

  void saveBoolean(String key, bool value) async {
    if (sharedPreferences != null) sharedPreferences!.setBool(key, value);
  }

  bool? getBool(String key) {
    return sharedPreferences == null || sharedPreferences!.getBool(key) == null
        ? false
        : sharedPreferences!.getBool(key);
  }

  void saveInteger(String key, int value) async {
    if (sharedPreferences != null) sharedPreferences!.setInt(key, value);
  }

  int? getInteger(String key) {
    return sharedPreferences == null || sharedPreferences!.getInt(key) == null
        ? 0
        : sharedPreferences!.getInt(key);
  }

  void saveString(String key, String? value) async {
    if (sharedPreferences != null) sharedPreferences!.setString(key, value!);
  }

  String? getString(String key) {
    return sharedPreferences == null ||
            sharedPreferences!.getString(key) == null
        ? ''
        : sharedPreferences!.getString(key);
  }

  void saveUser(String value) {
    if (sharedPreferences != null) sharedPreferences!.setString('user', value);
    saveBoolean(ConstRes.isLogin, true);
    userId = getUser()?.data?.userId;

    accessToken = getUser()?.data?.token;
  }

  User? getUser() {
    if (sharedPreferences != null) {
      String? strUser = sharedPreferences!.getString('user');
      if (strUser != null && strUser.isNotEmpty) {
        return User.fromJson(jsonDecode(strUser));
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  void saveSetting(String value) {
    if (sharedPreferences != null)
      sharedPreferences?.setString('setting', value);
    SettingRes.admobBanner = getSetting()?.data?.admobBanner;
    SettingRes.admobInt = getSetting()?.data?.admobInt;
    SettingRes.admobIntIos = getSetting()?.data?.admobIntIos;
    SettingRes.admobBannerIos = getSetting()?.data?.admobBannerIos;
    SettingRes.maxUploadDaily = getSetting()?.data?.maxUploadDaily;
    SettingRes.liveMinViewers = getSetting()?.data?.liveMinViewers;
    SettingRes.liveTimeout = getSetting()?.data?.liveTimeout;
    SettingRes.rewardVideoUpload = getSetting()?.data?.rewardVideoUpload;
    SettingRes.minFansForLive = getSetting()?.data?.minFansForLive;
    SettingRes.minFansVerification = getSetting()?.data?.minFansVerification;
    SettingRes.minRedeemCoins = getSetting()?.data?.minRedeemCoins;
    SettingRes.coinValue = getSetting()?.data?.coinValue;
    SettingRes.currency = getSetting()?.data?.currency;
    SettingRes.agoraAppId = getSetting()?.data?.agoraAppId;
    SettingRes.gifts = getSetting()?.data?.gifts;
  }

  Setting? getSetting() {
    if (sharedPreferences != null) {
      String? value = sharedPreferences?.getString('setting');
      if (value != null && value.isNotEmpty) {
        return Setting.fromJson(jsonDecode(value));
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  void saveFavouriteMusic(String id) {
    List<dynamic> fav = getFavouriteMusic();
    // ignore: unnecessary_null_comparison
    if (fav != null) {
      if (fav.contains(id)) {
        fav.remove(id);
      } else {
        fav.add(id);
      }
    } else {
      fav = [];
      fav.add(id);
    }
    if (sharedPreferences != null) {
      sharedPreferences!.setString(ConstRes.favourite, json.encode(fav));
    }
  }

  List<String> getFavouriteMusic() {
    if (sharedPreferences != null) {
      String? userString = sharedPreferences!.getString(ConstRes.favourite);
      if (userString != null && userString.isNotEmpty) {
        List<dynamic> dummy = json.decode(userString);
        return dummy.map((item) => item as String).toList();
      }
    }
    return [];
  }

  void clean() {
    sharedPreferences!.clear();
    userId = -1;
    accessToken = '';
  }
}

class NumberFormatter {
  static String formatter(String currentBalance) {
    try {
      double value = double.parse(currentBalance);

      if (value < 1000) {
        // less than a thousand
        return value.toStringAsFixed(0);
      } else if (value >= 1000 && value < 1000000) {
        // less than 1 million
        double result = value / 1000;
        return result.toStringAsFixed(2) + "K";
      } else if (value >= 1000000 && value < (1000000 * 10 * 100)) {
        // less than 100 million
        double result = value / 1000000;
        return result.toStringAsFixed(2) + "M";
      } else if (value >= (1000000 * 10 * 100) &&
          value < (1000000 * 10 * 100 * 100)) {
        // less than 100 billion
        double result = value / (1000000 * 10 * 100);
        return result.toStringAsFixed(2) + "B";
      } else if (value >= (1000000 * 10 * 100 * 100) &&
          value < (1000000 * 10 * 100 * 100 * 100)) {
        // less than 100 trillion
        double result = value / (1000000 * 10 * 100 * 100);
        return result.toStringAsFixed(2) + "T";
      } else {
        return currentBalance;
      }
    } catch (e) {
      print(e);
      return currentBalance;
    }
  }
}
