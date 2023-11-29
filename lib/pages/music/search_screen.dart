import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/api_service.dart';
import '../../model/sound/sound.dart';
import '../../utils/my_loading.dart';
import '../../widget/data_not_found.dart';
import 'item_fav_music_screen.dart';

class SearchMusicScreen extends StatefulWidget {
  final List<SoundList>? soundList;
  final Function onSoundClick;

  SearchMusicScreen({this.soundList, required this.onSoundClick});

  @override
  _SearchMusicScreenState createState() => _SearchMusicScreenState();
}

class _SearchMusicScreenState extends State<SearchMusicScreen> {
  var _streamController = StreamController<List<SoundList>?>();
  bool isSearch = true;

  @override
  void initState() {
    if (widget.soundList != null) {
      isSearch = false;
      _streamController.add(widget.soundList);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyLoading>(
      builder: (control) {
        if (isSearch) {
          getSearchSoundList(control.musicSearchText.value);
        }
        return StreamBuilder<List<SoundList>?>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            return snapshot.data != null && snapshot.data!.isNotEmpty
                ? ListView(
                    physics: BouncingScrollPhysics(),
                    children: List<ItemFavMusicScreen>.generate(
                      snapshot.data!.length,
                      (index) => ItemFavMusicScreen(
                        snapshot.data![index],
                        (soundUrl) {
                          widget.onSoundClick(soundUrl);
                        },
                        3,
                      ),
                    ),
                  )
                : DataNotFound();
          },
        );
      },
    );
  }

  ApiService apiService = ApiService();

  void getSearchSoundList(String keyword) {
    apiService.client.close();
    apiService.getSearchSoundList(keyword).then((value) {
      _streamController.add(value.data);
    });
  }
}
