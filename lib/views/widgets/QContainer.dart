import 'package:flutter/material.dart';

class QContainer extends StatelessWidget {
  const QContainer({
    Key? key,
    this.color,
    this.width,
    this.height,
    this.child,
    this.borderRadius,
    this.alignment,
    this.padding,
    this.margin,
    this.shadowOffset,
    this.elevation,
    this.shadowColor,
    this.isResponsive = true,
    this.isAnimated = false,
    this.shape = BoxShape.rectangle,
    this.border,
  }) : super(key: key);

  final Color? color;
  final double? width;
  final double? height;
  final Widget? child;
  final BorderRadius? borderRadius;
  final Alignment? alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Offset? shadowOffset;
  final Color? shadowColor;
  final double? elevation;
  final bool isResponsive;
  final BoxShape shape;
  final bool isAnimated;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    if (isAnimated) {
      return AnimatedContainer(
        duration: Duration(milliseconds: 400),
        width: isResponsive ? width : width,
        height: isResponsive ? height : height,
        padding: padding,
        margin: margin,
        alignment: alignment,
        decoration: BoxDecoration(
            color: color,
            border: border,
            borderRadius: borderRadius,
            shape: shape,
            boxShadow: [
              if (elevation != null)
                BoxShadow(
                  color: shadowColor ?? Colors.grey.shade400,
                  offset: shadowOffset ?? Offset.zero,
                  blurRadius: 2,
                )
            ]),
        child: child,
      );
    } else {
      return Container(
        width: isResponsive ? width : width,
        height: isResponsive ? height : height,
        padding: padding,
        margin: margin,
        alignment: alignment,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          border: border,
          shape: shape,
          boxShadow: [
            if (elevation != null)
              BoxShadow(
                color: shadowColor ?? Colors.grey.shade400,
                offset: shadowOffset ?? Offset.zero,
                blurRadius: 2,
              )
          ],
        ),
        child: child,
      );
    }
  }
}
