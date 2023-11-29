import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:dondi/pages/music/search_screen.dart';
import 'package:dondi/utils/my_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../model/sound/sound.dart';
import '../../utils/const.dart';
import '../../widget/dialog/loader_dialog.dart';
import 'discover_page.dart';
import 'favourite_page.dart';

class MainMusicPage extends StatefulWidget {
  final Function(SoundList?, String) onSelectMusic;
  const MainMusicPage({Key? key,required this.onSelectMusic}) : super(key: key);

  @override
  State<MainMusicPage> createState() => _MainMusicPageState();
}

class _MainMusicPageState extends State<MainMusicPage> {
  PageController? _controller;
  FocusNode _focus = new FocusNode();
  List<SoundList>? soundList;
  bool isPlay = false;
  SoundList? lastSoundListData;
  final commonController=Get.put(MyLoading());
  AudioPlayer? audioPlayer = AudioPlayer();

  String _localPath = '';

  @override
  void initState() {
    _focus.addListener(() {
      debugPrint("Focus: " + _focus.hasFocus.toString());
      commonController
          .setIsSearchMusic(_focus.hasFocus);
      soundList = null;
    });
    _controller = PageController(
        initialPage:
        commonController.musicPageIndex.value,
        keepPage: true);
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
  }

  ReceivePort _port = ReceivePort();

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      print('UI Isolate Callback: $data');
      DownloadTaskStatus status = data[1];

      if (status.value == 3) {
        widget.onSelectMusic(lastSoundListData,
            _localPath + Platform.pathSeparator + lastSoundListData!.sound!);
        Navigator.pop(context);
        Navigator.pop(context);
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    // if (debug) {
    print(
        'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    // }
    final SendPort send =
    IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.968,
      child: Column(
        children: [
          GetBuilder<MyLoading>(
            builder: (control) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Visibility(
                    visible: soundList != null && control.isSearchMusic.value,
                    child: InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      overlayColor:
                      MaterialStateProperty.all(Colors.transparent),
                      onTap: () {
                        if (control.musicSearchText.isEmpty) {
                          FocusScope.of(context).unfocus();

                          control.setIsSearchMusic(false);
                          control.setLastSelectSoundId("");
                          soundList = null;
                          if (audioPlayer != null) {
                            audioPlayer?.release();
                          }
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 15, top: 15),
                        child: Text(
                          'Back',
                        ),
                        width: 45,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: soundList != null ? 0 : 15, top: 15, right: 15),
                      padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
                      height: 45,
                      decoration: BoxDecoration(
                        color: colorPrimary,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          if (audioPlayer != null) {
                            audioPlayer?.release();
                          }
                          control.setMusicSearchText(value);
                          control.setLastSelectSoundId("");
                        },
                        focusNode: _focus,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: colorTextLight,
                            fontSize: 15,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: soundList == null && control.isSearchMusic.value,
                    child: InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      overlayColor:
                      MaterialStateProperty.all(Colors.transparent),
                      onTap: () {
                        if (control.musicSearchText.isEmpty) {
                          FocusScope.of(context).unfocus();
                          if (audioPlayer != null) {
                            audioPlayer?.release();
                          }
                          control
                              .setIsSearchMusic(false);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          control.musicSearchText.isNotEmpty
                              ? 'Search'
                              : 'Cancel',
                        ),
                        width: 60,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Container(
            margin: EdgeInsets.only(bottom: 18),
            height: 0,
          ),
          GetBuilder<MyLoading>(
            builder: (control) {
              return Visibility(
                visible: !control.isSearchMusic.value,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        overlayColor:
                        MaterialStateProperty.all(Colors.transparent),
                        onTap: () {
                          _controller!.animateToPage(0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.linear);
                        },
                        child: Center(
                          child: Text(
                            'Discover',
                            style: TextStyle(
                              color: control.musicPageIndex.value == 0
                                  ? Colors.white
                                  : colorTextLight,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        overlayColor:
                        MaterialStateProperty.all(Colors.transparent),
                        onTap: () {
                          _controller!.animateToPage(1,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.linear);
                        },
                        child: Center(
                          child: Text(
                            'Favourite',
                            style: TextStyle(
                              color: control.musicPageIndex.value == 1
                                  ? Colors.white
                                  : colorTextLight,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Container(
            margin: EdgeInsets.only(top: 18),
            height: 0.2,
            color: colorTextLight,
          ),
          Expanded(
            child: GetBuilder<MyLoading>(
              builder: (control) {
                return control.isSearchMusic.value
                    ? PageView(
                  controller: _controller,
                  onPageChanged: (value) {
                    control
                        .setLastSelectSoundId("");
                    control
                        .setMusicPageIndex(value);
                    audioPlayer?.release();
                  },
                  children: [
                    DiscoverPage(
                      onMoreClick: (value) {
                        soundList = value;
                        control
                            .setIsSearchMusic(true);
                      },
                      onPlayClick: (data) {
                        playMusic(data, 1);
                      },
                    ),
                    FavouritePage(
                      onClick: (data) {
                        playMusic(data, 2);
                      },
                    ),
                  ],
                )
                    : (soundList != null && soundList!.isNotEmpty
                    ? SearchMusicScreen(
                  soundList: soundList,
                  onSoundClick: (data) {
                    playMusic(data, 3);
                  },
                )
                    : SearchMusicScreen(
                  onSoundClick: (data) {
                    playMusic(data, 3);
                  },
                ));
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    audioPlayer?.release();
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void playMusic(SoundList data, int type) async {
    MyLoading myLoading = Get.put(MyLoading());
    if (myLoading.isDownloadClick.value) {
      showDialog(
        context: context,
        builder: (context) => LoaderDialog(),
      );
      myLoading.setIsDownloadClick(false);
      _localPath =
          (await _findLocalPath()) + Platform.pathSeparator + ConstRes.camera;

      final savedDir = Directory(_localPath);

      bool hasExisted = await savedDir.exists();
      if (!hasExisted) {
        savedDir.create();
      }
      if (File(savedDir.path + "/" + data.sound!).existsSync()) {
        File(savedDir.path + "/" + data.sound!).deleteSync();
      }
      await FlutterDownloader.enqueue(
        url: "${ConstRes.itemBaseUrl + data.sound!}",
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true,
      );
      return;
    }
    if (lastSoundListData == data) {
      if (isPlay) {
        isPlay = false;
        audioPlayer?.pause();
      } else {
        isPlay = true;
        audioPlayer?.resume();
      }
      myLoading.setLastSelectSoundIsPlay(isPlay);
      return;
    }
    lastSoundListData = data;
    myLoading.setLastSelectSoundId(lastSoundListData!.sound! + type.toString());
    myLoading.setLastSelectSoundIsPlay(true);
    if (audioPlayer != null) {
      audioPlayer?.release();
    }
    audioPlayer?.play(ConstRes.itemBaseUrl + "${lastSoundListData?.sound}");
    isPlay = true;
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await (getExternalStorageDirectory())
        : await getApplicationDocumentsDirectory();
    return "${directory?.path}";
  }
}
