
import 'package:flutter/material.dart';

import '../../api/api_service.dart';
import '../../model/sound/sound.dart';
import 'item_fav_music_screen.dart';

class FavouritePage extends StatefulWidget {
  final Function? onClick;

  FavouritePage({this.onClick});

  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  List<SoundList>? favMusicList = [];

  @override
  void initState() {
    getFavouriteSoundList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: List<ItemFavMusicScreen>.generate(
        favMusicList!.length,
        (index) => ItemFavMusicScreen(favMusicList![index], (soundUrl) {
          widget.onClick!(soundUrl);
        }, 2),
      ),
    );
  }

  void getFavouriteSoundList() {
    ApiService().getFavouriteSoundList().then((value) {
      favMusicList = value.data;
      setState(() {});
    });
  }
}
