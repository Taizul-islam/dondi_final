import 'package:flutter/material.dart';

import '../utils/const.dart';

class ImageWithRoundGradient extends StatelessWidget {
  final String imageData;
  final double padding;

  const ImageWithRoundGradient(this.imageData, this.padding, {super.key});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
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
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Image(
            image: AssetImage(imageData),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
