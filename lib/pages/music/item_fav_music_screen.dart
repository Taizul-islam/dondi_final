
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/sound/sound.dart';
import '../../utils/const.dart';
import '../../utils/my_loading.dart';
import '../../utils/session_manager.dart';

class ItemFavMusicScreen extends StatefulWidget {
  final SoundList soundList;
  final Function onItemClick;
  final int type;

  ItemFavMusicScreen(this.soundList, this.onItemClick, this.type);

  @override
  _ItemFavMusicScreenState createState() => _ItemFavMusicScreenState();
}

class _ItemFavMusicScreenState extends State<ItemFavMusicScreen> {
  final SessionManager sessionManager = new SessionManager();

  @override
  void initState() {
    initSessionManager();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        widget.onItemClick(widget.soundList);
      },
      child: Container(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            GetBuilder<MyLoading>(
              builder: (controller) => Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: Image(
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          ConstRes.itemBaseUrl + widget.soundList.soundImage!),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Visibility(
                      visible: controller.lastSelectSoundId ==
                          widget.soundList.sound! + widget.type.toString(),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            !controller.lastSelectSoundIsPlay.value
                                ? Icons.play_arrow_rounded
                                : Icons.pause_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.soundList.soundTitle!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.soundList.singer!,
                    style: TextStyle(
                      color: colorTextLight,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    widget.soundList.duration!,
                    style: TextStyle(
                      color: colorTextLight,
                      fontSize: 13,
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              onTap: () {
                sessionManager
                    .saveFavouriteMusic(widget.soundList.soundId.toString());
                setState(() {});
              },
              child: Icon(
                sessionManager
                        .getFavouriteMusic()
                        .contains(widget.soundList.soundId.toString())
                    ? Icons.bookmark
                    : Icons.bookmark_border_rounded,
                color: colorTheme,
              ),
            ),
            GetBuilder<MyLoading>(
              builder: (control) => Visibility(
                visible: control.lastSelectSoundId ==
                    widget.soundList.sound! + widget.type.toString(),
                child: InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  onTap: () async {
                    control
                        .setIsDownloadClick(true);
                    widget.onItemClick(widget.soundList);
                  },
                  child: Container(
                    width: 50,
                    height: 25,
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: colorTheme,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 20,
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

  void initSessionManager() async {
    sessionManager.initPref().then((value) {
      setState(() {});
    });
  }
}
