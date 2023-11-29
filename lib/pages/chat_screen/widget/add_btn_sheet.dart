import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../api/api_service.dart';
import '../../../utils/const.dart';
import 'image_video_msg_screen.dart';

class AddBtnSheet extends StatelessWidget {
  final Function(
      {String? msgType,
      String? imagePath,
      String? videoPath,
      String? msg}) fireBaseMsg;

  const AddBtnSheet({Key? key, required this.fireBaseMsg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 0.60,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          color: colorPrimary,
        ),
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Which item would you like to select?\nSelect a item',
                style: TextStyle(
                  color: colorTextLight,
                ),
                textAlign: TextAlign.center),
            SizedBox(
              height: 10,
            ),
            Divider(color: Colors.grey, indent: 15, endIndent: 15),
            SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () => onImageClick(context),
              child: Text(
                'Images',
                style: TextStyle(fontSize: 16,),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Divider(color: Colors.grey, indent: 15, endIndent: 15),
            SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () => onVideoClick(context),
              child: Text(
                'Videos',
                style: TextStyle(fontSize: 16, ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Divider(color: Colors.grey, indent: 15, endIndent: 15),
            SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                'Close',
                style: TextStyle(fontSize: 18, ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onImageClick(BuildContext context) async {
    File? images;
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null || image.path.isEmpty) return;
    images = File(image.path);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ImageVideoMsgScreen(
          image: images?.path,
          onIVSubmitClick: ({text}) {
            showDialog(
              context: context,
              builder: (context) {
                return Center(
                  child: CircularProgressIndicator(
                    color: colorPink,
                  ),
                );
              },
            );
            ApiService().filePath(filePath: images).then((value) {
              fireBaseMsg(
                  msgType: FirebaseConst.image,
                  imagePath: value.path,
                  videoPath: null,
                  msg: text);
            }).then((value) {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            });
          },
        );
      },
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void onVideoClick(BuildContext context) async {
    File? videos;
    String? imageUrl;
    String? videoUrl;
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? video = await _picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: Duration(seconds: 30),
    );
    if (video == null || video.path.isEmpty) return;

    /// calculating file size
    videos = File(video.path);
    int sizeInBytes = videos.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);

    if (sizeInMb <= 15) {
      await VideoThumbnail.thumbnailFile(
        video: videos.path,
      ).then((value) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return ImageVideoMsgScreen(
              image: value,
              onIVSubmitClick: ({text}) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: colorPink,
                    ));
                  },
                );
                ApiService()
                    .filePath(filePath: File(value ?? ''))
                    .then((value) {
                  imageUrl = value.path;
                }).then((value) {
                  ApiService().filePath(filePath: videos).then((value) {
                    videoUrl = value.path;
                  }).then((value) {
                    fireBaseMsg(
                        videoPath: videoUrl,
                        msgType: FirebaseConst.video,
                        imagePath: imageUrl,
                        msg: text);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                });
              },
            );
          },
        );
      });
    }
  }
}
