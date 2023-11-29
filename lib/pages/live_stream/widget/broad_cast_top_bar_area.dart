
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/assert_image.dart';
import '../../../utils/const.dart';
import '../model/broad_cast_screen_view_model.dart';
import 'blur_tab.dart';

class BroadCastTopBarArea extends StatelessWidget {
  final BroadCastScreenViewModel model;

  const BroadCastTopBarArea({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlurTab(
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Image.asset(
                "assets/images/logo.png",
                height: 25,
                width: 40,
              ),
              SizedBox(
                width: 7,
              ),
              Text(
                'Live',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17),
              ),
              Spacer(
                flex: 2,
              ),
              Text(
                "${NumberFormat.compact(locale: 'en').format(double.parse('${model.liveStreamUser?.watchingCount ?? '0'}'))} Viewers",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  model.onEndButtonClick(context);
                },
                child: Container(
                  width: 110,
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: Color(0xFFFF5722),
                      borderRadius: BorderRadius.circular(30)),
                  alignment: Alignment.center,
                  child: Text(
                    'END',
                    style: TextStyle(
                        color: Colors.white,),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        BlurTab(
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Image.asset(
                "assets/images/logo.png",
                height: 25,
                width: 40,
              ),
              SizedBox(
                width: 5,
              ),
              Spacer(),
              Text(
                  "${NumberFormat.compact(locale: 'en').format(double.parse('${model.liveStreamUser?.collectedDiamond ?? '0'}'))} Collected",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
              Spacer(),
              InkWell(
                onTap: model.flipCamera,
                child: Container(
                  padding: EdgeInsets.all(11),
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFFFF5722),
                          Color(0xFFFF5722).withOpacity(0.5),]),
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(flipCamera, color: Colors.white),
                ),
              ),
              InkWell(
                onTap: model.onMuteUnMute,
                child: Container(
                  padding: EdgeInsets.all(11),
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFFFF5722),
                          Color(0xFFFF5722).withOpacity(0.5),]),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                    !model.isMic ? biMicFill : biMicMute,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
