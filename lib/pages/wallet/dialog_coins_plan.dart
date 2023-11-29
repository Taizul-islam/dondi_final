
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../api/api_service.dart';
import '../../model/plan/coin_plans.dart';
import '../../utils/assert_image.dart';
import '../../utils/const.dart';
import 'item_coin_plan.dart';

class DialogCoinsPlan extends StatefulWidget {
  @override
  State<DialogCoinsPlan> createState() => _DialogCoinsPlanState();
}

class _DialogCoinsPlanState extends State<DialogCoinsPlan> {
  List<CoinPlanData>? plans = [];
  int coinAmount = 0;

  @override
  void initState() {
    ApiService().getCoinPlanList().then((value) {
      plans = value.data;
      setState(() {});
    });
    MethodChannel(ConstRes.bubblyCamera).setMethodCallHandler((payload) async {
      print(payload.arguments);
      if (payload.method == 'is_success_purchase' &&
          (payload.arguments as bool)) {
        print(coinAmount);
        ApiService().purchaseCoin(coinAmount.toString()).then(
          (value) {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      } else {
        Navigator.pop(context);
      }
      return;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      decoration: BoxDecoration(
        color: colorPrimaryDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            height: 55,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorTheme,
                    colorPink,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(icStore),
                  color: Colors.white,
                  height: 24,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Shop',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(top: 20, bottom: 25),
              children: List.generate(
                plans!.length,
                (index) => ItemCoinPlan(
                  plans![index],
                  (coinAmount) {
                    this.coinAmount = coinAmount;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
