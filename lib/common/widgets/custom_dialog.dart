import 'package:flutter/material.dart';
import 'package:tupay/core/constants/app_colors.dart';
import 'package:tupay/core/utils/ui_helper.dart';

class CustomDialog extends StatefulWidget {
  const CustomDialog({
    required this.child,
    super.key,
  });
  final Widget child;

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    final uiHelper = UiHelper(context);
    return Center(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        child: Container(
          margin: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            40,
          ),
          width: uiHelper.screenSize.width - 20,
          decoration: const BoxDecoration(
            color: AppColors.white,
          ),
          child: IntrinsicWidth(
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
