import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';

import 'package:bubbly_camera/bubbly_camera.dart';
import 'package:dondi/pages/music/main_music_page.dart';
import 'package:dondi/pages/preview/preview_page.dart';
import 'package:dondi/utils/my_loading.dart';
import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../model/sound/sound.dart';
import '../../utils/assert_image.dart';
import '../../utils/const.dart';
import '../../widget/dialog/loader_dialog.dart';
import '../../widget/dialog/simple_dialog.dart';


class CameraScreen extends StatefulWidget {
  final String? soundUrl;
  final String? soundTitle;
  final String? soundId;

  CameraScreen({this.soundUrl, this.soundTitle, this.soundId});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool isFlashOn = false;
  bool isFront = false;
  bool isSelected15s = true;
  bool isMusicSelect = false;
  bool isStartRecording = false;
  bool isShowPlayer = false;
  String? soundId = '';



  Timer? timer;
  double currentSecond = 0;
  double currentPercentage = 0;
  int currentTime = 0;
  double totalSeconds = 15;

  AudioPlayer? _audioPlayer;

  SoundList? _selectedMusic;
  String? _localMusic;
  final controller=Get.put(MyLoading());

  @override
  void initState() {
    print('camera screen');
    super.initState();
    if (widget.soundUrl != null) {
      soundId = widget.soundId;
      _bindBackgroundIsolate();
      FlutterDownloader.registerCallback(downloadCallback);
      downloadMusic();
    }
    MethodChannel(ConstRes.bubblyCamera).setMethodCallHandler((payload) async {
      print(payload.arguments);
      gotoPreviewScreen(payload.arguments.toString());
      return;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _audioPlayer?.release();
    _audioPlayer?.dispose();
    _unbindBackgroundIsolate();
    super.dispose();
  }

  final Map<String, dynamic> creationParams = <String, dynamic>{};
  FlutterVideoInfo _flutterVideoInfo = FlutterVideoInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Platform.isAndroid ? AndroidView(
                  viewType: 'camera',
                  layoutDirection: TextDirection.ltr,
                  creationParams: creationParams,
                  creationParamsCodec: StandardMessageCodec(),
                ):UiKitView(
                  viewType: 'camera',
                  layoutDirection: TextDirection.ltr,
                  creationParams: creationParams,
                  creationParamsCodec: StandardMessageCodec(),
                ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 35, right: 20, left: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white,
                    value: currentPercentage / 100,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: IconWithRoundGradient(
                  size: 22,
                  iconData: Icons.close_rounded,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (mContext) => SimpleCustomDialog(
                        title: 'Are you sure',
                        message: 'Do you really want to go back?',
                        negativeText: 'No',
                        positiveText: 'Yes',
                        onButtonClick: (clickType) {
                          if (clickType == 1) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          } else {}
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            top: 65,
            right: 65,
            left: 65,
            child: Visibility(
              visible: isMusicSelect,
              child: Text(
                widget.soundTitle != null ? widget.soundTitle! : _selectedMusic != null ? _selectedMusic!.soundTitle! : '',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            right: 20,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: IconWithRoundGradient(
                    size: 20,
                    iconData: !isFlashOn
                        ? Icons.flash_on_rounded
                        : Icons.flash_off_rounded,
                    onTap: () async {
                      isFlashOn = !isFlashOn;
                      setState(() {});
                      await BubblyCamera.flashOnOff;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: IconWithRoundGradient(
                    iconData: Icons.flip_camera_android_rounded,
                    size: 20,
                    onTap: () async {
                      isFront = !isFront;
                      await BubblyCamera.toggleCamera;
                      setState(() {});
                    },
                  ),
                ),
                Visibility(
                  visible: soundId == null || soundId!.isEmpty,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () => showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      backgroundColor: colorPrimaryDark,
                      builder: (context) => MainMusicPage(
                         onSelectMusic: (data, localMusic) async {
                           isMusicSelect = true;
                           _selectedMusic = data;
                           _localMusic = localMusic;
                           soundId = data?.soundId.toString();
                           setState(() {});
                         },
                      ),
                      isScrollControlled: true,
                    ).then(
                      (value) => controller
                          .setLastSelectSoundId(''),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: ImageWithRoundGradient(icMusic, 11),
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(top: 20),
                //   child: IconWithRoundGradient(
                //       iconData: Icons.star_rounded, size: 24),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(top: 20),
                //   child: ImageWithRoundGradient(icEffect, 10),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(top: 20),
                //   child: ImageWithRoundGradient(icFilter, 10),
                // ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Visibility(
                  visible: !isMusicSelect,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        onTap: () {
                          isSelected15s = true;
                          totalSeconds = 15;
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                isSelected15s ? Colors.white54 : Colors.black54,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          height: 28,
                          width: 60,
                          child: Center(
                            child: Text(
                              '15s',
                              style: TextStyle(
                                color:
                                    isSelected15s ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        onTap: () {
                          isSelected15s = false;
                          totalSeconds = 30;
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: isSelected15s
                                  ? Colors.black54
                                  : Colors.white54,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          height: 28,
                          width: 60,
                          child: Center(
                            child: Text(
                              '30s',
                              style: TextStyle(
                                color:
                                    isSelected15s ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 40,
                      height: isMusicSelect ? 0 : 40,
                      child: IconWithRoundGradient(
                        iconData: Icons.image,
                        size: isMusicSelect ? 0 : 20,
                        onTap: () {
                          showFilePicker();
                        },
                      ),
                    ),
                    ClipOval(
                      child: InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        onTap: () async {
                          isStartRecording = !isStartRecording;
                          setState(() {});
                          startProgress();
                        },
                        child: Container(
                          height: 85,
                          width: 85,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorTheme,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !isStartRecording,
                      child: IconWithRoundGradient(
                        iconData: Icons.check_circle_rounded,
                        size: 20,
                        onTap: () async {
                          if (soundId != null &&
                              soundId!.isNotEmpty &&
                              Platform.isIOS) {
                            await BubblyCamera.mergeAudioVideo(
                                _localMusic ?? '');
                          } else {
                            await BubblyCamera.stopRecording;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          )
        ],
      ),
    );
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
    _port.listen((dynamic data) async {
      print('UI Isolate Callback: $data');
      DownloadTaskStatus status = data[1];

      if (status.value == 3) {
        Navigator.pop(context);
        print('success' + _localMusic!);
        _audioPlayer = AudioPlayer();
        isMusicSelect = true;
        _localMusic = _localMusic! + '/' + widget.soundUrl!;
        setState(() {});
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
    final SendPort send= IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await (getExternalStorageDirectory())
        : await getApplicationDocumentsDirectory();
    return directory!.path;
  }

  void downloadMusic() async {
    _localMusic =
        (await _findLocalPath()) + Platform.pathSeparator + ConstRes.camera;
    final savedDir = Directory(_localMusic!);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    if (File(_localMusic! + widget.soundUrl!).existsSync()) {
      File(_localMusic! + widget.soundUrl!).deleteSync();
    }
    await FlutterDownloader.enqueue(
      url: ConstRes.itemBaseUrl + widget.soundUrl!,
      savedDir: _localMusic!,
      showNotification: false,
      openFileFromNotification: false,
    );
    showDialog(
      context: context,
      builder: (context) => LoaderDialog(),
    );
  }

  void startProgress() async {
    if (timer == null) {
      timer = Timer.periodic(Duration(milliseconds: 10), (time) async {
        currentSecond += 0.01;
        currentPercentage = (100 * currentSecond) / totalSeconds;
        print(currentSecond);
        if (totalSeconds.toInt() <= currentSecond.toInt()) {
          timer?.cancel();
          timer = null;
          if (soundId != null && soundId!.isNotEmpty && Platform.isIOS) {
            await BubblyCamera.mergeAudioVideo(_localMusic ?? '');
          } else {
            await BubblyCamera.stopRecording;
          }
          print('done');
        }
        setState(() {});
      });
    } else {
      if (isStartRecording) {
        timer!.cancel();
        timer = null;

        timer = Timer.periodic(Duration(milliseconds: 10), (time) async {
          currentSecond += 0.01;
          currentPercentage = (100 * currentSecond) / totalSeconds;
          print(currentSecond);
          if (totalSeconds.toInt() == currentSecond.toInt()) {
            timer?.cancel();
            timer = null;
            timer?.cancel();
            if (soundId != null && soundId!.isNotEmpty && Platform.isIOS) {
              await BubblyCamera.mergeAudioVideo(_localMusic ?? '');
            } else {
              await BubblyCamera.stopRecording;
            }
            print('done');
          }
          setState(() {});
        });
      } else {
        timer!.cancel();
        timer = null;
      }
    }
    if (isStartRecording) {
      if (currentSecond == 0) {
        if (soundId != null && soundId!.isNotEmpty) {
          _audioPlayer = AudioPlayer();
          await _audioPlayer!.play(_localMusic!, isLocal: true);
          var totalSecond = await Future.delayed(
              Duration(milliseconds: 300), () => _audioPlayer!.getDuration());
          totalSeconds = totalSecond / 1000;
          timer?.cancel();
          timer = Timer.periodic(Duration(milliseconds: 10), (time) async {
            currentSecond += 0.01;
            currentPercentage = (100 * currentSecond) / totalSeconds;
            print(currentSecond);
            if (totalSeconds.toInt() == currentSecond.toInt()) {
              timer?.cancel();
              timer = null;
              if (soundId != null && soundId!.isNotEmpty && Platform.isIOS) {
                await BubblyCamera.mergeAudioVideo(_localMusic ?? '');
              } else {
                await BubblyCamera.stopRecording;
              }
              print('done');
            }
            setState(() {});
          });
        }
        await BubblyCamera.startRecording;
      } else {
        await _audioPlayer?.resume();
        await BubblyCamera.resumeRecording;
      }
    } else {
      await _audioPlayer?.pause();
      await BubblyCamera.pauseRecording;
    }
  }

  void gotoPreviewScreen(String pathOfVideo) async {
    if (soundId != null && soundId!.isNotEmpty) {
      showLoader();
      String f = await _findLocalPath();
      if (!Platform.isAndroid) {
        FFmpegKit.execute(
                '-i $pathOfVideo -y -ss 00:00:01.000 -vframes 1 "$f${Platform.pathSeparator}thumbNail.png"')
            .then(
          (returnCode) {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PreviewPage(
                  postVideo: '$pathOfVideo',
                  thumbNail: "$f${Platform.pathSeparator}thumbNail.png",
                  soundId: soundId,
                ),
              ),
            );
          },
        );
      } else {
        if (Platform.isAndroid && isFront) {
          await FFmpegKit.execute(
              '-i "$pathOfVideo" -y -vf hflip "$f${Platform.pathSeparator}out1.mp4"');
          FFmpegKit.execute(
                  "-i \"$f${Platform.pathSeparator}out1.mp4\" -i $_localMusic -y -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -shortest $f${Platform.pathSeparator}out.mp4")
              .then((returnCode) {
            FFmpegKit.execute(
                    '-i $f${Platform.pathSeparator}out.mp4 -y -ss 00:00:01.000 -vframes 1 "$f${Platform.pathSeparator}thumbNail.png"')
                .then(
              (returnCode) {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreviewPage(
                      postVideo: '$f${Platform.pathSeparator}out.mp4',
                      thumbNail: "$f${Platform.pathSeparator}thumbNail.png",
                      soundId: soundId,
                    ),
                  ),
                );
              },
            );
          });
        } else {
          FFmpegKit.execute(
                  "-i $pathOfVideo -i $_localMusic -y -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -shortest $f${Platform.pathSeparator}out.mp4")
              .then((returnCode) {
            FFmpegKit.execute(
                    '-i $f${Platform.pathSeparator}out.mp4 -y -ss 00:00:01.000 -vframes 1 "$f${Platform.pathSeparator}thumbNail.png"')
                .then(
              (returnCode) {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreviewPage(
                      postVideo: '$f${Platform.pathSeparator}out.mp4',
                      thumbNail: "$f${Platform.pathSeparator}thumbNail.png",
                      soundId: soundId,
                    ),
                  ),
                );
              },
            );
          });
        }
      }
      return;
    }
    showLoader();
    String f = await _findLocalPath();
    String soundPath =
        '$f${Platform.pathSeparator + DateTime.now().millisecondsSinceEpoch.toString()}sound.wav';
    await FFmpegKit.execute('-i "$pathOfVideo" -y $soundPath');
    if (Platform.isAndroid && isFront) {
      await FFmpegKit.execute(
          '-i "$pathOfVideo" -y -vf hflip "$f${Platform.pathSeparator}out1.mp4"');
      FFmpegKit.execute(
              '-i "$f${Platform.pathSeparator}out1.mp4" -y -ss 00:00:01.000 -vframes 1 "$f${Platform.pathSeparator}thumbNail.png"')
          .then(
        (returnCode) {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PreviewPage(
                postVideo: '$f${Platform.pathSeparator}out1.mp4',
                thumbNail: '$f${Platform.pathSeparator}thumbNail.png',
                sound: soundPath,
              ),
            ),
          );
        },
      );
    } else {
      FFmpegKit.execute(
              '-i "$pathOfVideo" -y -ss 00:00:01.000 -vframes 1 "$f${Platform.pathSeparator}thumbNail.png"')
          .then(
        (returnCode) {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PreviewPage(
                postVideo: pathOfVideo,
                thumbNail: "$f${Platform.pathSeparator}thumbNail.png",
                sound: soundPath,
              ),
            ),
          );
        },
      );
    }
  }

  void showFilePicker() async {
    if (Platform.isIOS) {
      ImagePicker()
          .pickVideo(
              source: ImageSource.gallery, maxDuration: Duration(minutes: 1))
          .then(
        (value) async {
          if (value != null && value.path.isNotEmpty) {
            print(value.path);
            VideoData? a = await (_flutterVideoInfo.getVideoInfo(value.path));
            // print('${a.duration} ${a.filesize}');
            if (a!.filesize! / 1000000 > 40) {
              showDialog(
                context: context,
                builder: (mContext) => SimpleCustomDialog(
                  title: 'Too Large video',
                  message:
                      'This video is greater than 50 mb\nPlease select another...',
                  negativeText: 'Cancel',
                  positiveText: 'Select another',
                  onButtonClick: (clickType) {
                    if (clickType == 1) {
                      showFilePicker();
                    } else {}
                    Navigator.pop(context);
                  },
                ),
              );
              return;
            }
            if (a.duration! / 1000 > 60) {
              showDialog(
                context: context,
                builder: (mContext) => SimpleCustomDialog(
                  title: 'Too Long video',
                  message:
                      'This video is greater than 1 min\nPlease select another...',
                  negativeText: 'Cancel',
                  positiveText: 'Select another',
                  onButtonClick: (clickType) {
                    if (clickType == 1) {
                      showFilePicker();
                    } else {}
                  },
                ),
              );
              return;
            }
            showLoader();
            String f = await _findLocalPath();
            await FFmpegKit.execute(
                '-i "${value.path}" -y $f${Platform.pathSeparator}sound.wav');

            FFmpegKit.execute(
                    '-i "${value.path}" -y -ss 00:00:01.000 -vframes 1 "$f${Platform.pathSeparator}thumbNail.png"')
                .then(
              (returnCode) {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreviewPage(
                      postVideo: value.path,
                      thumbNail: "$f${Platform.pathSeparator}thumbNail.png",
                      sound: "$f${Platform.pathSeparator}sound.wav",
                    ),
                  ),
                );
              },
            );
          } else {}
          print(value!.path);
        },
      );
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp4'],
      );

      if (result != null &&
          result.files.isNotEmpty &&
          result.files.single.path != null &&
          result.files.single.path!.isNotEmpty) {
        print(result.files.single.path);
        VideoData? a =
            await (_flutterVideoInfo.getVideoInfo(result.files.single.path!));
        if (a!.filesize! / 1000000 > 40) {
          showDialog(
            context: context,
            builder: (mContext) => SimpleCustomDialog(
              title: 'Too Large video',
              message:
                  'This video is greater than 50 mb\nPlease select another...',
              negativeText: 'Cancel',
              positiveText: 'Select another',
              onButtonClick: (clickType) {
                if (clickType == 1) {
                  showFilePicker();
                } else {}
                Navigator.pop(context);
              },
            ),
          );
          return;
        }
        if (a.duration! / 1000 > 60) {
          showDialog(
            context: context,
            builder: (mContext) => SimpleCustomDialog(
              title: 'Too Long video',
              message:
                  'This video is greater than 1 min\nPlease select another...',
              negativeText: 'Cancel',
              positiveText: 'Select another',
              onButtonClick: (clickType) {
                if (clickType == 1) {
                  showFilePicker();
                } else {}
              },
            ),
          );
          return;
        }
        showLoader();
        String f = await _findLocalPath();
        await FFmpegKit.execute(
            '-i "${result.files.single.path}" -y $f${Platform.pathSeparator}sound.wav');

        FFmpegKit.execute(
                '-i "${result.files.single.path}" -y -ss 00:00:01.000 -vframes 1 "$f${Platform.pathSeparator}thumbNail.png"')
            .then(
          (returnCode) {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PreviewPage(
                  postVideo: result.files.single.path,
                  thumbNail: "$f${Platform.pathSeparator}thumbNail.png",
                  sound: "$f${Platform.pathSeparator}sound.wav",
                ),
              ),
            );
          },
        );
      } else {}
    }
  }

  void showLoader() {
    showDialog(
      context: context,
      builder: (context) => LoaderDialog(),
    );
  }
}

class IconWithRoundGradient extends StatelessWidget {
  final IconData iconData;
  final double size;
  final Function? onTap;

  IconWithRoundGradient(
      {required this.iconData, required this.size, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: InkWell(
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        onTap: () {
          onTap?.call();
        },
        child: Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorTheme,
                colorPink,
              ],
            ),
          ),
          child: Icon(
            iconData,
            color: Colors.white,
            size: size,
          ),
        ),
      ),
    );
  }
}

class ImageWithRoundGradient extends StatelessWidget {
  final String imageData;
  final double padding;

  ImageWithRoundGradient(this.imageData, this.padding);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        height: 38,
        width: 38,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorTheme,
              colorPink,
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Image(
            image: AssetImage(imageData),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
