
import 'package:dondi/pages/profile/item_country_cat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/api_service.dart';
import '../../utils/const.dart';
import 'item_profile_cat.dart';

class DialogCountryCategory extends StatefulWidget {
  final Function function;

  DialogCountryCategory(this.function);

  @override
  _DialogProfileCategoryState createState() => _DialogProfileCategoryState();
}

class _DialogProfileCategoryState extends State<DialogCountryCategory> {
  List<ItemCountryCat> mList = [];
  bool loading=false;
  @override
  void initState() {
    getProfileCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        color: colorPrimary,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Container(
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                color: colorPrimaryDark,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      'Choose Country',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            loading==true?const Expanded(child: Center(child: CircularProgressIndicator(),)):Expanded(
              child: GridView(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 0.65,
                ),
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                children: mList,
              ),
            ),
          ],
        ),
      ),
    );
  }



  void getProfileCategory() {
    loading=true;
    setState(() {

    });
    ApiService().getCountryList().then((value) {
      mList = List.generate(
        value.data!.length,
        (index) => ItemCountryCat(
          value.data![index],
          (data) {
            widget.function(data);
          },
        ),
      );
      loading=false;
      setState(() {});
    });
  }
}
