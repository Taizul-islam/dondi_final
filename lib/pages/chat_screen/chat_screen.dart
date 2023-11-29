import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dondi/pages/chat_screen/widget/add_btn_sheet.dart';
import 'package:dondi/pages/chat_screen/widget/bottom_input_bar.dart';
import 'package:dondi/pages/chat_screen/widget/chat_area.dart';
import 'package:dondi/pages/chat_screen/widget/image_video_msg_screen.dart';
import 'package:dondi/pages/chat_screen/widget/top_bar_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../api/api_service.dart';
import '../../model/chat.dart';
import '../../model/user.dart';
import '../../utils/const.dart';
import '../../utils/session_manager.dart';

class ChatScreen extends StatefulWidget {
  final Conversation? user;

  static bool isScreen = false;

  const ChatScreen({Key? key, this.user}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Conversation? conversation;
  User? user;
  User? conversationUserData;
  SessionManager sessionManager = SessionManager();
  var db = FirebaseFirestore.instance;
  late DocumentReference drReceiver;
  late DocumentReference drSender;
  late CollectionReference drChatMessage;
  List<String> notDeletedIdentity = [];
  Map<String, List<ChatMessage>>? grouped;
  ChatUser? receiverUser;
  StreamSubscription<QuerySnapshot<ChatMessage>>? chatStream;
  TextEditingController controller = TextEditingController();
  List<ChatMessage> chatData = [];
  List<String> timeStamp = [];
  bool isLongPress = false;
  bool? isBlockFromOther = false;
  StreamSubscription<DocumentSnapshot<Conversation>>? blockFromOtherStream;

  @override
  void initState() {
    ChatScreen.isScreen = true;
    conversation = widget.user;
    prefData();
    getProfile();
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
        body: Column(
          children: [
            TopBarArea(
              user: conversation,
              onBack: () {
                Navigator.pop(context);
              },
              conversation: conversation,
            ),
            ChatArea(
              chatData: grouped,
              onLongPress: onLongPress,
              timeStamp: timeStamp,
            ),
            BottomInputBar(
              msgController: controller,
              onShareBtnTap: () {
                if (isBlockFromOther == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('You are block from other')));
                } else {
                  onShareBtnTap();
                }
              },
              onAddBtnTap: () {
                if (isBlockFromOther == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('You are block from other')));
                } else {
                  onAddBtnTap();
                }
              },
              onCameraTap: () {
                if (isBlockFromOther == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('You are block from other')));
                } else {
                  onCameraTap(context);
                }
              },
              timeStamp: timeStamp,
              onDeleteBtnClick: onDeleteBtnClick,
              cancelBtnClick: onCancelBtnClick,
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  void onCameraTap(BuildContext context) async {
    File? images;
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.front);
    if (image == null || image.path.isEmpty) return;
    images = File(image.path);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ImageVideoMsgScreen(
          image: images?.path,
          onIVSubmitClick: ({text}) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return Center(
                  child: CircularProgressIndicator(
                    color: colorPink,
                  ),
                );
              },
            );
            ApiService().filePath(filePath: images).then((value) {
              print("image path ${value.path}");
              firebaseMsgUpdate(
                  msgType: FirebaseConst.image,
                  image: value.path,
                  video: null,
                  textMessage: text);
            }).then((value) {
              Navigator.pop(context);
              Navigator.pop(context);
            });
          },
        );
      },
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void onShareBtnTap() {
    if (controller.text.trim() != '') {
      firebaseMsgUpdate(msgType: 'msg', textMessage: controller.text.trim())
          .then((value) {
        controller.clear();
      });
    }
  }

  String dateFormat(DateTime time) {
    String hour = time.hour.toString();
    String minute = time.minute.toString().padLeft(2, '0');
    bool isAm = (time.hour * 60) > 719 ? false : true;
    String timeStr = '$hour:$minute ${isAm ? 'am' : 'pm'}';
    return timeStr;
  }

  void prefData() async {
    await sessionManager.initPref();
    user = sessionManager.getUser();
    initFireStore();
  }

  void getProfile() {
    ApiService().getProfile('${conversation?.user?.userid}').then((value) {
      conversationUserData = value;
      setState(() {});
    });
  }

  void initFireStore() {
    drReceiver = db
        .collection(FirebaseConst.userChatList)
        .doc(conversation?.user?.userIdentity)
        .collection(FirebaseConst.userList)
        .doc(user?.data?.identity);

    drSender = db
        .collection(FirebaseConst.userChatList)
        .doc(user?.data?.identity)
        .collection(FirebaseConst.userList)
        .doc(conversation?.user?.userIdentity);

    drSender
        .withConverter(
          fromFirestore: Conversation.fromFireStore,
          toFirestore: (Conversation value, options) {
            return value.toFireStore();
          },
        )
        .get()
        .then((value) {
      if (value.data()?.user == null) {
        drSender.set(conversation?.toJson());
        drReceiver.set(
          Conversation(
            time: DateTime.now().millisecondsSinceEpoch.toDouble(),
            newMsg: '',
            lastMsg: '',
            isMute: false,
            isDeleted: false,
            deletedId: '',
            conversationId: conversation?.conversationId,
            blockFromOther: false,
            block: false,
            user: ChatUser(
              username: user?.data?.userName,
              userIdentity: user?.data?.identity,
              userid: user?.data?.userId,
              userFullName: user?.data?.fullName ?? '',
              isNewMsg: false,
              image: user?.data?.userProfile,
              date: DateTime.now().millisecondsSinceEpoch.toDouble(),
              isVerified: user?.data?.isVerify == 1 ? true : false,
            ),
          ).toJson(),
        );
      }
      if (value.data() != null && value.data()?.conversationId != null) {
        conversation?.setConversationId(value.data()?.conversationId);
      }

      drChatMessage = db
          .collection(FirebaseConst.chat)
          .doc(conversation?.conversationId)
          .collection(FirebaseConst.chat);

      getChat();
    });

    blockFromOtherStream = drSender
        .withConverter(
          fromFirestore: Conversation.fromFireStore,
          toFirestore: (Conversation value, options) {
            return value.toFireStore();
          },
        )
        .snapshots()
        .listen((event) {
      isBlockFromOther = event.data()?.blockFromOther;
      if (this.mounted) {
        setState(() {});
      }
      print('blockFromOther:-  ${event.data()?.blockFromOther}');
    });
  }

  void getChat() {
    drReceiver
        .withConverter(
          fromFirestore: Conversation.fromFireStore,
          toFirestore: (Conversation value, options) {
            return value.toFireStore();
          },
        )
        .get()
        .then(
      (value) {
        receiverUser = value.data()?.user;
      },
    );
    chatStream = drChatMessage
        .where(FirebaseConst.noDeletedId, arrayContains: user?.data?.identity)
        .orderBy(FirebaseConst.time, descending: true)
        .withConverter(
          fromFirestore: ChatMessage.fromFireStore,
          toFirestore: (ChatMessage value, options) {
            return value.toFireStore();
          },
        )
        .snapshots()
        .listen(
      (element) async {
        drSender
            .withConverter(
              fromFirestore: Conversation.fromFireStore,
              toFirestore: (Conversation value, options) {
                return value.toFireStore();
              },
            )
            .get()
            .then(
          (value) {
            var senderUser = value.data()?.user;
            senderUser?.isNewMsg = false;
            drSender.update(
              {
                FirebaseConst.user: senderUser?.toJson(),
              },
            );
          },
        );

        chatData = [];

        for (int i = 0; i < element.docs.length; i++) {
          print("chat data ${element.docs[i].data().image}");
          print("chat data ${element.docs[i].data().msgType}");
          chatData.add(element.docs[i].data());
        }

        print("chat data ${chatData.length}");
        grouped = groupBy<ChatMessage, String>(
          chatData,
          (message) {
            final now = DateTime.now();
            DateTime time =
                DateTime.fromMillisecondsSinceEpoch(message.time!.toInt());
            if (DateFormat("dd MMM yyyy").format(DateTime.now()) ==
                DateFormat("dd MMM yyyy").format(time)) {
              return 'Today';
            }
            if (DateFormat("dd MMM yyyy")
                    .format(DateTime(now.year, now.month, now.day - 1)) ==
                DateFormat("dd MMM yyyy").format(time)) {
              return 'Yesterday';
            } else {
              return DateFormat("dd MMM yyyy").format(time);
            }
          },
        );
        if (this.mounted) {
          setState(() {});
        }
      },
    );

    if (conversation?.user != null) {
      drSender
          .withConverter(
            fromFirestore: Conversation.fromFireStore,
            toFirestore: (Conversation value, options) {
              return value.toFireStore();
            },
          )
          .snapshots()
          .listen((event) {
        conversation = event.data();
        if (this.mounted) {
          setState(() {});
        }
      });
    }
  }

  Future<void> firebaseMsgUpdate(
      {required String msgType,
      String? textMessage,
      String? image,
      String? video}) async {
    var time = DateTime.now().millisecondsSinceEpoch;
    notDeletedIdentity = [];
    notDeletedIdentity.addAll(
      ['${user?.data?.identity}', '${conversation?.user?.userIdentity}'],
    );
    receiverUser?.isNewMsg = true;
    drReceiver.update(
      {
        FirebaseConst.time: time.toDouble(),
        FirebaseConst.lastMsg: msgType == FirebaseConst.image
            ? '🖼️ ${FirebaseConst.image}'
            : msgType == FirebaseConst.video
                ? '🎥 ${FirebaseConst.video}'
                : textMessage,
        FirebaseConst.user: receiverUser?.toJson(),
      },
    );

    drChatMessage
        .doc(
          time.toString(),
        )
        .set(
          ChatMessage(
            notDeletedIdentities: notDeletedIdentity,
            senderUser: ChatUser(
              username: user?.data?.userName,
              userFullName: user?.data?.fullName,
              date: time.toDouble(),
              isNewMsg: false,
              userid: user?.data?.userId,
              userIdentity: user?.data?.identity,
              image: user?.data?.userProfile,
              isVerified: user?.data?.isVerify == 1 ? true : false,
            ),
            msgType: msgType,
            msg: textMessage,
            image: image,
            video: video,
            id: conversation?.user?.userid?.toString(),
            time: time.toDouble(),
          ).toJson(),
        );

    // sender update
    drSender.update(
      {
        FirebaseConst.time: time.toDouble(),
        FirebaseConst.lastMsg: msgType == FirebaseConst.image
            ? '🖼️ ${'Image'}'
            : msgType == FirebaseConst.video
                ? '🎥 ${'Video'}'
                : textMessage
      },
    );

    ApiService().pushNotification(
        authorization:
            'AAAAa_dh3Ao:APA91bEF3Ea9-P1coZbLLb2NsGMH47D2sfKuzCssKYuQn7FTA6e_P-P7yKgh0ruGeKzExWMOMy2MrdAjtg42uiiyBNQIHzKHL7THn838mphrc4qAdGfONwRmVIH_B0nBdRVIBlwW_FEN',
        title: user?.data?.fullName ?? 'Shortzz',
        body: msgType == FirebaseConst.image
            ? '🖼️ ${'Image'}'
            : msgType == FirebaseConst.video
                ? '🎥 ${'Video'}'
                : '$textMessage',
        token: '${conversationUserData?.data?.deviceToken}');
  }

  void onAddBtnTap() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddBtnSheet(
          fireBaseMsg: ({imagePath, msg, msgType, videoPath}) {
            firebaseMsgUpdate(
                msgType: msgType ?? '',
                image: imagePath,
                video: msgType == FirebaseConst.video ? videoPath : null,
                textMessage: msg);
          },
        );
      },
    );
  }

  void onCancelBtnClick() {
    timeStamp = [];
    setState(() {});
  }

  void onDeleteBtnClick() {
    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.symmetric(horizontal: 70),
            child: AspectRatio(
              aspectRatio: 0.6 / 0.4,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: colorPrimaryDark,
                ),
                child: Column(
                  children: [
                    Spacer(),
                    Text(
                      'Delete message',
                      style: TextStyle(fontSize: 16),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Are you sure you want to delete this message ?',
                        style: TextStyle(color: colorTextLight),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: colorPrimary,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 14,
                                    decoration: TextDecoration.none,
                                    color: colorTextLight,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              onTap: () {
                                Navigator.pop(context);
                                onDeleteYesBtnClick();
                              },
                              child: Center(
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontSize: 14,
                                    decoration: TextDecoration.none,
                                    color: colorIcon,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void onDeleteYesBtnClick() {
    for (int i = 0; i < timeStamp.length; i++) {
      drChatMessage.doc(timeStamp[i]).update(
        {
          FirebaseConst.noDeletedId: FieldValue.arrayRemove(
            ['${user?.data?.identity}'],
          )
        },
      );
      chatData.removeWhere(
        (element) => element.time.toString() == timeStamp[i],
      );
    }
    timeStamp = [];
    setState(() {});
  }

  void onLongPress(ChatMessage? data) {
    if (!timeStamp.contains('${data?.time?.round()}')) {
      timeStamp.add('${data?.time?.round()}');
    } else {
      timeStamp.remove('${data?.time?.round()}');
    }
    print(timeStamp);
    isLongPress = true;
    setState(() {});
  }

  @override
  void dispose() {
    chatStream?.cancel();
    blockFromOtherStream?.cancel();
    ChatScreen.isScreen = false;
    super.dispose();
  }
}
