
import 'package:dondi/model/category_explorer.dart';
import 'package:flutter/material.dart';

import '../../model/explore_hash_tag.dart';
import '../../utils/const.dart';
import '../hashtag/videos_by_hashtag.dart';
import 'package:get/get.dart';
class ItemExplore extends StatelessWidget {
  final ExplorerCategory exploreData;
  const ItemExplore(this.exploreData, {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: InkWell(
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideosByHashTagScreen(
                exploreData.categoryId.toString()
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: colorPrimaryDark,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          margin: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                exploreData.categoryName!,
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "Videos ${exploreData.videosCount!}",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
