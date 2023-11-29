
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../api/api_service.dart';
import '../../utils/const.dart';
import '../../widget/dialog/loader_dialog.dart';
import '../webview/webview_screen.dart';

class ReportScreen extends StatefulWidget {
  final int reportType;
  final String? id;

  ReportScreen(this.reportType, this.id);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String? currentValue = 'Select';
  String reason = '';
  String description = '';
  String contactInfo = '';
  final titleColor=const Color(0xFF5A5A5A);
  @override
  void initState() {
    print('id :- ${widget.id} or ${widget.reportType}');
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
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(height: 60),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Text(
                          'Report ${widget.reportType == 1 ? 'Post' : 'User'}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            child: Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select reason',
                          style:
                              TextStyle(fontSize: 15,color: titleColor),

                        ),
                        Container(
                          width: double.infinity,
                          height: 55,
                          margin: EdgeInsets.only(top: 5, bottom: 20),
                          padding: EdgeInsets.only(right: 15, left: 15, top: 2),
                          decoration: BoxDecoration(
                            color: Color(0xFF15161A),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: DropdownButton<String>(
                            value: currentValue,
                            underline: Container(),
                            isExpanded: true,
                            elevation: 16,
                            style: TextStyle(color: colorTextLight),
                            dropdownColor: colorPrimary,
                            onChanged: (String? newValue) {
                              currentValue = newValue;
                              setState(() {});
                            },
                            items: <String>[
                              'Select',
                              'Sexual',
                              'Nudity',
                              'Religion',
                              'Other'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Text(
                          'How it hurts you',
                          style: TextStyle(

                            fontSize: 15,
                            color: titleColor
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 150,
                          margin: EdgeInsets.only(top: 5, bottom: 20),
                          padding: EdgeInsets.only(right: 15, left: 15, top: 2),
                          decoration: BoxDecoration(
                            color: Color(0xFF15161A),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              hintText: 'Explain briefly',
                              hintStyle: TextStyle(
                                color: colorTextLight,
                              ),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                                color: Colors.white, ),
                            onChanged: (value) {
                              description = value;
                            },
                            maxLines: 7,
                            scrollPhysics: BouncingScrollPhysics(),
                          ),
                        ),
                        Text(
                          'Contact detail (Mail or Mobile)',
                          style:
                              TextStyle(fontSize: 15, color: titleColor),
                        ),
                        Container(
                          width: double.infinity,
                          height: 55,
                          margin: EdgeInsets.only(top: 5, bottom: 20),
                          padding: EdgeInsets.only(right: 15, left: 15, top: 2),
                          decoration: BoxDecoration(
                            color: Color(0xFF15161A),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              hintText: 'Mail or phone',
                              hintStyle: TextStyle(
                                color: colorTextLight,
                              ),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              contactInfo = value;
                            },
                            style: TextStyle(
                                color: Colors.white, ),
                            maxLines: 1,
                            scrollPhysics: BouncingScrollPhysics(),
                          ),
                        ),
                        Center(
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 15),
                            child: ElevatedButton(
                              onPressed: () {
                                if (currentValue == null ||
                                    currentValue!.isEmpty ||
                                    currentValue == 'Select') {
                                  showToast('Please select reason');
                                  return;
                                }
                                if (description.isEmpty) {
                                  showToast('Please enter description');
                                  return;
                                }
                                if (contactInfo.isEmpty) {
                                  showToast('Please enter contact detail');
                                  return;
                                }
                                showDialog(
                                  context: context,
                                  builder: (context) => LoaderDialog(),
                                );
                                ApiService()
                                    .reportUserOrPost(
                                  widget.reportType == 1 ? "2" : "1",
                                  widget.id,
                                  currentValue,
                                  description,
                                  contactInfo,
                                )
                                    .then((value) {
                                  print(value.status);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Color(0xFFD0463B)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              child: Text(
                                'Submit'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Text(
                            'By clicking this submit button,you agree that\n'
                            'you are taking all the responsibilities of all the\n'
                            'process that may be done by us or the content\n'
                            'uploader. Click the link below to knowmore\n'
                            'about that',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colorTextLight,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebViewScreen(3),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Policy center',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: colorPrimary,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}
