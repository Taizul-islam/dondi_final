
import 'package:flutter/material.dart';

import '../../utils/const.dart';

class LoaderDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black54,
        child: Center(
          child: CircularProgressIndicator(
            color: colorTheme,
          ),
        ),
      ),
    );
  }
}
