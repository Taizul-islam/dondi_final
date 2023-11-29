
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:stacked/stacked.dart';

import '../../../model/live_stream.dart';
import '../../../utils/assert_image.dart';
import '../../../utils/const.dart';
import '../model/live_stream_view_model.dart';


class LiveStreamScreen extends StatelessWidget {
  const LiveStreamScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LiveStreamScreenViewModel>.reactive(
      onViewModelReady: (model) {
        return model.init();
      },
      viewModelBuilder: () => LiveStreamScreenViewModel(),
      builder: (context, model, child) {
        return AnnotatedRegion(
          value: SystemUiOverlayStyle(
              statusBarIconBrightness: Platform.isAndroid?Brightness.light:Brightness.dark,
              statusBarBrightness: Platform.isAndroid?Brightness.light:Brightness.dark,
              statusBarColor: Colors.black
          ),
          child: Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.only(top: 10, bottom: 2),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.black,
                              size: 18,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Dondi ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                ),
                            children: <TextSpan>[
                              TextSpan(
                                text: ' LIVE',
                                style: TextStyle(

                                    color: Color(0xFFFF5722),
                                    fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            if (model.registrationUser!.data!.followersCount! >= int.parse("0")) {
                              model.goLiveTap(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Minimum ${SettingRes.minFansForLive} fans required to start livestream!'),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFFFF5722),
                                    Color(0xFFFF5722).withOpacity(0.5),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30)),
                            child: Row(
                              children: [
                                Image.asset(
                                  goLive,
                                  width: 20,
                                  height: 20,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Go Live',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomGridView(
                    model: model,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (model.bannerAd != null)
                    Container(
                      alignment: Alignment.center,
                      child: AdWidget(ad: model.bannerAd!),
                      width: model.bannerAd?.size.width.toDouble(),
                      height: model.bannerAd?.size.height.toDouble(),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomGridView extends StatelessWidget {
  final LiveStreamScreenViewModel model;

  const CustomGridView({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: model.liveUsers.isEmpty
          ? Center(
              child: Text(
                "No User Live",
                style: TextStyle(fontSize: 18,color: Colors.white.withOpacity(0.5) ),
              ),
            )
          : SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: model.liveUsers.map<Widget>(
                      (e) {
                        int index = model.liveUsers.indexOf(e);
                        return index % 2 == 0
                            ? gridTile(
                                data: e,
                                width: (MediaQuery.of(context).size.width / 2) -
                                    18,
                                height: index % 4 == 0
                                    ? (MediaQuery.of(context).size.width * 0.65)
                                    : (MediaQuery.of(context).size.width *
                                        0.49),
                                margin:
                                    const EdgeInsets.fromLTRB(12, 0, 12, 12),
                                context: context)
                            : const SizedBox();
                      },
                    ).toList(),
                  ),
                  Column(
                    children: model.liveUsers.map<Widget>(
                      (e) {
                        int index = model.liveUsers.indexOf(e);
                        return index % 2 == 1
                            ? gridTile(
                                data: e,
                                width: (MediaQuery.of(context).size.width / 2) -
                                    18,
                                height: (index + 1) % 4 == 0
                                    ? (MediaQuery.of(context).size.width * 0.65)
                                    : (MediaQuery.of(context).size.width *
                                        0.49),
                                margin: const EdgeInsets.fromLTRB(0, 0, 12, 12),
                                context: context)
                            : const SizedBox();
                      },
                    ).toList(),
                  ),
                ],
              ),
            ),
    );
  }

  Widget gridTile(
      {required LiveStreamUser data,
      required double height,
      required double width,
      required EdgeInsetsGeometry margin,
      required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        model.onImageTap(context, data);
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: width,
            height: height,
            margin: margin,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(20),
              image: data.userImage == null || data.userImage!.isEmpty
                  ? DecorationImage(
                      image: AssetImage(placeholderWarning), fit: BoxFit.cover)
                  : DecorationImage(
                      image: NetworkImage(
                        '${ConstRes.itemBaseUrl}${data.userImage}',
                      ),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Container(
              width: width,
              color: colorPrimary,
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width / 40, 12, 0, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        data.fullName ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Image.asset(
                        icVerify,
                        height: 16,
                        width: 16,
                      ),
                    ],
                  ),
                  Text(
                    '${data.followers ?? 0} Followers',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        feEye,
                        width: 20,
                        height: 15,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 3.5),
                      Text(
                        '${data.watchingCount ?? 0}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
