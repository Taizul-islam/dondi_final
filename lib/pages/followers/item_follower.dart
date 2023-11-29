
import 'package:flutter/material.dart';

import '../../model/follower_following_data.dart';
import '../../utils/assert_image.dart';
import '../../utils/const.dart';

class ItemFollowers extends StatelessWidget {
  final FollowerUserData user;

  ItemFollowers(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              ClipOval(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      child: Image(
                        image: AssetImage(icUserPlaceHolder),
                        color: colorLightWhite,
                      ),
                    ),
                    Container(
                      height: 45,
                      width: 45,
                      child: ClipOval(
                        child: Image.network(
                          ConstRes.itemBaseUrl + user.userProfile!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName!,
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    '@${user.userName}',
                    style: TextStyle(
                      color: colorTextLight,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            color: colorTextLight,
            height: 0.2,
          ),
        ],
      ),
    );
  }
}
