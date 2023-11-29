
import 'package:flutter/material.dart';

import '../../../utils/const.dart';

class BottomDeleteBar extends StatelessWidget {
  final List<String> timeStamp;
  final VoidCallback deleteBtnClick;
  final VoidCallback cancelBtnClick;

  const BottomDeleteBar(
      {Key? key,
      required this.timeStamp,
      required this.deleteBtnClick,
      required this.cancelBtnClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(30)),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                cancelBtnClick();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    fontSize: 15,
                    color: colorTheme,),
              ),
            ),
            const Spacer(),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(
                '${timeStamp.length} ',
                key: ValueKey<int>(timeStamp.length),
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
            const Text(
              'Selected',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                deleteBtnClick();
              },
              child: const Icon(
                Icons.delete,
                color: colorPink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
