import 'package:flutter/material.dart';

import '../utils/const.dart';

class IconWithRoundGradient1 extends StatelessWidget {
  final IconData iconData;
  final double size;
  final Function? onTap;

  const IconWithRoundGradient1(
      {super.key, required this.iconData, required this.size, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: InkWell(
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        onTap: () {
          onTap?.call();
        },
        child: Container(
          height: 38,
          width: 38,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorTheme,
                colorPink,
              ],
            ),
          ),
          child: Icon(
            iconData,
            color: Colors.white,
            size: size,
          ),
        ),
      ),
    );
  }
}
