
import 'package:dondi/model/country_state_data.dart';
import 'package:flutter/material.dart';

import '../../utils/const.dart';

class ItemVideoCat extends StatelessWidget {
  final CountryState data;
  final Function onClick;

  ItemVideoCat(this.data, this.onClick);

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

            Text(
              data.name!,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
