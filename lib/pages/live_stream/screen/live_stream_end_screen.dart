
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/assert_image.dart';
import '../../../utils/const.dart';
import '../../../utils/session_manager.dart';

class LivestreamEndScreen extends StatefulWidget {
  const LivestreamEndScreen({Key? key}) : super(key: key);

  @override
  State<LivestreamEndScreen> createState() => _LivestreamEndScreenState();
}

class _LivestreamEndScreenState extends State<LivestreamEndScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );
  SessionManager pref = SessionManager();

  String time = '';
  String watching = '';
  String diamond = '';
  String image = '';

  @override
  void initState() {
    prefData();
    super.initState();
  }

  void prefData() async {
    await pref.initPref();
    time = pref.getString(FirebaseConst.timing) ?? '';
    watching = pref.getString(FirebaseConst.watching) ?? '';
    diamond = pref.getString(FirebaseConst.collected) ?? '';
    image = pref.getString(FirebaseConst.profileImage) ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  image.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            '${ConstRes.itemBaseUrl}$image',
                            height: MediaQuery.of(context).size.width / 2.5,
                            width: MediaQuery.of(context).size.width / 2.5,
                            fit: BoxFit.cover,
                          ))
                      : Image.asset(
                          icUserPlaceHolder,
                          height: MediaQuery.of(context).size.width / 2.5,
                          width: MediaQuery.of(context).size.width / 2.5,
                          fit: BoxFit.cover,
                          color: Colors.grey,
                        ),
                  ScaleTransition(
                    scale: _animation,
                    child: const Text(
                      'Your live stream has been ended!\nBelow is a summary of it.',
                      style: TextStyle( fontSize: 18,color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          SizeTransition(
                            sizeFactor: _animation,
                            axis: Axis.horizontal,
                            axisAlignment: -1,
                            child: Text('$time',
                                style: const TextStyle(
                                     fontSize: 15,color: Colors.white)),
                          ),
                          const Text(
                            'Stream for',
                            style: TextStyle(
                                 fontSize: 15,color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizeTransition(
                            sizeFactor: _animation,
                            axis: Axis.horizontal,
                            axisAlignment: -1,
                            child: Text('$watching',
                                style: const TextStyle(
                                     fontSize: 15,color: Colors.white)),
                          ),
                          const Text(
                            'Users',
                            style: TextStyle(
                                fontSize: 15,color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizeTransition(
                            sizeFactor: _animation,
                            axis: Axis.horizontal,
                            axisAlignment: -1,
                            child: Text('$diamond',
                                style: const TextStyle(
                                    fontSize: 15,color: Colors.white)),
                          ),
                          const Text(
                            '💎 Collected',
                            style: TextStyle(
                                 fontSize: 15,color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color:  Color(0xFFFF5722).withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'OK',
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 0.8,
                                fontSize: 16,),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
