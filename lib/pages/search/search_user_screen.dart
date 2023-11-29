import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/api_service.dart';
import '../../model/search_user.dart';
import '../../utils/const.dart';
import '../../utils/my_loading.dart';
import '../../widget/data_not_found.dart';
import 'item_search_user.dart';

class SearchUserScreen extends StatefulWidget {
  @override
  _SearchUserScreenState createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  String keyWord = '';
  ApiService apiService = ApiService();

  int start = 0;
  var _streamController = StreamController<List<SearchUserData>?>();
  ScrollController _scrollController = ScrollController();

  List<SearchUserData>? searchUserList = [];

  bool isLoading = true;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (!isLoading) {
          isLoading = true;
          callApiForSearchUsers();
        }
      }
    });
    // callApiForSearchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetBuilder<MyLoading>(
          builder: (controll) {
            start = 0;
            keyWord = controll.searchText.value;
            searchUserList = [];
            callApiForSearchUsers();
            return Container();
          },
        ),
        Expanded(
          child: StreamBuilder(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              List<SearchUserData>? searchUser = [];
              if (snapshot.data != null) {
                searchUser = (snapshot.data as List<SearchUserData>?)!;
                searchUserList?.addAll(searchUser);
              }
              return searchUserList == null || searchUserList!.isEmpty
                  ? DataNotFound()
                  : ListView(
                      physics: BouncingScrollPhysics(),
                      controller: _scrollController,
                      padding: EdgeInsets.only(left: 10, bottom: 20),
                      children: List.generate(
                        searchUserList?.length ?? 0,
                        (index) => ItemSearchUser(searchUserList?[index]),
                      ),
                    );
            },
          ),
        ),
      ],
    );
  }

  void callApiForSearchUsers() {
    apiService.client.close();

    apiService
        .getSearchUser(start.toString(), ConstRes.count.toString(), keyWord)
        .then((value) {
      start += ConstRes.count;
      isLoading = false;
      _streamController.add(value.data);
    });
  }
}
