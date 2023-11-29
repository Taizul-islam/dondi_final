import 'dart:async';

import 'package:flutter/material.dart';

import '../../../api/api_service.dart';
import '../../../model/notification.dart';
import '../../../utils/const.dart';
import '../../../widget/data_not_found.dart';
import 'item_notification.dart';

class NotificationList extends StatefulWidget {
  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  int start = 0;

  var _streamController = StreamController<List<NotificationData>?>();

  ScrollController _scrollController = ScrollController();

  List<NotificationData> notificationList = [];

  bool isLoading = true;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (!isLoading) {
          isLoading = true;
          callApiForNotificationList();
        }
      }
    });
    callApiForNotificationList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _streamController.stream,
      builder: (context, snapshot) {
        List<NotificationData>? notificationsData = [];
        if (snapshot.data != null) {
          notificationsData = (snapshot.data as List<NotificationData>?)!;
          notificationList.addAll(notificationsData);
        }
        return notificationList.isEmpty
            ? DataNotFound()
            : ListView(
                physics: BouncingScrollPhysics(),
                controller: _scrollController,
                children: List.generate(notificationList.length,
                    (index) => ItemNotification(notificationList[index])),
              );
      },
    );
  }

  void callApiForNotificationList() {
    ApiService()
        .getNotificationList(start.toString(), ConstRes.count.toString())
        .then(
      (value) {
        start += ConstRes.count;
        isLoading = false;
        _streamController.add(value.data);
      },
    );
  }
}
