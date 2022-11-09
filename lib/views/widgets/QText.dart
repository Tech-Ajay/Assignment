import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QText extends StatelessWidget {
  const QText({
    Key? key,
    required this.text,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.fontFamily,
    this.overflow,
    this.decoration,
    this.decorationColor,
    this.decorationThickness,
    this.decorationStyle,
    this.textAlign,
    this.isHeader = false,
    this.maxLines,
  }) : super(key: key);

  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final double? wordSpacing;
  final String? fontFamily;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final double? decorationThickness;
  final TextDecorationStyle? decorationStyle;
  final TextAlign? textAlign;
  final bool isHeader;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: isHeader
          ? GoogleFonts.jetBrainsMono(
              fontSize: fontSize,
              color: color,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              letterSpacing: letterSpacing,
              wordSpacing: wordSpacing,
              decoration: decoration,
              decorationColor: decorationColor,
              decorationThickness: decorationThickness,
              decorationStyle: decorationStyle,
            )
          : GoogleFonts.raleway(
              fontSize: fontSize,
              color: color,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              letterSpacing: letterSpacing,
              wordSpacing: wordSpacing,
              decoration: decoration,
              decorationColor: decorationColor,
              decorationThickness: decorationThickness,
              decorationStyle: decorationStyle,
            ),
    );
  }
}
