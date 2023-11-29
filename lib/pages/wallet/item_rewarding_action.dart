
import 'package:flutter/material.dart';

import '../../utils/const.dart';
import '../../widget/custom_text.dart';

class ItemRewardingAction extends StatelessWidget {
  const ItemRewardingAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
          color: Color(0xFF15161A),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Row(
        children: [

          Container(
            height: 55,
            width: 55,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Color(0xFFD0463B)
            ),
            child: CustomText(textAlign: TextAlign.center, fontSize: 16, fontWeight: FontWeight.w500, text: "${SettingRes.rewardVideoUpload}", color: Colors.white,),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(child: CustomText(textAlign: TextAlign.center, fontSize: 16, fontWeight: FontWeight.w500, text: "Whenever you upload video", color: Colors.white,)),

        ],
      ),
    );
  }
}
