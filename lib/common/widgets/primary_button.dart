// ignore_for_file: avoid_multiple_declarations_per_line

import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:tupay/core/core.dart';
import 'package:tupay/core/extensions/other_extensions.dart';

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    required this.title,
    this.onPressed,
    this.busy = false,
    this.disabled = false,
    this.isSmall = false,
    this.color = AppColors.secondaryColor,
    this.textColor = AppColors.white,
    this.enabled = true,
    this.outline = false,
    this.icon,
    this.borderRadius = 8,
    this.loaderColor = AppColors.white,
    this.height,
    this.buttonKey,
    this.width,
    super.key,
  });

  final bool busy;
  final String title;
  final VoidCallback? onPressed;
  final bool enabled, outline;
  final bool disabled;
  final Color color, textColor;
  final bool isSmall;
  final Widget? icon;
  final double borderRadius;
  final Color loaderColor;
  final double? height;
  final Key? buttonKey;
  final double? width;

  @override
  // ignore: library_private_types_in_public_api
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textColor = widget.disabled
        ? AppColors.black
        : widget.outline
            ? AppColors.primaryColor
            : widget.textColor;
    final buttonTheme = textTheme.labelLarge?.copyWith(
      color: textColor,
      fontSize: 14,
      fontWeight: FontWeight.w700,
    );
    final smallButtonTheme = textTheme.smallButton?.copyWith(
      color: textColor,
    );
    final height = widget.height ?? (widget.isSmall ? 36 : 50);
    return TouchableOpacity(
      buttonKey: widget.buttonKey,
      onTap: (widget.busy == false) && (widget.disabled == false) ? widget.onPressed : null,
      child: AnimatedContainer(
        height: height,
        width: widget.width,
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        constraints: BoxConstraints(
          maxHeight: height,
          maxWidth: widget.width ?? UiHelper(context).screenSize.width,
        ),
        decoration: BoxDecoration(
          color: widget.outline
              ? AppColors.white
              : widget.disabled
                  ? AppColors.primaryColor
                  : widget.onPressed == null
                      ? AppColors.primaryColor.withValues(alpha: 0.5)
                      : widget.color,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: widget.outline
                ? widget.disabled
                    ? AppColors.textColor
                    : widget.onPressed == null
                        ? AppColors.primaryColor.withValues(alpha: 0.3)
                        : widget.color
                : Colors.transparent,
          ),
        ),
        child: !widget.busy
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: widget.isSmall ? MainAxisSize.min : MainAxisSize.max,
                children: [

                  SizedBox(
                    height: min(height * 0.5, 24),
                    child: Align(
                      child: AutoSizeText(
                        widget.title,
                        minFontSize: 9,
                        style: widget.isSmall ? smallButtonTheme : buttonTheme,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  if (widget.icon != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [ context.uiHelper.horizontalSpace(8), widget.icon!,],
                    ),
                ],
              )
            : ThirdPartyLoader(
                color: widget.loaderColor,
              ),
      ),
    );
  }
}
