
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import '../model/broad_cast_screen_view_model.dart';
import '../widget/broad_cast_top_bar_area.dart';
import '../widget/live_stream_bottom_filed.dart';
import '../widget/live_stream_chat_list.dart';

class BroadCastScreen extends StatelessWidget {
  final String? agoraToken;
  final String? channelName;

  const BroadCastScreen({
    Key? key,
    required this.agoraToken,
    required this.channelName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BroadCastScreenViewModel>.reactive(
      onViewModelReady: (model) {
        return model.init(
            isBroadCast: true,
            agoraToken: agoraToken ?? "",
            channelName: channelName ?? '',
            context: context);
      },
      viewModelBuilder: () => BroadCastScreenViewModel(),
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async {
            model.onEndButtonClick(context);
            return false;
          },
          child: AnnotatedRegion(
            value: SystemUiOverlayStyle(
                statusBarIconBrightness: Platform.isAndroid?Brightness.light:Brightness.dark,
                statusBarBrightness: Platform.isAndroid?Brightness.light:Brightness.dark,
                statusBarColor: Colors.transparent
            ),
            child: Scaffold(
              body: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: model.videoPanel(context),
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        BroadCastTopBarArea(model: model),
                        Spacer(),
                        LiveStreamChatList(
                            commentList: model.commentList, pageContext: context),
                        LiveStreamBottomField(
                          model: model,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
