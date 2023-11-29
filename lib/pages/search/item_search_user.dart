

import 'package:dondi/pages/profile/proifle_screen.dart';
import 'package:flutter/material.dart';

import '../../model/search_user.dart';
import '../../utils/assert_image.dart';
import '../../utils/const.dart';

class ItemSearchUser extends StatelessWidget {
  final SearchUserData? searchUser;

  ItemSearchUser(this.searchUser);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(1, searchUser?.userId.toString()),
        ),
      ),
      child: Container(
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
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Image(
                        image: AssetImage(icUserPlaceHolder),
                        color: colorTextLight,
                      ),
                    ),
                    Container(
                      height: 65,
                      width: 65,
                      child: ClipOval(
                        child: Image.network(
                          ConstRes.itemBaseUrl +
                              (searchUser?.userProfile == null ||
                                      searchUser!.userProfile!.isEmpty
                                  ? ''
                                  : searchUser?.userProfile ?? ''),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        searchUser?.fullName ?? '',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        '@${searchUser?.userName}',
                        style: TextStyle(
                            color: colorTextLight,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        '${searchUser?.followersCount} Fans ${searchUser?.myPostCount} Videos',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
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
      ),
    );
  }
}
