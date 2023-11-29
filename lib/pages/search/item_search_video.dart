
import 'package:flutter/material.dart';

import '../../model/user_video.dart';
import '../../utils/assert_image.dart';
import '../../utils/const.dart';
import '../video/video_list_screen.dart';

class ItemSearchVideo extends StatelessWidget {
  final Data? videoData;
  final List<Data?>? postList;
  final int? type;
  final String? hashTag;
  final String? keyWord;

  ItemSearchVideo({
    this.videoData,
    this.postList,
    this.type,
    this.hashTag,
    this.keyWord,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoListScreen(
            list: postList,
            index: postList!.indexOf(videoData),
            type: type,
            hashTag: hashTag,
            keyWord: keyWord,
          ),
        ),
      ),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: colorPrimaryDark,
            ),
            margin: EdgeInsets.only(top: 10, right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: Container(
                color: colorPrimary,
                child: Image(
                  image: NetworkImage(
                    ConstRes.itemBaseUrl + videoData!.postImage!,
                  ),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container();
                  },
                ),
              ),
            ),
          ),
          Positioned(
            right: 5,
            left: 5,
            bottom: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(1.0),
                            child: Image(
                              image: AssetImage(icUserPlaceHolder),
                              color: colorLightWhite,
                            ),
                          ),
                          Container(
                            height: 30,
                            width: 30,
                            child: ClipOval(
                              child: Image.network(
                                ConstRes.itemBaseUrl + videoData!.userProfile!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Text(
                        videoData!.fullName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          letterSpacing: 0.6,
                          fontSize: 14,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  videoData!.postDescription!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    letterSpacing: 0.6,
                    fontSize: 13,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      videoData!.postLikesCount.toString(),
                      style: TextStyle(
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            color: Colors.black,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
