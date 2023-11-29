
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dondi/pages/chat_screen/widget/video_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../model/chat.dart';
import '../../../utils/assert_image.dart';
import '../../../utils/const.dart';
import '../../../utils/session_manager.dart';
import 'image_view.dart';

class ChatArea extends StatelessWidget {
  final Map<String, List<ChatMessage>>? chatData;
  final Function(ChatMessage? chat) onLongPress;
  final List<String> timeStamp;

  const ChatArea(
      {Key? key,
      required this.chatData,
      required this.onLongPress,
      required this.timeStamp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: chatData != null ? chatData?.keys.length : 0,
        reverse: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          String? date = chatData?.keys.elementAt(index) ?? '';
          List<ChatMessage>? messages = chatData?[date];
          return Column(
            children: [
              alertView(date),
              ListView.builder(
                itemCount: messages?.length,
                reverse: true,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemBuilder: (context, index) {
                  return messages?[index].senderUser?.userid ==
                          SessionManager.userId
                      ? yourMsg(messages?[index], context)
                      : otherUserMsg(messages?[index], context);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget yourMsg(ChatMessage? data, BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool selected = timeStamp.contains('${data?.time?.round()}');
    return InkWell(
      onLongPress: () {
        onLongPress(data);
      },
      onTap: () {
        if (timeStamp.isNotEmpty) {
          onLongPress(data);
        }
      },
      child: Container(
        color: selected ? Colors.red.withOpacity(0.1) : Colors.transparent,
        margin: EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              DateFormat("h:mm a").format(
                DateTime.fromMillisecondsSinceEpoch(
                  data!.time!.toInt(),
                ),
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: selected ? Colors.red.withOpacity(0.1) : colorPink),
              child: data.msgType == FirebaseConst.image
                  ? imageView(data, context)
                  : data.msgType == FirebaseConst.video
                      ? videoView(data, context)
                      : ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: width / 1.4,
                            minWidth: 110,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(11, 13, 8, 11),
                            child: Text(
                              data.msg ?? '',
                              style: const TextStyle(
                                  color: Colors.white,
                              ),
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget otherUserMsg(ChatMessage? data, BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool selected = timeStamp.contains('${data?.time?.round()}');
    return InkWell(
      onLongPress: () {
        onLongPress(data);
      },
      onTap: () {
        if (timeStamp.isNotEmpty) {
          onLongPress(data);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2),
        color: selected ? Colors.red.withOpacity(0.1) : Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            data?.msgType == FirebaseConst.image
                ? imageView(data, context)
                : data?.msgType == FirebaseConst.video
                    ? videoView(data, context)
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: selected
                              ? Colors.red.withOpacity(0.1)
                              : Colors.grey,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: width / 1.4,
                            minWidth: 110,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 13, 12, 11),
                            child: Text(
                              data?.msg ?? '',
                              style: const TextStyle(
                                  color: Colors.white,
                                  ),
                            ),
                          ),
                        ),
                      ),
            const SizedBox(width: 10),
            Text(
              DateFormat("h:mm a").format(
                DateTime.fromMillisecondsSinceEpoch(
                  data!.time!.toInt(),
                ),
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageView(ChatMessage? data, BuildContext context) {
    bool selected = timeStamp.contains('${data?.time?.round()}');
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onLongPress: () {
        onLongPress(data);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: selected
                  ? Colors.red.withOpacity(0.1)
                  : data?.senderUser?.userid == SessionManager.userId
                      ? colorPink
                      : colorPrimary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    onPress(
                        context,
                        data,
                        ImageView(
                          message: data,
                        ));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: 'https://dondi.s3.us-west-1.amazonaws.com/bubbly/${data?.image}',
                      height: 180,
                      width: 180,
                      fit: BoxFit.cover,
                      cacheKey: 'https://dondi.s3.us-west-1.amazonaws.com/bubbly/${data?.image}',
                      repeat: ImageRepeat.noRepeat,
                      errorWidget: (context, error, stackTrace) {
                        return Image.asset(
                          icLogo,
                          color: colorLightWhite,
                          height: 180,
                          width: 180,
                        );
                      },
                    ),
                  ),
                ),
                data?.msg == null || data!.msg!.isEmpty
                    ? SizedBox()
                    : Text(
                        data.msg ?? '',
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget videoView(ChatMessage? data, BuildContext context) {
    bool selected = timeStamp.contains('${data?.time?.round()}');
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onLongPress: () {
        onLongPress(data);
      },
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: selected
              ? Colors.red.withOpacity(0.1)
              : data?.senderUser?.userid == SessionManager.userId
                  ? colorPink
                  : colorPrimary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                InkWell(
                  onTap: () {
                    onPress(context, data, VideoView(message: data));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: 'https://dondi.s3.us-west-1.amazonaws.com/bubbly/${data?.image}',
                      cacheKey: 'https://dondi.s3.us-west-1.amazonaws.com/bubbly/${data?.image}',
                      height: 180,
                      width: 180,
                      fit: BoxFit.cover,
                      repeat: ImageRepeat.noRepeat,
                      errorWidget: (context, error, stackTrace) {
                        return Image.asset(
                          icLogo,
                          color: colorLightWhite,
                          height: 180,
                          width: 180,
                        );
                      },
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    onPress(context, data, VideoView(message: data));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Icon(Icons.play_circle_fill_sharp,
                        size: 40, color: Colors.white.withOpacity(0.5)),
                  ),
                ),
              ],
            ),
            data?.msg == null || data!.msg!.isEmpty
                ? SizedBox()
                : Text(data.msg ?? '')
          ],
        ),
      ),
    );
  }

  Widget alertView(String data) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 8),
        margin: const EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          color: colorPrimary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          '$data',
          style: const TextStyle(color: Colors.white, fontSize: 11),
        ),
      ),
    );
  }

  void onPress(BuildContext context, ChatMessage? data, Widget child) {
    if (timeStamp.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => child,
        ),
      );
    } else {
      onLongPress(data);
    }
  }
}
