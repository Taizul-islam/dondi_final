import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../utils/assert_image.dart';
import '../../../utils/const.dart';
import '../model/broad_cast_screen_view_model.dart';

class LiveStreamBottomField extends StatelessWidget {
  final BroadCastScreenViewModel model;

  const LiveStreamBottomField({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 45,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.33),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.done,
                            minLines: 1,
                            maxLines: 5,
                            controller: model.commentController,
                            focusNode: model.commentFocus,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: 'Comment...',
                              contentPadding: const EdgeInsets.only(
                                  left: 15, bottom: 14, right: 1),
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.70),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: model.onComment,
                          child: Container(
                            margin: EdgeInsets.all(2),
                            padding: EdgeInsets.all(12),
                            decoration:  BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFFFF5722),
                                  Color(0xFFFF5722).withOpacity(0.5),
                                ],
                              ),
                            ),
                            child: Image.asset(send),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !model.isHost,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () => model.onGiftTap(context),
                child: Container(
                  height: 45,
                  width: 45,
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colorPink,
                        colorTheme,
                      ],
                    ),
                  ),
                  child: Image.asset(gift),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
