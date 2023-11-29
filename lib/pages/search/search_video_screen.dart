import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/api_service.dart';
import '../../model/user_video.dart';
import '../../utils/const.dart';
import '../../utils/my_loading.dart';
import '../../utils/session_manager.dart';
import '../../widget/data_not_found.dart';
import 'item_search_video.dart';

class SearchVideoScreen extends StatefulWidget {
  @override
  _SearchVideoScreenState createState() => _SearchVideoScreenState();
}

class _SearchVideoScreenState extends State<SearchVideoScreen> {
  String keyWord = '';
  ApiService apiService = ApiService();

  int start = 0;
  var _streamController = StreamController<List<Data>?>();
  ScrollController _scrollController = ScrollController();

  List<Data> searchPostList = [];

  bool isLoading = true;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (!isLoading) {
          isLoading = true;
          callApiForPostList();
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetBuilder<MyLoading>(
          builder: (control) {
            start = 0;
            keyWord = control.searchText.value;
            searchPostList = [];
            callApiForPostList();
            return Container();
          },
        ),
        Expanded(
          child: StreamBuilder(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              List<Data>? searchVideo = [];
              if (snapshot.data != null) {
                searchVideo = (snapshot.data as List<Data>?)!;
                searchPostList.addAll(searchVideo);
              }
              return searchPostList.isEmpty
                  ? DataNotFound()
                  : GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1 / 1.4,
                      ),
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(left: 10, bottom: 20),
                      children: List.generate(
                        searchPostList.length,
                        (index) => ItemSearchVideo(
                          videoData: searchPostList[index],
                          postList: searchPostList,
                          type: 5,
                          keyWord: keyWord,
                        ),
                      ),
                    );
            },
          ),
        ),
      ],
    );
  }

  void callApiForPostList() {
    apiService.client.close();
    apiService
        .getSearchPostList(start.toString(), ConstRes.count.toString(),
            SessionManager.userId.toString(), keyWord)
        .then(
      (value) {
        if(value.data!=null){
          start += ConstRes.count;
          isLoading = false;
          _streamController.add(value.data);
        }

      },
    );
  }
}
