import 'dart:math';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:dondi/location_service/location_service.dart';
import 'package:dondi/pages/profile/proifle_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../api/api_service.dart';
import '../../model/user_video.dart';
import '../../utils/assert_image.dart';
import '../../utils/const.dart';
import '../../utils/session_manager.dart';
import '../../widget/dialog/loader_dialog.dart';
import '../comment/comment_screen.dart';
import '../login/dialog_login.dart';
import '../report/report_screen.dart';
import '../sendbubble/dialog_send_bubble.dart';
import '../sound/videos_by_sound.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ItemVideo extends StatefulWidget {
  final Data? videoData;

  ItemVideo(this.videoData);

  ItemVideoState? item;

  @override
  ItemVideoState createState() {
    item = ItemVideoState();
    return item!;
  }

  getState() => item;
}

class ItemVideoState extends State<ItemVideo> {
  refresh() {
    debugPrint('Page 1 refresh');
    setState(() {});
  }

  VideoPlayerController? controller;
  bool isIncreaseView = false;
  final controllerLat=Get.put(CollectLatLngController());
  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        InkWell(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          onLongPress: () {
            showModalBottomSheet(
              context: context,
              builder: (context) =>
                  ReportScreen(1, widget.videoData!.postId.toString()),
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
            );
          },
          child: _ButterFlyAssetVideo(
            widget.videoData!.postVideo,
            widget.videoData!.postId,
            (controller) {
              this.controller = controller;
            },
          ),
          onDoubleTap: () {},
        ),
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: VisibilityDetector(
                  onVisibilityChanged: (VisibilityInfo info) {
                    var visiblePercentage = info.visibleFraction * 100;
                    if (visiblePercentage > 50) {
                      if (controller != null) {
                        controller?.play();
                        if (!isIncreaseView &&
                            SessionManager.accessToken!.isNotEmpty) {
                          isIncreaseView = true;
                          ApiService().increasePostViewCount(
                              widget.videoData!.postId.toString());
                        }
                      }
                    } else {
                      if (controller != null) {
                        controller?.pause();
                      }
                    }
                  },
                  key: Key('key' + widget.videoData!.postVideo!),
                  child: Container(
                    margin: EdgeInsets.only(left: 15, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible:
                              widget.videoData!.profileCategoryName!.isNotEmpty,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.all(
                                Radius.circular(3),
                              ),
                            ),
                            margin: EdgeInsets.only(
                              bottom: 5,
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            child: Text(
                              widget.videoData!.profileCategoryName!,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),
                        InkWell(
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                  1, widget.videoData!.userId.toString()),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '@${widget.videoData!.userName}',
                                style: TextStyle(
                                  letterSpacing: 0.6,
                                  fontSize: 16,
                                  color: Colors.white,
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
                                width: 3,
                              ),
                              Image(
                                image: AssetImage(icVerify),
                                height:
                                    widget.videoData!.isVerify == 1 ? 18 : 0,
                                width: widget.videoData!.isVerify == 1 ? 18 : 0,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(widget.videoData!.user_country_flag??""),
                              SizedBox(width: 3,),
                              Text("${calculateDistance(controllerLat.lat.value, controllerLat.lng.value, widget.videoData!.user_lat, widget.videoData!.user_lng).toInt()} Kilo",style: TextStyle(
                                color: Colors.white
                              ),)
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible:
                              widget.videoData!.postDescription!.isNotEmpty,
                          child: GestureDetector(
                            onTap: (){
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         VideosByHashTagScreen(widget.videoData!.postDescription!,),
                              //   ),
                              // );
                            },
                            child: Text(
                              widget.videoData!.postDescription!,style: TextStyle(color: Colors.white),
                              maxLines: 5,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.videoData!.soundTitle != null
                              ? widget.videoData!.soundTitle!
                              : '',
                          maxLines: 1,
                          style: TextStyle(
                            letterSpacing: 0.6,
                            fontSize: 13,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  right: 15,
                  bottom: 20,
                ),
                child: Column(
                  children: [
                    BouncingWidget(
                      duration: Duration(milliseconds: 100),
                      scaleFactor: 1,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                                1, widget.videoData!.userId.toString()),
                          ),
                        );
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: colorPink,
                              blurRadius: 2,
                              offset: Offset(1, 1),
                              spreadRadius: 1,
                            ),
                          ],
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Image(
                                image: AssetImage(icUserPlaceHolder),
                                color: colorLightWhite,
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              child: ClipOval(
                                child: Image.network(
                                  ConstRes.itemBaseUrl +
                                      widget.videoData!.userProfile!,
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
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Visibility(
                      visible:
                          SessionManager.userId != widget.videoData!.userId,
                      child: InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        onTap: () {
                          if (SessionManager.userId != -1) {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  DialogSendBubble(widget.videoData),
                            );
                          } else {
                            showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                ),
                              ),
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return DialogLogin();
                              },
                            );
                          }
                        },
                        child: ClipOval(
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(),
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: Image.asset(
                                icGift,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SessionManager.userId != widget.videoData!.userId
                          ? 15
                          : 0,
                    ),
                    LikeUnLikeButton(
                      widget.videoData,
                      () {
                        if (widget.videoData!.videoLikesOrNot == 1) {
                          widget.videoData!.setVideoLikesOrNot(0);
                        } else {
                          widget.videoData!.setVideoLikesOrNot(1);
                        }
                        setState(() {});
                      },
                    ),
                    Text(
                      NumberFormatter.formatter(
                        widget.videoData!.postLikesCount.toString(),
                      ),
                      style: TextStyle(
                        shadows: [
                          Shadow(
                              color: Colors.white,
                              offset: Offset(1, 1),
                              blurRadius: 3),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                          ),
                          backgroundColor: Color(0xFF00000000),
                          isScrollControlled: true,
                          builder: (context) {
                            return AnimatedPadding(
                              duration: Duration(milliseconds: 150),
                              curve: Curves.easeOut,
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: CommentScreen(widget.videoData, () {
                                setState(() {});
                              }),
                            );
                          },
                        );
                      },
                      child: Image(
                        height: 35,
                        width: 35,
                        image: AssetImage(icComment),
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      NumberFormatter.formatter(
                        widget.videoData!.postCommentsCount.toString(),
                      ),
                      style: TextStyle(
                        shadows: [
                          Shadow(
                            color: Colors.white,
                            offset: Offset(1, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      onTap: () {
                        shareLink(widget.videoData!);
                      },
                      child: Image(
                        height: 32,
                        width: 32,
                        image: AssetImage(icShare),
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    MusicDisk(widget.videoData),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void shareLink(Data videoData) async {
    showDialog(
      context: context,
      builder: (context) => LoaderDialog(),
    );
    BranchUniversalObject buo = BranchUniversalObject(
        canonicalIdentifier: 'flutter/branch',
        title: videoData.userName!,
        imageUrl: ConstRes.itemBaseUrl + videoData.postImage!,
        contentDescription: '',
        publiclyIndex: true,
        locallyIndex: true,
        contentMetadata: BranchContentMetaData()
          ..addCustomMetadata('post_id', videoData.postId));
    BranchLinkProperties lp = BranchLinkProperties(
        channel: 'facebook',
        feature: 'sharing',
        stage: 'new share',
        tags: ['one', 'two', 'three']);
    lp.addControlParam('url', 'http://www.google.com');
    lp.addControlParam('url2', 'http://flutter.dev');
    BranchResponse response =
        await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);
    if (response.success) {
      Share.share(
        'Check out this video ${response.result} 😋😋',
        subject: 'Look ${videoData.userName}',
      );
    } else {
      print('Error : ${response.errorCode} - ${response.errorMessage}');
    }
    Navigator.pop(context);
  }
}

class MusicDisk extends StatefulWidget {
  final Data? videoData;

  MusicDisk(this.videoData);

  @override
  _MusicDiskState createState() => _MusicDiskState();
}

class _MusicDiskState extends State<MusicDisk>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideosBySoundScreen(widget.videoData),
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * pi,
            child: child,
          );
        },
        child: Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: AssetImage(icBgDisk)),
          ),
          padding: EdgeInsets.all(10),
          child: ClipOval(
            child: Stack(
              children: [
                Center(
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorTheme,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Image(
                        image: AssetImage(icMusic),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // color: colorTheme,
                    ),
                    child: Image.network(
                      ConstRes.itemBaseUrl +
                          (widget.videoData!.soundImage != null
                              ? widget.videoData!.soundImage!
                              : ''),
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
        ),
      ),
    );
  }
}

class LikeUnLikeButton extends StatefulWidget {
  final Function likeUnlike;
  final Data? videoData;

  LikeUnLikeButton(this.videoData, this.likeUnlike);

  @override
  _LikeUnLikeButtonState createState() => _LikeUnLikeButtonState();
}

class _LikeUnLikeButtonState extends State<LikeUnLikeButton>
    with TickerProviderStateMixin {
  var squareScaleA = 1.0;
  late AnimationController _controllerA;

  @override
  void initState() {
    isLike = widget.videoData!.videoLikesOrNot == 1;
    _controllerA = AnimationController(
        vsync: this,
        lowerBound: 0.5,
        upperBound: 1.0,
        duration: Duration(milliseconds: 500));
    _controllerA.addListener(() {
      setState(() {
        squareScaleA = _controllerA.value;
      });
    });
    _controllerA.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isLike = !isLike;
        widget.likeUnlike();
        ApiService().likeUnlikePost(widget.videoData!.postId.toString());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controllerA.dispose();
    super.dispose();
  }

  bool isLike = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        _controllerA.forward(from: 0.0);
      },
      child: Transform.scale(
        scale: squareScaleA,
        child: Icon(
          Icons.star,
          color: isLike ? Colors.red : Colors.white,
          size: 40,
        ),
      ),
    );
  }
}

class _ButterFlyAssetVideo extends StatefulWidget {
  final String? url;
  final int? postId;
  final Function(VideoPlayerController?) function;

  _ButterFlyAssetVideo(this.url, this.postId, this.function);

  @override
  _ButterFlyAssetVideoState createState() => _ButterFlyAssetVideoState();
}

class _ButterFlyAssetVideoState extends State<_ButterFlyAssetVideo> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      ConstRes.itemBaseUrl + widget.url!,
      // isCached: Platform.isAndroid,
    );
    _controller!.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    _controller!.setLooping(true);
    _controller!.initialize().then((_) => {setState(() {})});
    widget.function.call(_controller);
    // _controller.play();
  }

  @override
  void dispose() {
    _controller!.dispose();
    _controller = null;
    widget.function.call(null);
    super.dispose();
  }

  bool isIncreaseView = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: InkWell(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            onTap: () {
              if (_controller != null && _controller!.value.isPlaying) {
                _controller!.pause();
              } else {
                _controller!.play();
              }
            },
            child: Center(
              child: SizedBox.expand(
                child: FittedBox(
                  fit: _controller?.value != null &&
                          _controller?.value.size != null &&
                          _controller?.value.size.width != null &&
                          _controller?.value.size.height != null &&
                          (_controller!.value.size.width >=
                                  (_controller!.value.size.height) ||
                              _controller?.value.size.height ==
                                  _controller?.value.size.width)
                      ? BoxFit.fitWidth
                      : BoxFit.cover,
                  child: SizedBox(
                    width: _controller?.value.size.width ?? 0,
                    height: _controller?.value.size.height ?? 0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Center(
                          child: VisibilityDetector(
                            onVisibilityChanged: (VisibilityInfo info) {},
                            key: Key(widget.postId.toString()),
                            child: VideoPlayer(
                              _controller!,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
