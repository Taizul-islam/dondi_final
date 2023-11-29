
import 'package:flutter/material.dart';

import '../../../api/api_service.dart';
import '../../../model/notification.dart';
import '../../../model/user_video.dart';
import '../../../utils/assert_image.dart';
import '../../../utils/const.dart';
import '../../../widget/dialog/loader_dialog.dart';
import '../../profile/proifle_screen.dart';
import '../../video/video_list_screen.dart';

class ItemNotification extends StatelessWidget {
  final NotificationData notificationData;

  ItemNotification(this.notificationData);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        if (notificationData.notificationType! >= 4) {
          return;
        }
        if (notificationData.notificationType == 1 ||
            notificationData.notificationType == 2) {
          ///Video Screen
          showDialog(
            context: context,
            builder: (context) => LoaderDialog(),
          );
          ApiService()
              .getPostByPostId(notificationData.itemId.toString())
              .then((value) {
            List<Data> list = List<Data>.generate(
                1, (index) => Data.fromJson(value.data!.toJson()));
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoListScreen(
                  list: list,
                  index: 0,
                  type: 6,
                ),
              ),
            );
          });
        } else {
          ///User Screen
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProfileScreen(1, notificationData.itemId.toString())),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 55,
                  width: 55,
                  padding: EdgeInsets.all(1),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Image(
                          image: AssetImage(icUserPlaceHolder),
                          color: colorTextLight,
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        color: Colors.transparent,
                        child: ClipOval(
                          child: Image.network(
                            ConstRes.itemBaseUrl +
                                "${notificationData.senderUser?.userProfile}",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                icUserPlaceHolder,
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (notificationData.notificationType! >= 4
                            ? 'Admin'
                            : notificationData.senderUser?.fullName ?? ''),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        (notificationData.message != null
                            ? notificationData.message!
                            : ''),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: colorTextLight,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    image:
                        AssetImage(getIcon(notificationData.notificationType)),
                    height: 28,
                    color: colorTextLight,
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              height: 0.2,
              color: colorTextLight,
            ),
          ],
        ),
      ),
    );
  }

  String getIcon(int? notificationType) {
    if (notificationType == 1) {
      return icNotiLike;
    }
    if (notificationType == 2) {
      return icNotiComment;
    }
    if (notificationType == 3) {
      return icNotiFollowing;
    }
    if (notificationType == 4) {
      return icLogo;
    }
    return icLogo;
  }
}
