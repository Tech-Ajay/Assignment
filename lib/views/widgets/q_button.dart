import 'package:flutter/material.dart';
import 'package:supertails/views/widgets/QContainer.dart';
import 'package:supertails/views/widgets/QText.dart';

class QButton extends StatelessWidget {
  const QButton({
    Key? key,
    required this.onPress,
    required this.text,
    this.padding,
    this.backgroundColor,
    this.overlayColor,
    this.borderRadius,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height,
    this.elevation,
    this.isMobile = false,
  }) : super(key: key);

  final Function()? onPress;
  final String text;
  final Color? backgroundColor;
  final Color? overlayColor;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? width;
  final double? height;
  final bool? isMobile;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return QContainer(
      width: width,
      height: height ?? (isMobile! ? 30 : 50),
      child: ElevatedButton(
        style: ButtonStyle(
          elevation:
              elevation == null ? null : MaterialStateProperty.all(elevation),
          backgroundColor:
              MaterialStateProperty.all(backgroundColor ?? Colors.redAccent),
          padding: MaterialStateProperty.all(padding),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 5),
            ),
          ),
        ),
        onPressed: onPress,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            prefixIcon ?? SizedBox(),
            if (prefixIcon != null) SizedBox(width: 10),
            QText(
              textAlign: TextAlign.center,
              text: text,
              fontSize: isMobile! ? 14 : 17,
              color: overlayColor,
              fontWeight: FontWeight.w600,
              isHeader: true,
            ),
            suffixIcon ?? SizedBox(),
            if (suffixIcon != null) SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
