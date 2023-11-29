import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dondi/widget/data_not_found.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../model/chat.dart';
import '../../../model/user.dart';
import '../../../utils/assert_image.dart';
import '../../../utils/const.dart';
import '../../../utils/session_manager.dart';
import '../../chat_screen/chat_screen.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  SessionManager sessionManager = SessionManager();
  User? user;
  Stream<QuerySnapshot<Conversation>>? dataStream;

  @override
  void initState() {
    getChatUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Conversation>>(
      stream: dataStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: const Text('Something went wrong',style: TextStyle(color: Colors.white),));
        }
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.none) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
        if (snapshot.data!.docs.isEmpty) {
          return Center(child: DataNotFound());
        }
        return ListView.builder(
          itemCount: snapshot.data?.docs.length,
          itemBuilder: (context, index) {
            Conversation? conversation = snapshot.data?.docs[index].data();
            return InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                onUserTap(conversation);
              },
              child: AspectRatio(
                aspectRatio: 1 / 0.22,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          '${ConstRes.itemBaseUrl}${conversation?.user?.image}',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              icUserPlaceHolder,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          '${conversation?.user?.userFullName}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Visibility(
                                        visible:
                                            conversation?.user?.isVerified ??
                                                false,
                                        child: Icon(
                                          Icons.verified_sharp,
                                          color: Colors.blueAccent,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  readTimestamp(conversation?.time ?? 0.0),
                                  style: TextStyle(color: colorTextLight),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    conversation?.lastMsg ?? '',
                                    style: TextStyle(
                                        color: colorTextLight,
                                        overflow: TextOverflow.ellipsis),
                                    maxLines: 1,

                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Visibility(
                                  visible:
                                      conversation?.user?.isNewMsg ?? false,
                                  child: Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                      color: colorIcon,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void onUserTap(Conversation? conversation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(user: conversation),
      ),
    );
  }

  getChatUsers() async {
    await sessionManager.initPref();
    user = sessionManager.getUser();
    dataStream = db
        .collection(FirebaseConst.userChatList)
        .doc(user?.data?.identity)
        .collection(FirebaseConst.userList)
        .orderBy(FirebaseConst.time, descending: true)
        .withConverter(
          fromFirestore: Conversation.fromFireStore,
          toFirestore: (Conversation value, options) {
            return value.toFireStore();
          },
        )
        .snapshots();
    if (this.mounted) {
      setState(() {});
    }
  }

  static String readTimestamp(double timestamp) {
    var now = DateTime.now();
    var date = DateTime.fromMicrosecondsSinceEpoch(timestamp.toInt() * 1000);
    var time = '';
    if (now.day == date.day) {
      time = DateFormat('hh:mm a')
          .format(DateTime.fromMillisecondsSinceEpoch(timestamp.toInt()));
      return time;
    }
    if (now.weekday > date.weekday) {
      time = DateFormat('EEEE')
          .format(DateTime.fromMillisecondsSinceEpoch(timestamp.toInt()));
      return time;
    }
    if (now.month == date.month) {
      time = DateFormat('dd/MM/yyyy')
          .format(DateTime.fromMillisecondsSinceEpoch(timestamp.toInt()));
      return time;
    }
    return time;
  }

  @override
  void dispose() {
    dataStream?.listen((event) {}).cancel();
    super.dispose();
  }
}
