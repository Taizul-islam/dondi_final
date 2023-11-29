import 'dart:developer';
import 'dart:io';

import 'package:dondi/pages/bottom_navigation/main_screen.dart';
import 'package:dondi/utils/my_loading.dart';
import 'package:firebase_auth/firebase_auth.dart' as T;
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../api/api_service.dart';
import '../../utils/const.dart';
import '../../utils/session_manager.dart';

class LoginController extends GetxController{
  final T.FirebaseAuth _auth = T.FirebaseAuth.instance;
  final SessionManager sessionManager = SessionManager();
  var device="";
  @override
  void onInit() async{
    await sessionManager.initPref();
    device=sessionManager.getString(ConstRes.deviceToken)!;
    super.onInit();
  }
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
    '536883824633-1s3s5fi4pstfjt5setcjhbrdq6vtr37h.apps.googleusercontent.com',
    scopes: <String>[
      'email',
    ],
  );


  Future<T.User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount = await (googleSignIn.signIn());
    final GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount?.authentication;
    final T.AuthCredential credential = T.GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );
    final T.UserCredential authResult = await _auth.signInWithCredential(credential);
    final T.User? user = authResult.user;
    log("check_user: $user");
    return user;
  }
  void callApiForLogin(T.User value, int type,MyLoading myLoading) {
    Map<String, String?> params = {};
    params[ConstRes.deviceToken] = device;
    params[ConstRes.userEmail] = value.email ?? value.displayName!.split('@')[value.displayName!.split('@').length - 1] + '@fb.com';
    params[ConstRes.fullName] = value.displayName;
    params[ConstRes.loginType] = type == 0 ? 'apple' : (type == 1 ? 'facebook' : 'google');
    params[ConstRes.userName] = value.email != null ? value.email!.split('@')[0] : value.uid;
    params[ConstRes.identity] = value.email ?? value.uid;
    params[ConstRes.platform] = Platform.isAndroid ? "1" : "2";
    print("google_sign_in_params: $params");
    showLoader();
    ApiService().registerUser(params).then((value) {
      myLoading.setSelectedItem(0);
      myLoading.setUser(value);
      Get.back();
      Get.off(()=> MainScreen(),transition: Transition.rightToLeft);
    });
  }

}