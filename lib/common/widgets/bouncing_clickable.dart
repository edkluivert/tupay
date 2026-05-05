import 'package:flutter/material.dart';

class BouncyClickableWidget extends StatefulWidget {
  const BouncyClickableWidget({
    required this.child,
    required this.onTap,
    super.key,
    this.backgroundColor = Colors.transparent,
    this.borderRadius = 0,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.scaleFactor = 0.94,
    this.duration = const Duration(milliseconds: 120),
    this.curve = Curves.easeOutBack,
    this.border,
    this.boxShadow,
    this.width,
    this.height,
    this.alignment,
    this.enabled = true,
    this.behavior = HitTestBehavior.opaque,
  });

  final Widget child;
  final GestureTapCallback? onTap;

  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  /// How small it gets when pressed.
  /// Example: 0.94 means it shrinks to 94% of its size.
  final double scaleFactor;

  final Duration duration;
  final Curve curve;

  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;

  final bool enabled;
  final HitTestBehavior behavior;

  @override
  State<BouncyClickableWidget> createState() => _BouncyClickableWidgetState();
}

class _BouncyClickableWidgetState extends State<BouncyClickableWidget> {
  bool _isPressed = false;

  bool get _isClickable => widget.enabled && widget.onTap != null;

  void _setPressed(bool value) {
    if (!_isClickable || _isPressed == value) return;

    setState(() {
      _isPressed = value;
    });
  }

  Future<void> _handleTap() async {
    if (!_isClickable) return;

    _setPressed(true);

    await Future<void>.delayed(const Duration(milliseconds: 90));

    if (!mounted) return;

    _setPressed(false);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? widget.scaleFactor : 1,
      duration: widget.duration,
      curve: widget.curve,
      child: GestureDetector(
        behavior: widget.behavior,
        onTap: _handleTap,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        child: Container(
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          alignment: widget.alignment,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: widget.border,
            boxShadow: widget.boxShadow,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}