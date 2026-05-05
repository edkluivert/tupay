import 'package:flutter/material.dart';


class ClickableWidget extends StatelessWidget {
  const ClickableWidget({
    required this.onTap,
    required this.child,
    super.key,
    this.backgroundColor = Colors.white,
    this.borderRadius = 0,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.splashColor,
    this.highlightColor,
    this.border,
    this.boxShadow,
  });

  final Widget child;
  final GestureTapCallback? onTap;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? splashColor;
  final Color? highlightColor;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: boxShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: radius,
            border: border,
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: radius,
            splashColor: splashColor ?? Colors.grey.withValues(alpha: 0.18),
            highlightColor:
            highlightColor ?? Colors.grey.withValues(alpha: 0.08),
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
