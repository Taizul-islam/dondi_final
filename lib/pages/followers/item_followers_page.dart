import 'dart:async';

import 'package:dondi/pages/profile/proifle_screen.dart';
import 'package:flutter/material.dart';

import '../../api/api_service.dart';
import '../../model/follower_following_data.dart';
import '../../utils/const.dart';
import '../../widget/data_not_found.dart';
import 'item_follower.dart';

class ItemFollowersPage extends StatefulWidget {
  final int? userId;
  final int type;

  ItemFollowersPage(this.userId, this.type);

  @override
  _ItemFollowersPageState createState() => _ItemFollowersPageState();
}

class _ItemFollowersPageState extends State<ItemFollowersPage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final StreamController _streamController =
      StreamController<List<FollowerUserData>?>();

  List<FollowerUserData> userList = [];

  int start = 0;

  bool isLoading = true;

  @override
  void initState() {
    _scrollController.addListener(
      () {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          if (!isLoading) {
            callApiForFollowerOrFollowing();
          }
        }
      },
    );
    callApiForFollowerOrFollowing();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: _streamController.stream,
      builder: (context, snapshot) {
        List<FollowerUserData>? userTempList = [];
        if (snapshot.data != null) {
          userTempList = (snapshot.data as List<FollowerUserData>?)!;
          userList.addAll(userTempList);
          _streamController.add(null);
        }
        print(userList.length);
        return userList.isEmpty
            ? DataNotFound()
            : ListView(
                physics: BouncingScrollPhysics(),
                controller: _scrollController,
                padding: EdgeInsets.only(left: 10, bottom: 20),
                children: List.generate(
                    userList.length,
                    (index) => InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                  1,
                                  widget.type == 0
                                      ? userList[index].fromUserId.toString()
                                      : userList[index].toUserId.toString(),
                                ),
                              ),
                            ),
                        child: ItemFollowers(userList[index]))),
              );
      },
    );
  }

  void callApiForFollowerOrFollowing() {
    isLoading = true;
    ApiService()
        .getFollowersList(widget.userId.toString(), start.toString(),
            ConstRes.count.toString(), widget.type)
        .then((value) {
      start += ConstRes.count;
      isLoading = false;
      _streamController.add(value.data);
    });
  }

  @override
  bool get wantKeepAlive => true;
}
