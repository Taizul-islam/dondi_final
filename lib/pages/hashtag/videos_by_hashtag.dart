import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../api/api_service.dart';
import '../../model/user_video.dart';
import '../../utils/const.dart';
import '../../utils/session_manager.dart';
import '../../widget/data_not_found.dart';
import '../../widget/dialog/loader_dialog.dart';
import '../login/dialog_login.dart';
import '../search/item_search_video.dart';
import '../video/item_video.dart';

class VideosByHashTagScreen extends StatefulWidget {
  final String? hashTag;

  VideosByHashTagScreen(this.hashTag);

  @override
  _VideosByHashTagScreenState createState() => _VideosByHashTagScreenState();
}

class _VideosByHashTagScreenState extends State<VideosByHashTagScreen> {
  List<ItemVideo> mList=[];
  PageController? _pageController;
  String comment = '';
  var start = 0;
  var position = 0;

  var _editingController = TextEditingController();

  @override
  void initState() {
    print('videoListScreen');
    callApiForYou();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          statusBarIconBrightness: Platform.isAndroid?Brightness.light:Brightness.dark,
          statusBarBrightness: Platform.isAndroid?Brightness.light:Brightness.dark,
          statusBarColor: Colors.black
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: ClampingScrollPhysics(),
                    pageSnapping: true,
                    onPageChanged: (value) {
                      print(value);
                      if (value == mList.length - 1) {
                        callApiForYou();
                      }
                    },
                    scrollDirection: Axis.vertical,
                    children: mList,
                  ),
                ),
                Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _editingController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Leave your comment...',
                            hintStyle: TextStyle(
                              color: colorTextLight,

                            ),
                          ),
                          onChanged: (value) {
                            comment = value;
                          },
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ClipOval(
                        child: InkWell(
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                          onTap: () {
                            if (comment.isEmpty) {
                              Fluttertoast.showToast(
                                msg: 'Enter comment first',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                fontSize: 16.0,
                              );
                            } else {
                              if (SessionManager.userId == -1) {
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
                                return;
                              }
                              showDialog(
                                context: context,
                                builder: (context) => LoaderDialog(),
                              );
                              ApiService()
                                  .addComment(
                                comment,
                                mList[position].videoData!.postId.toString(),
                              )
                                  .then(
                                    (value) {
                                  Navigator.pop(context);
                                  _editingController.clear();
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  mList[position]
                                      .videoData!
                                      .setPostCommentCount(true);
                                  mList[position].getState().refresh();
                                },
                              );
                            }
                          },
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Colors.white,

                            ),
                            child: Icon(
                              Icons.send_rounded,
                              color: Colors.black,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            InkWell(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              onTap: () {
                Navigator.pop(context);
              },
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.chevron_left_rounded,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void callApiForYou() {
    ApiService()
        .getPostByHashTag(



      start.toString(),
      ConstRes.count.toString(),
      widget.hashTag,
    )
        .then(
          (value) {
        if (value.data != null && value.data!.isNotEmpty) {
          if (mList.isEmpty) {
            mList = List<ItemVideo>.generate(
              value.data!.length,
                  (index) {
                return ItemVideo(value.data![index]);
              },
            );
            setState(() {});
          } else {
            for (Data data in value.data!) {
              mList.add(ItemVideo(data));
            }
          }
          start += ConstRes.count;
          print(mList.length);
        }
      },
    );
  }
}
