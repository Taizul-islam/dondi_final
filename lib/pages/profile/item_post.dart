
import 'package:flutter/material.dart';

import '../../model/user_video.dart';
import '../../utils/const.dart';
import '../../utils/session_manager.dart';
import '../video/video_list_screen.dart';

class ItemPost extends StatelessWidget {
  final Data? data;
  final List<Data>? list;
  final Function? onTap;
  final int? type;
  final String? userId;
  final String? soundId;

  ItemPost(
      {required this.data,
      this.onTap,
      this.list,
      this.type,
      this.userId,
      this.soundId});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          onTap: () {
            onTap?.call();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoListScreen(
                  list: list,
                  index: list!.indexOf(data!),
                  type: type,
                  userId: userId,
                  soundId: soundId,
                ),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            margin: EdgeInsets.only(top: 10, right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Container(
                color: colorPrimaryDark,
                child: Image(
                  image: NetworkImage(
                    '${ConstRes.itemBaseUrl}${(data?.postImage != null ? data?.postImage : '')}',
                  ),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 12,
          child: Row(
            children: [
              Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 20,
              ),
              Text(
                NumberFormatter.formatter(
                  '${data?.postViewCount.toString()}',
                ),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
