import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:dondi/utils/my_loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../api/api_service.dart';
import '../../utils/const.dart';
import '../../utils/session_manager.dart';
import '../../widget/custom_text.dart';
import '../../widget/dialog/loader_dialog.dart';
import 'login_controller.dart';


class DialogLogin extends StatelessWidget {
  final SessionManager sessionManager = SessionManager();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
    '349494632051-9dr0qqb5j5sejjimf7jjbggvfl3uka2c.apps.googleusercontent.com',
    scopes: <String>[
      'email',
    ],
  );
  final controller=Get.put(LoginController());
  final commonController=Get.put(MyLoading());
  @override
  Widget build(BuildContext context) {
    int _type = 0;
    initData();
    var query=MediaQuery.of(context);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Platform.isAndroid?Brightness.light:Brightness.dark,
        statusBarIconBrightness: Platform.isAndroid?Brightness.light:Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding:  EdgeInsets.only(left: 20,right: 20,top: query.viewPadding.top+50,bottom: query.viewPadding.bottom+20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               Expanded(flex:2,child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    CustomText(textAlign: TextAlign.center, fontSize: 18, fontWeight: FontWeight.w700, text: "Sign Up for Goxati", color: Colors.white,),
                    SizedBox(height: 10,),
                    CustomText(textAlign: TextAlign.center, fontSize: 16, fontWeight: FontWeight.w400, text: "Start Your Journey Now!", color: Colors.white,)

                  ],
                ),
              )),
              Expanded(flex:10,child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: (){
                      signInWithFacebook().then((value) {
                        _type = 1;
                        callApiForLogin(value.user!, _type, context);
                      });
                    },style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.maxFinite, 48),
                        backgroundColor: const Color(0xFF3C66C4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: BorderSide(color: Colors.black.withOpacity(0.15))

                        )
                    ), child: const CustomText(textAlign: TextAlign.center, fontSize: 16, fontWeight: FontWeight.w500, text: 'Sign in with Facebook', color: Colors.white,


                    ),),
                    const SizedBox(height: 16,),
                    ElevatedButton(onPressed: (){
                      signInWithGoogle().then((value) {
                        print("sign_in_value: $value");
                        callApiForLogin(value!, 3,context);
                      });

                    },style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.maxFinite, 48),
                        backgroundColor: const Color(0xFFD0463B),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: BorderSide(color: Colors.black.withOpacity(0.15))

                        )
                    ), child: const CustomText(textAlign: TextAlign.center, fontSize: 16, fontWeight: FontWeight.w500, text: 'Sign in with Google', color: Colors.white,


                    ),),
                  ],
                ),
              )),
               Expanded(flex:2,child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    CustomText(textAlign: TextAlign.center, fontSize: 16, fontWeight: FontWeight.w400, text: "I agree to terms of use and confirm that you have read our privacy policy", color: Colors.white,)

                  ],
                ),
              )),
              Expanded(flex:2,child: SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(onPressed: (){}, child: Text("Terms and condition",style: GoogleFonts.poppins(textStyle: TextStyle(color: const Color(0xFF3C66C4),fontWeight: FontWeight.w400,fontSize: 14)),)),
                    const SizedBox(width: 10,),
                    TextButton(onPressed: (){}, child: Text("Privacy Policy",style: GoogleFonts.poppins(textStyle: TextStyle(color: const Color(0xFF3C66C4),fontWeight: FontWeight.w400,fontSize: 14)),)),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount = await (googleSignIn.signIn());
    final GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount?.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );
    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User? user = authResult.user;
    log("check_user: $user");
    return user;
  }

  // Future<User?> signInWithApple({List<Scope> scopes = const []}) async {
  //   // 1. perform the sign-in request
  //   final result = await TheAppleSignIn.performRequests([AppleIdRequest(requestedScopes: scopes)]);
  //   // 2. check the result
  //   switch (result.status) {
  //     case AuthorizationStatus.authorized:
  //       final appleIdCredential = result.credential!;
  //       final oAuthProvider = OAuthProvider('apple.com');
  //       final credential = oAuthProvider.credential(
  //         idToken: String.fromCharCodes(appleIdCredential.identityToken!),
  //         accessToken: String.fromCharCodes(appleIdCredential.authorizationCode!),
  //       );
  //       final userCredential = await _auth.signInWithCredential(credential);
  //       final firebaseUser = userCredential.user;
  //       if (scopes.contains(Scope.fullName)) {
  //         final fullName = appleIdCredential.fullName;
  //         if (fullName != null && fullName.givenName != null && fullName.familyName != null) {
  //           final displayName = '${fullName.givenName} ${fullName.familyName}';
  //           await firebaseUser!.updateDisplayName(displayName);
  //         }
  //       }
  //       return firebaseUser;
  //     case AuthorizationStatus.error:
  //       throw PlatformException(
  //         code: 'ERROR_AUTHORIZATION_DENIED',
  //         message: result.error.toString(),
  //       );
  //     case AuthorizationStatus.cancelled:
  //       throw PlatformException(
  //         code: 'ERROR_ABORTED_BY_USER',
  //         message: 'Sign in aborted by user',
  //       );
  //     default:
  //       throw UnimplementedError();
  //   }
  // }
  //
  Future<UserCredential> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login(permissions: ['public_profile','email',"user_friends"]);


    final FacebookAuthCredential facebookAuthCredential= FacebookAuthProvider.credential(result.accessToken!.token) as FacebookAuthCredential;
    log("facebook_credential: $facebookAuthCredential");
    return await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  void callApiForLogin(User value, int type, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => LoaderDialog(),
    );
    final controller=Get.put(MyLoading());
    HashMap<String, String?> params = new HashMap();
    params[ConstRes.deviceToken] = sessionManager.getString(ConstRes.deviceToken);
    params[ConstRes.userEmail] = value.email ?? value.displayName!.split('@')[value.displayName!.split('@').length - 1] + '@fb.com';
    params[ConstRes.fullName] = value.displayName;
    params[ConstRes.loginType] = type == 0 ? 'apple' : (type == 1 ? 'facebook' : 'google');
    params[ConstRes.userName] = value.email != null ? value.email!.split('@')[0] : value.uid;
    params[ConstRes.identity] = value.email ?? value.uid;
    params[ConstRes.platform] = Platform.isAndroid ? "1" : "2";
    print("google_sign_in_params: $params");
    ApiService().registerUser(params).then((value) async{
      await sessionManager.initPref();
      if(value.data!.c_lat!.isNotEmpty){
        sessionManager.saveBoolean(LOCATIONUPDATED, true);
      }
      controller.setSelectedItem(0);
      controller.setUser(value);
      Navigator.pop(context,true);
      Navigator.pop(context,true);
    });
  }

  void initData() async {
    await sessionManager.initPref();
  }
}
