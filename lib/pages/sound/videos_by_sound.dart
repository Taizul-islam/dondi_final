import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:dondi/pages/camera/camera_screen.dart';

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import '../../api/api_service.dart';
import '../../model/user_video.dart';
import '../../utils/const.dart';
import '../../utils/session_manager.dart';
import '../../widget/data_not_found.dart';
import '../../widget/icon_with_round_gradient.dart';
import '../profile/item_post.dart';

class VideosBySoundScreen extends StatefulWidget {
  final Data? videoData;

  VideosBySoundScreen(this.videoData);

  @override
  _VideosBySoundScreenState createState() => _VideosBySoundScreenState();
}

class _VideosBySoundScreenState extends State<VideosBySoundScreen> {
  var start = 0;
  int? count = 0;
  bool isLoading = true;
  bool isPlay = false;
  bool isFav = true;
  final ScrollController _scrollController = ScrollController();
  final StreamController _streamController = StreamController<List<Data>?>();
  List<Data>? postList = [];
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    initIsFav();
    _scrollController.addListener(
      () {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          if (!isLoading) {
            callApiForGetPostsBySoundId();
          }
        }
      },
    );
    callApiForGetPostsBySoundId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 50,
                    width: 40,
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Sound Videos',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 0.3,
              color: colorTextLight.withOpacity(0.2),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.all(15),
                  height: 100,
                  width: 100,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Image(
                          image: NetworkImage(
                            ConstRes.itemBaseUrl +
                                widget.videoData!.soundImage!,
                          ),
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(),
                        ),
                      ),
                      Center(
                        child: IconWithRoundGradient(
                          iconData: isPlay
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          size: 35,
                          onTap: () async {
                            if (!isPlay) {
                              int result = await audioPlayer.play(
                                ConstRes.itemBaseUrl + widget.videoData!.sound!,
                              );
                              audioPlayer.setReleaseMode(ReleaseMode.LOOP);
                              if (result == 1) {
                                print(result);
                              }
                            } else {
                              audioPlayer.release();
                            }
                            isPlay = !isPlay;
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        height: 25,
                        child: Marquee(
                          text: widget.videoData!.soundTitle!,
                          style: TextStyle(

                            fontSize: 22,
                          ),
                          scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          blankSpace: 50.0,
                          velocity: 100.0,
                          pauseAfterRound: Duration(seconds: 1),
                          startPadding: 10.0,
                          accelerationDuration: Duration(seconds: 1),
                          accelerationCurve: Curves.linear,
                          decelerationDuration: Duration(milliseconds: 500),
                          decelerationCurve: Curves.easeOut,
                        ),
                      ),
                      Text(
                        '$count Videos',
                        style: TextStyle(
                          color: colorTextLight,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        onTap: () {
                          isFav = !isFav;
                          sessionManager.saveFavouriteMusic(
                              widget.videoData!.soundId.toString());
                          setState(() {});
                        },
                        child: AnimatedContainer(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isFav
                                  ? [colorPrimary, colorPrimary]
                                  : [colorTheme, colorPink],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          height: 30,
                          width: isFav ? 130 : 110,
                          duration: Duration(milliseconds: 500),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                !isFav
                                    ? Icons.bookmark_border_rounded
                                    : Icons.bookmark_rounded,
                                color: Colors.white,
                                size: !isFav ? 21 : 18,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                isFav ? 'UnFavourite' : 'Favourite',
                                style: TextStyle(),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Stack(
                children: [
                  StreamBuilder(
                    stream: _streamController.stream,
                    builder: (context, snapshot) {
                      List<Data>? userVideo = [];
                      if (snapshot.data != null) {
                        userVideo = (snapshot.data as List<Data>?)!;
                        postList?.addAll(userVideo);
                        _streamController.add(null);
                      }
                      print(postList?.length);
                      return postList == null || postList!.isEmpty
                          ? DataNotFound()
                          : GridView(
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1 / 1.3,
                              ),
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.only(left: 10, bottom: 20),
                              children: List.generate(
                                postList?.length ?? 0,
                                (index) => ItemPost(
                                  list: postList,
                                  data: postList?[index],
                                  soundId: widget.videoData!.soundId.toString(),
                                  type: 3,
                                  onTap: () {
                                    audioPlayer.pause();
                                    isPlay = !isPlay;
                                    setState(() {});
                                  },
                                ),
                              ),
                            );
                    },
                  ),
                  Positioned(
                    bottom: 25,
                    right: 0,
                    left: 0,
                    child: Center(
                      child: Container(
                        height: 45,
                        width: 160,
                        decoration: BoxDecoration(
                          color: colorTheme,
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                        ),
                        child: InkWell(
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          onTap: () {
                            audioPlayer.pause();
                            isPlay = false;
                            setState(() {});
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CameraScreen(
                                  soundId: widget.videoData!.soundId.toString(),
                                  soundTitle: widget.videoData!.soundTitle,
                                  soundUrl: widget.videoData!.sound,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.play_circle_filled_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Use this sound ',
                                style: TextStyle(

                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void callApiForGetPostsBySoundId() {
    ApiService()
        .getPostBySoundId(
      start.toString(),
      ConstRes.count.toString(),
      widget.videoData!.soundId.toString(),
    )
        .then(
      (value) {
        start += ConstRes.count;
        isLoading = false;
        if (count == 0) {
          count = value.totalVideos;
          setState(() {});
        }
        _streamController.add(value.data);
      },
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  SessionManager sessionManager = SessionManager();

  void initIsFav() async {
    await sessionManager.initPref();
    isFav = sessionManager
        .getFavouriteMusic()
        .contains(widget.videoData!.soundId.toString());
    setState(() {});
  }
}
