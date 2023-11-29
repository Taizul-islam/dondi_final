import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:stacked/stacked.dart';

import '../../../api/api_service.dart';
import '../../../model/live_stream.dart';
import '../../../model/user.dart';
import '../../../utils/common_fun.dart';
import '../../../utils/const.dart';
import '../../../utils/session_manager.dart';
import '../screen/audience_screen.dart';
import '../screen/broad_cast_screen.dart';

class LiveStreamScreenViewModel extends BaseViewModel {
  SessionManager pref = SessionManager();
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<LiveStreamUser> liveUsers = [];
  StreamSubscription<QuerySnapshot<LiveStreamUser>>? userStream;
  List<String> joinedUser = [];
  User? registrationUser;

  void init() {
    prefData();
    getBannerAd();
  }

  void prefData() async {
    await pref.initPref();
    registrationUser = pref.getUser();
    getLiveStreamUser();
  }

  void goLiveTap(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(
          ),
        );
      },
    );
    await ApiService()
        .generateAgoraToken(registrationUser?.data?.identity)
        .then(
      (value) async {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BroadCastScreen(
                agoraToken: value.token,
                channelName: registrationUser?.data?.identity),
          ),
        );
        await db
            .collection(FirebaseConst.liveStreamUser)
            .doc(registrationUser?.data?.identity)
            .set(
              LiveStreamUser(
                fullName: registrationUser?.data?.fullName ?? '',
                isVerified:
                    registrationUser?.data?.isVerify == 1 ? true : false,
                agoraToken: value.token,
                collectedDiamond: 0,
                hostIdentity: registrationUser?.data?.identity ?? '',
                id: DateTime.now().millisecondsSinceEpoch,
                joinedUser: [],
                userId: registrationUser?.data?.userId ?? -1,
                userImage: registrationUser?.data?.userProfile ?? '',
                userName: registrationUser?.data?.userName ?? '',
                watchingCount: 0,
                followers: registrationUser?.data?.followersCount,
              ).toJson(),
            );
      },
    );
  }

  void getLiveStreamUser() {
    userStream = db
        .collection(FirebaseConst.liveStreamUser)
        .withConverter(
          fromFirestore: LiveStreamUser.fromFireStore,
          toFirestore: (LiveStreamUser value, options) {
            return value.toFireStore();
          },
        )
        .snapshots()
        .listen((event) {
      liveUsers = [];
      for (int i = 0; i < event.docs.length; i++) {
        liveUsers.add(event.docs[i].data());
      }
      notifyListeners();
    });
  }

  void onImageTap(BuildContext context, LiveStreamUser user) {
    print(registrationUser?.data?.identity);
    joinedUser.add(registrationUser?.data?.identity ?? '');
    db.collection(FirebaseConst.liveStreamUser).doc(user.hostIdentity).update({
      FirebaseConst.watchingCount: user.watchingCount! + 1,
      FirebaseConst.joinedUser: FieldValue.arrayUnion(joinedUser),
    }).then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AudienceScreen(
            channelName: user.hostIdentity,
            agoraToken: user.agoraToken,
            user: user,
          ),
        ),
      );
    });
  }

  BannerAd? bannerAd;

  void getBannerAd() {
    CommonFun.bannerAd((ad) {
      bannerAd = ad as BannerAd;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    userStream?.cancel();
    super.dispose();
  }
}
