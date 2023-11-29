
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dondi/pages/profile/proifle_screen.dart';
import 'package:dondi/utils/my_loading.dart';
import 'package:flutter/material.dart';

import '../../../api/api_service.dart';
import '../../../model/chat.dart';
import '../../../utils/assert_image.dart';
import '../../../utils/const.dart';
import '../../../utils/session_manager.dart';
import 'package:get/get.dart';

import '../../report/report_screen.dart';

class TopBarArea extends StatefulWidget {
  final Conversation? user;
  final VoidCallback onBack;
  final Conversation? conversation;

  const TopBarArea(
      {Key? key, required this.user, required this.onBack, this.conversation})
      : super(key: key);

  @override
  State<TopBarArea> createState() => _TopBarAreaState();
}

class _TopBarAreaState extends State<TopBarArea> {
  bool isBlock = false;
  var db = FirebaseFirestore.instance;
  SessionManager sessionManager = SessionManager();
  final controller=Get.put(MyLoading());
  @override
  void initState() {
    initSession();
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Visibility(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(21, 18, 23, 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: widget.onBack,
                    child: Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 15),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(1, "${widget.user?.user?.userid}"),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: widget.user?.user?.image == null ||
                              widget.user!.user!.image!.isEmpty
                          ? Image.asset(
                              icUserPlaceHolder,
                              height: 37,
                              width: 37,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              '${ConstRes.itemBaseUrl}${widget.user?.user?.image}',
                              height: 37,
                              width: 37,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  icUserPlaceHolder,
                                  height: 37,
                                  width: 37,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                                1, "${widget.user?.user?.userid}"),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                flex: 5,
                                child: Text(
                                  widget.user?.user?.userFullName ?? '',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      overflow: TextOverflow.ellipsis),
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                child: Visibility(
                                  visible:
                                      widget.user?.user?.isVerified ?? false,
                                  child: Icon(
                                    Icons.verified,
                                    color: Colors.blue,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            widget.user?.user?.username ?? '',
                            style: const TextStyle(
                                color: colorTextLight,
                                fontSize: 12,
                                overflow: TextOverflow.ellipsis),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  PopupMenuButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    color: colorPrimary,
                    elevation: 3,
                    itemBuilder: (BuildContext context) {
                      return List.generate(2, (index) {
                        return PopupMenuItem(
                          value: index,
                          child: Text(
                            index == 0
                                ? 'Report User'
                                : (controller
                                        .isUserBlockOrNot.value
                                    ? 'UnBlock User'
                                    : 'Block User'),
                            style: TextStyle(
                              color: colorTextLight,
                            ),
                          ),
                        );
                      });
                    },
                    child: Image.asset(
                      icMenu,
                      color: Colors.white,
                      width: 18,
                    ),
                    onSelected: (value) {
                      if (value == 0) {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) =>
                              ReportScreen(2, '${widget.user?.user?.userid}'),
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                        );
                        return;
                      }
                      if (value == 1) {
                        ApiService()
                            .blockUser('${widget.user?.user?.userid}')
                            .then((value) {
                          isBlock = !isBlock;
                          controller
                              .setIsUserBlockOrNot(isBlock);
                          blockUnblockStatus(isBlock: isBlock);
                          setState(() {});
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 0.5,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(right: 10, left: 10, bottom: 5.5),
              color: colorTextLight,
            ),
          ],
        ),
      ),
    );
  }

  initSession() async {
    await sessionManager.initPref();
  }

  getProfile() async {
    await ApiService()
        .getProfile(widget.user?.user?.userid.toString())
        .then((value) {
      isBlock = value.data?.blockOrNot == 1 ? true : false;
      controller
          .setIsUserBlockOrNot(isBlock);
      blockUnblockStatus(isBlock: isBlock);
      setState(() {});
    });
  }

  blockUnblockStatus({required bool isBlock}) {
    db
        .collection(FirebaseConst.userChatList)
        .doc(widget.conversation?.user?.userIdentity)
        .collection(FirebaseConst.userList)
        .doc(sessionManager.getUser()?.data?.identity)
        .withConverter(
          fromFirestore: Conversation.fromFireStore,
          toFirestore: (Conversation value, options) => value.toFireStore(),
        )
        .update({FirebaseConst.blockFromOther: isBlock});

    db
        .collection(FirebaseConst.userChatList)
        .doc(sessionManager.getUser()?.data?.identity)
        .collection(FirebaseConst.userList)
        .doc(widget.conversation?.user?.userIdentity)
        .withConverter(
          fromFirestore: Conversation.fromFireStore,
          toFirestore: (Conversation value, options) => value.toFireStore(),
        )
        .update({FirebaseConst.block: isBlock});
  }
}
