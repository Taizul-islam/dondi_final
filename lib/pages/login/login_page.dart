
import 'dart:io';
import 'package:dondi/pages/login/login_controller.dart';
import 'package:dondi/utils/const.dart';
import 'package:dondi/utils/my_loading.dart';
import 'package:dondi/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final controller=Get.put(LoginController());
  final commonController=Get.put(MyLoading());



  @override
  Widget build(BuildContext context) {
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
                           showToast("Under construction");
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
                        controller.signInWithGoogle().then((value) {
                          print("sign_in_value: $value");
                          controller.callApiForLogin(value!, 3,commonController);
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


}
