
import 'package:dondi/ads.dart';
import 'package:dondi/pages/splash/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  // var list=['DE992FA119FEA50941F99886890F7195'];
  // RequestConfiguration configuration =
  // RequestConfiguration(testDeviceIds: list);
  // MobileAds.instance.updateRequestConfiguration(configuration);
  await Firebase.initializeApp();
  await FlutterDownloader.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context,widget){
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: widget!,
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'DONDI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true
      ),
      home:  const SplashPage(),
    );
  }
}

