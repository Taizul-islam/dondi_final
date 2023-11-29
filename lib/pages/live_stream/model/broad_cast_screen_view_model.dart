import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:wakelock/wakelock.dart';

import '../../../api/api_service.dart';
import '../../../model/live_stream.dart';
import '../../../model/user.dart';
import '../../../utils/common_fun.dart';
import '../../../utils/const.dart';
import '../../../utils/session_manager.dart';
import '../../profile/proifle_screen.dart';
import '../../wallet/dialog_coins_plan.dart';
import '../screen/live_stream_end_screen.dart';
import '../widget/end_dialog.dart';
import '../widget/gift_sheet.dart';

class BroadCastScreenViewModel extends BaseViewModel {
  void init(
      {required bool isBroadCast,
      required String agoraToken,
      required String channelName,
      required BuildContext context}) {
    isHost = isBroadCast;
    AgoraRes.channelName = channelName;
    AgoraRes.token = agoraToken;
    buildContext = context;
    commentList = [];
    prefData();
    rtcEngineHandlerCall(context);
    setupVideoSDKEngine();
    CommonFun.interstitialAd((ad) {
      interstitialAd = ad;
      notifyListeners();
    });
    Wakelock.enable();
  }

  int uid = 0; // uid of the local user
  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  bool isHost =
      true; // Indicates whether the user has joined as a host or audience
  late RtcEngine agoraEngine; // Agora engine instance
  RtcEngineEventHandler? engineEventHandler;
  bool isMic = false;
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController commentController = TextEditingController();
  FocusNode commentFocus = FocusNode();
  List<LiveStreamComment> commentList = [];
  SessionManager pref = SessionManager();
  User? user;
  StreamSubscription<QuerySnapshot<LiveStreamComment>>? commentStream;
  late BuildContext buildContext;
  bool isGiftDialogOpen = false;
  bool isPurchaseDialogOpen = false;
  bool isEndDialogOpen = false;
  bool startStop = true;
  Timer? timer;
  Stopwatch watch = Stopwatch();
  String elapsedTime = '';
  LiveStreamUser? liveStreamUser;
  DateTime? dateTime;
  Timer? minimumUserLiveTimer;
  int countTimer = 0;
  int maxMinutes = int.parse(SettingRes.liveTimeout!) * 60;
  InterstitialAd? interstitialAd;

  void rtcEngineHandlerCall(BuildContext context) {
    engineEventHandler = RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        _isJoined = true;
        notifyListeners();
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        _remoteUid = remoteUid;
        notifyListeners();
      },
      onUserOffline: (RtcConnection connection, int remoteUid,
          UserOfflineReasonType reason) {
        audienceExit(context);
      },
      onLeaveChannel: (connection, stats) {},
    );
  }

  Widget videoPanel(BuildContext context) {
    if (!_isJoined) {
      return Center(
          child: const CircularProgressIndicator(
        color: colorPink,
      ));
    } else if (isHost) {
      // Local user joined as a host
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: uid),
        ),
      );
    } else {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: AgoraRes.channelName),
        ),
      );
    }
  }

  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();

    await agoraEngine
        .initialize(RtcEngineContext(appId: SettingRes.agoraAppId));

    await agoraEngine.enableVideo();

    join();

    // Register the event handler
    if (engineEventHandler != null) {
      agoraEngine.registerEventHandler(engineEventHandler!);
    }
  }

  void join() async {
    // Set channel options
    ChannelMediaOptions options;

    // Set channel profile and client role
    if (isHost) {
      startWatch();
      options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      );
      await agoraEngine.startPreview();
    } else {
      options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleAudience,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      );
    }
    await agoraEngine.joinChannel(
      token: AgoraRes.token,
      channelId: AgoraRes.channelName,
      options: options,
      uid: uid,
    );
    notifyListeners();
  }

  void onEndButtonClick(BuildContext context) {
    isEndDialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return EndDialog(
          onYesBtnClick: () {
            leave(context);
          },
        );
      },
    ).then((value) {
      isEndDialogOpen = false;
    });
  }

  void leave(BuildContext context) async {
    _isJoined = false;
    _remoteUid = null;
    notifyListeners();
    liveStreamData();
    await agoraEngine
        .leaveChannel(
      options: const LeaveChannelOptions(),
    )
        .then((value) async {
      if (isHost) {
        db
            .collection(FirebaseConst.liveStreamUser)
            .doc(AgoraRes.channelName)
            .delete();
        final batch = db.batch();
        var collection = db
            .collection(FirebaseConst.liveStreamUser)
            .doc(AgoraRes.channelName)
            .collection(FirebaseConst.comment);
        var snapshots = await collection.get();
        for (var doc in snapshots.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
        if (isEndDialogOpen) {
          Navigator.pop(context);
        }
        stopWatch();
        if (interstitialAd != null) {
          interstitialAd?.show().then((value) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return LivestreamEndScreen();
                },
              ),
            );
          });
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return LivestreamEndScreen();
              },
            ),
          );
        }
      }
    });
  }

  void prefData() async {
    await pref.initPref();
    user = pref.getUser();
    initFirebase();
    getProfile();
  }

  void initFirebase() {
    db
        .collection(FirebaseConst.liveStreamUser)
        .doc(AgoraRes.channelName)
        .withConverter(
          fromFirestore: LiveStreamUser.fromFireStore,
          toFirestore: (LiveStreamUser value, options) => value.toFireStore(),
        )
        .snapshots()
        .listen((event) {
      liveStreamUser = event.data();
      if (isHost) {
        minimumUserLiveTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
          countTimer++;
          if (countTimer == maxMinutes && liveStreamUser!.watchingCount! <= (int.parse(SettingRes.liveMinViewers!) ?? -1)) {
            timer.cancel();
            leave(buildContext);
          }
          if (countTimer == maxMinutes) {
            countTimer = 0;
          }
        });
        notifyListeners();
      }
      notifyListeners();
    });
    commentStream = db
        .collection(FirebaseConst.liveStreamUser)
        .doc(AgoraRes.channelName)
        .collection(FirebaseConst.comment)
        .orderBy(FirebaseConst.id, descending: true)
        .withConverter(
          fromFirestore: LiveStreamComment.fromFireStore,
          toFirestore: (LiveStreamComment value, options) {
            return value.toFireStore();
          },
        )
        .snapshots()
        .listen((event) {
      commentList = [];
      for (int i = 0; i < event.docs.length; i++) {
        commentList.add(event.docs[i].data());
      }
      notifyListeners();
    });
  }

  onComment() {
    if (commentController.text.isEmpty) {
      return;
    }
    onCommentSend(commentType: 'msg', msg: commentController.text.trim());
    commentController.clear();
    commentFocus.unfocus();
  }

  Future<void> onCommentSend(
      {required String commentType, required String msg}) async {
    await db
        .collection(FirebaseConst.liveStreamUser)
        .doc(AgoraRes.channelName)
        .collection(FirebaseConst.comment)
        .add(LiveStreamComment(
                id: DateTime.now().millisecondsSinceEpoch,
                userName: user?.data?.userName ?? '',
                userImage: user?.data?.userProfile ?? '',
                userId: user?.data?.userId ?? -1,
                fullName: user?.data?.fullName ?? '',
                comment: msg,
                commentType: commentType,
                isVerify: user?.data?.isVerify == 1 ? true : false)
            .toJson());
  }

  void flipCamera() {
    agoraEngine.switchCamera();
  }

  void onMuteUnMute() {
    isMic = !isMic;
    notifyListeners();
    agoraEngine.muteLocalAudioStream(isMic);
  }

  void audienceExit(BuildContext context) async {
    _remoteUid = null;
    db
        .collection(FirebaseConst.liveStreamUser)
        .doc(AgoraRes.channelName)
        .update(
      {
        FirebaseConst.watchingCount:
            liveStreamUser != null && liveStreamUser?.watchingCount != 0
                ? liveStreamUser!.watchingCount! - 1
                : 0
      },
    );
    await agoraEngine.leaveChannel();
    if (isEndDialogOpen) {
      Navigator.pop(context);
    }
    if (isGiftDialogOpen) {
      Navigator.pop(context);
    }
    if (isPurchaseDialogOpen) {
      Navigator.pop(context);
    }
    if (interstitialAd != null) {
      interstitialAd?.show();
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }

  void onGiftTap(BuildContext context) {
    getProfile();
    isGiftDialogOpen = true;
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return GiftSheet(
          onAddShortzzTap: onAddShortzzTap,
          user: user,
          onGiftSend: (gifts) async {
            Navigator.pop(context);
            num value = liveStreamUser!.collectedDiamond! + int.parse(gifts!.coinPrice!);
            await db
                .collection(FirebaseConst.liveStreamUser)
                .doc(AgoraRes.channelName)
                .update({FirebaseConst.collectedDiamond: value});
            await ApiService()
                .sendCoin('${gifts.coinPrice}', '${liveStreamUser?.userId}')
                .then((value) {
              getProfile();
            });
            onCommentSend(
                commentType: FirebaseConst.image, msg: gifts.image ?? '');
          },
        );
      },
    ).then((value) {
      isGiftDialogOpen = false;
    });
  }

  void onAddShortzzTap(BuildContext context) {
    isPurchaseDialogOpen = true;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DialogCoinsPlan();
      },
    ).then((value) {
      isPurchaseDialogOpen = false;
    });
  }

  void getProfile() async {
    await ApiService()
        .getProfile(SessionManager.userId.toString())
        .then((value) {
      user = value;
      notifyListeners();
    });
  }

  void onUserTap(BuildContext context) async {
    _remoteUid = null;
    db
        .collection(FirebaseConst.liveStreamUser)
        .doc(AgoraRes.channelName)
        .update(
      {
        FirebaseConst.watchingCount:
            liveStreamUser != null && liveStreamUser?.watchingCount != null
                ? liveStreamUser!.watchingCount! - 1
                : 0
      },
    );
    await agoraEngine.leaveChannel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(1, '${liveStreamUser?.userId}'),
      ),
    );
  }

  void startWatch() {
    startStop = false;
    watch.start();
    timer = Timer.periodic(const Duration(milliseconds: 100), updateTime);
    dateTime = DateTime.now();
    notifyListeners();
  }

  updateTime(Timer timer) {
    if (watch.isRunning) {
      elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
      notifyListeners();
    }
  }

  void stopWatch() {
    startStop = true;
    watch.stop();
    setTime();
    notifyListeners();
  }

  void setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    elapsedTime = transformMilliSeconds(timeSoFar);
    notifyListeners();
  }

  String transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  Future<void> liveStreamData() async {
    pref.saveString(FirebaseConst.timing, elapsedTime);
    pref.saveString(
        FirebaseConst.watching, "${liveStreamUser?.joinedUser?.length}");
    pref.saveString(
        FirebaseConst.collected, "${liveStreamUser?.collectedDiamond}");
    pref.saveString(FirebaseConst.profileImage, "${liveStreamUser?.userImage}");
  }

  @override
  void dispose() {
    commentController.dispose();
    commentStream?.cancel();
    agoraEngine.unregisterEventHandler(engineEventHandler!);
    Wakelock.disable();
    timer?.cancel();
    minimumUserLiveTimer?.cancel();
    super.dispose();
  }
}
