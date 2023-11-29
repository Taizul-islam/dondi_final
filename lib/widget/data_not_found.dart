
import 'package:flutter/material.dart';

import '../utils/assert_image.dart';

class DataNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 55,
              child: Opacity(
                opacity: 0.5,
                child: Image(
                  image: AssetImage("assets/images/logo.png"),

                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Data Not Found...!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.5)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
