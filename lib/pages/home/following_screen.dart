
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../api/api_service.dart';
import '../../model/user_video.dart';
import '../../utils/assert_image.dart';
import '../../utils/const.dart';
import '../../utils/session_manager.dart';
import '../video/item_video.dart';
import 'item_following.dart';

class FollowingScreen extends StatefulWidget {
  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> with AutomaticKeepAliveClientMixin {
  List<Widget> mList = [];
  PageController pageController = PageController();
  bool isFollowingDataEmpty = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return isFollowingDataEmpty ? Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height*0.4),
        Image(
          height: 70,
          image: AssetImage("assets/images/logo.png"),
        ),
        SizedBox(height: 20),
        Text(
          'Popular Creator',
          style: TextStyle(
            fontSize: 18,
            color: colorLightWhite,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Follow some creators to\n watch their videos.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 17,
            //color: colorTextLight,
            color: colorLightWhite,
          ),
        ),
        // Expanded(
        //   child: Container(
        //     height: 390,
        //     margin: EdgeInsets.only(top: 30),
        //     child: CarouselSlider(
        //       options: CarouselOptions(
        //         enlargeCenterPage: true,
        //         scrollPhysics: BouncingScrollPhysics(),
        //         height: MediaQuery.of(context).size.width + (MediaQuery.of(context).size.width / 100),
        //         enableInfiniteScroll: false,
        //         viewportFraction: 0.65,
        //       ),
        //       items: mList,
        //     ),
        //   ),
        // ),
      ],
    ) : PageView(
      physics: BouncingScrollPhysics(),
      controller: pageController,
      pageSnapping: true,
      onPageChanged: (value) {
        if (value == mList.length - 1) {
          callApiFollowing();
        }
      },
      scrollDirection: Axis.vertical,
      children: mList,
    );
  }

  int start = 0;

  @override
  void initState() {
    callApiFollowing();
    super.initState();
  }

  void callApiFollowing() {
    ApiService().getPostList(start.toString(), ConstRes.count.toString(), SessionManager.userId.toString(), ConstRes.following).then((value) {
      if (value.data != null && value.data!.isNotEmpty) {
        if (mList.isEmpty) {
          mList = List<Widget>.generate(value.data!.length, (index) {
            return ItemVideo(value.data![index]);
          });
          setState(() {});
        } else {
          for (Data data in value.data!) {
            mList.add(ItemVideo(data));
          }
        }
        start += ConstRes.count;
        print(mList.length);
      }
    });
  }


  @override
  bool get wantKeepAlive => true;
}
