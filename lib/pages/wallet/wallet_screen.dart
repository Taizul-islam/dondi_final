
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../api/api_service.dart';
import '../../model/my_wallet.dart';
import '../../utils/assert_image.dart';
import '../../utils/const.dart';
import '../../utils/session_manager.dart';
import '../../widget/custom_text.dart';
import '../redeem/redeem_screen.dart';
import 'dialog_coins_plan.dart';
import 'item_rewarding_action.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String? coinRate = '0';

  // List<RewardingActionData>? rewardingActions = [];
  MyWalletData? _myWalletData;

  @override
  void initState() {
    // getCoinRate();
    // getRewardingActions();
    getMyWalletData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              SizedBox(
                height: 55,
                child: Stack(
                  children: [
                    InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.chevron_left_rounded,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 55,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(textAlign: TextAlign.center, fontSize: 18, fontWeight: FontWeight.w500, text: "Wallet", color: Colors.white,),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SectionWidget(data: _myWalletData != null ? NumberFormatter.formatter(_myWalletData!.totalReceived.toString(),) : '0', title: "Total Earning"),

                        Divider(
                          color: Color(0xFF15161A),
                        ),
                        SectionWidget(data:  _myWalletData != null ? _myWalletData!.totalSend.toString() : '0', title: "Total Spending"),

                        Divider(
                          color: Color(0xFF15161A),
                        ),
                        SectionWidget(data:  _myWalletData != null ? NumberFormatter.formatter(_myWalletData!.uploadVideo.toString(),)  : '0', title: "Total Upload Video"),

                        Divider(
                          color: Color(0xFF15161A),
                        ),
                        SectionWidget(data:  _myWalletData != null ? NumberFormatter.formatter(_myWalletData!.fromFans.toString(),)  : '0', title: "From your Fans"),

                        Divider(
                          color: Color(0xFF15161A),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            color: Color(0xFF15161A)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(_myWalletData != null ? NumberFormatter.formatter(_myWalletData!.purchased.toString()) : '0',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 15),
                                child:CustomText(textAlign: TextAlign.center, fontSize: 16, fontWeight: FontWeight.w500, text: "Purchased", color: Colors.white,),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        CustomText(textAlign: TextAlign.center, fontSize: 16, fontWeight: FontWeight.w500, text: "Purchased Points", color: Colors.white,),

                        SizedBox(height: 15,),

                        TextFormField(
                          decoration: InputDecoration(
                            fillColor: Color(0xFF15161A),
                            filled: true,
                            border: InputBorder.none,
                            hintText: "Amount",
                            hintStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,color: Color(0xFF5A5A5A))
                          ),
                        ),
                        SizedBox(height: 20,),

                        ElevatedButton(onPressed: (){


                        },style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.maxFinite, 48),
                            backgroundColor: const Color(0xFFD0463B),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                                side: BorderSide(color: Colors.black.withOpacity(0.15))

                            )
                        ), child: const CustomText(textAlign: TextAlign.center, fontSize: 16, fontWeight: FontWeight.w500, text: 'Update', color: Colors.white,


                        ),),




                        SizedBox(height: 40),
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: CustomText(textAlign: TextAlign.center, fontSize: 16, fontWeight: FontWeight.w500, text: "Rewarding Actions", color: Colors.white,),
                        ),
                        ItemRewardingAction(),
                        SizedBox(height: 10,),
                        InkWell(
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          onTap: () {
                            if (_myWalletData!.myWallet! <= int.parse(SettingRes.minRedeemCoins!)) {
                              Fluttertoast.showToast(
                                msg: 'Insufficient redeem points',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                fontSize: 16.0,
                              );
                            } else {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => RedeemScreen()),).then((value) {
                                getMyWalletData();
                              });
                            }
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                color: Color(0xFFFF5722),
                              ),
                            ),
                            child: Center(
                              child: CustomText(textAlign: TextAlign.center, fontSize: 16, fontWeight: FontWeight.w500, text: "Request Redeem", color: Color(0xFFFF5722),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void getMyWalletData() {
    ApiService().getMyWalletCoin().then((value) {
      _myWalletData = value.data;
      setState(() {});
    });
  }
}
class SectionWidget extends StatelessWidget {
  final String title;
  final String data;
  const SectionWidget({Key? key,required this.data,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(textAlign: TextAlign.center, fontSize: 14, fontWeight: FontWeight.w500, text: title, color: Color(0xFF5A5A5A),),
        const SizedBox(height: 5,),
        CustomText(textAlign: TextAlign.center, fontSize: 16, fontWeight: FontWeight.w500, text: data, color: Colors.white,),
      ],
    );
  }
}

