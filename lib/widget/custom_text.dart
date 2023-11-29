import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final double fontSize;
  final TextAlign textAlign;
  final Color color;
  const CustomText({Key? key,required this.textAlign,required this.fontSize,required this.fontWeight,required this.text,
  required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: fontSize,fontWeight: fontWeight,color: color)),textAlign: textAlign,);
  }
}
