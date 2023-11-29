
import 'package:flutter/material.dart';

import '../../../utils/const.dart';

class EndDialog extends StatelessWidget {
  final VoidCallback onYesBtnClick;

  const EndDialog({Key? key, required this.onYesBtnClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 70),
      backgroundColor: colorPrimaryDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: AspectRatio(
        aspectRatio: 1 / 0.6,
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Text(
                'Are you Sure',
                style: TextStyle( fontSize: 16,color: Colors.white),
              ),
              Spacer(),
              Text(
                'Are you sure you want to end your live video?',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              Row(
                children: [
                  Expanded(
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                end: Alignment.centerRight,
                                begin: Alignment.centerLeft,
                                colors: [
                                  Color(0xFFFF5722).withOpacity(0.2),
                                  Color(0xFFFF5722).withOpacity(0.5),
                                ],
                              ),
                            ),
                            child: Text('Cancel',style: TextStyle(color: Colors.white),),
                          )
                      )),
                  SizedBox(width: 10,),
                  Expanded(
                    child: InkWell(
                      onTap: onYesBtnClick,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            end: Alignment.centerRight,
                            begin: Alignment.centerLeft,
                            colors: [
                              Color(0xFFFF5722),
                              Color(0xFFFF5722).withOpacity(0.5),
                            ],
                          ),
                        ),
                        child: Text('Yes',style: TextStyle(color: Colors.white),),
                      ),
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
}
