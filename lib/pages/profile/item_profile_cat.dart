
import 'package:flutter/material.dart';

import '../../model/profile_category.dart';
import '../../utils/const.dart';

class ItemProfileCat extends StatelessWidget {
  final ProfileCategoryData data;
  final Function onClick;

  ItemProfileCat(this.data, this.onClick);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        onClick.call(data);
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
            Image(
              image: NetworkImage(
                  ConstRes.itemBaseUrl + data.profileCategoryImage!),
              height: 45,
              color: colorTheme,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              data.profileCategoryName!,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
