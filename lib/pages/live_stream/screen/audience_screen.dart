
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../model/live_stream.dart';
import '../model/broad_cast_screen_view_model.dart';
import '../widget/audience_top_bar.dart';
import '../widget/live_stream_bottom_filed.dart';
import '../widget/live_stream_chat_list.dart';

class AudienceScreen extends StatelessWidget {
  final String? agoraToken;
  final String? channelName;
  final LiveStreamUser user;

  const AudienceScreen({
    Key? key,
    this.agoraToken,
    this.channelName,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BroadCastScreenViewModel>.reactive(
      onModelReady: (model) {
        model.init(
            isBroadCast: false,
            agoraToken: agoraToken ?? '',
            channelName: channelName ?? '',
            context: context);
      },
      viewModelBuilder: () => BroadCastScreenViewModel(),
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async {
            model.audienceExit(context);
            return false;
          },
          child: Scaffold(
            body: Stack(
              children: [
                model.videoPanel(context),
                SafeArea(
                  child: Column(
                    children: [
                      AudienceTopBar(model: model, user: user),
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
        );
      },
    );
  }
}
