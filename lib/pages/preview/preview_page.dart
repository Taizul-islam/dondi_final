import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../utils/const.dart';
import '../upload/upload_screen.dart';
class PreviewPage extends StatefulWidget {
  final String? postVideo;
  final String? thumbNail;
  final String? sound;
  final String? soundId;
  const PreviewPage({Key? key,this.postVideo, this.thumbNail, this.sound, this.soundId}) : super(key: key);

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  VideoPlayerController? _controller;
  UploadPage? uploadScreen;

  @override
  void initState() {
    uploadScreen = UploadPage(
      postVideo: widget.postVideo,
      thumbNail: widget.thumbNail,
      soundId: widget.soundId,
      sound: widget.sound,
    );
    print(widget.postVideo);
    _controller = VideoPlayerController.file(File(widget.postVideo!));
    _controller!.addListener(() {
      setState(() {});
    });
    _controller!.setLooping(true);
    _controller!.initialize().then((_) => {setState(() {})});
    _controller!.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 55,
              child: Stack(
                children: [
                  InkWell(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.chevron_left_rounded,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Preview',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 0.3,
              color: colorTextLight,
              margin: EdgeInsets.only(bottom: 0),
            ),
            Expanded(
              child: Stack(
                children: [
                  FittedBox(
                    fit: _controller?.value != null &&
                        _controller?.value.size != null &&
                        _controller?.value.size.width != null &&
                        _controller?.value.size.height != null &&
                        (_controller!.value.size.width >=
                            (_controller!.value.size.height * 2) ||
                            _controller?.value.size.height ==
                                _controller!.value.size.width)
                        ? BoxFit.fitWidth
                        : BoxFit.cover,
                    child: SizedBox(
                      width: _controller?.value.size.width ?? 0,
                      height: _controller?.value.size.height ?? 0,
                      child: Stack(
                        children: [
                          VideoPlayer(_controller!),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 25,
                    right: 0,
                    left: 0,
                    child: InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      overlayColor:
                      MaterialStateProperty.all(Colors.transparent),
                      onTap: () => showModalBottomSheet(
                        context: context,
                        builder: (context) => Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: uploadScreen,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        backgroundColor: colorPrimaryDark,
                        isScrollControlled: true,
                      ),
                      child: Center(
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorTheme,
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            color: Colors.white,
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

  @override
  void dispose() {
    _controller!.dispose();
    _controller = null;
    super.dispose();
  }
}
