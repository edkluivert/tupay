import 'package:gap/gap.dart';
import 'package:flutter/material.dart';

import 'package:tupay/common/widgets/widget.dart';

class CustomModalSheet {
  static void customModalSheet(
    BuildContext context, {
    required Widget child,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool hasNudge = true,
    EdgeInsets? padding,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ModalSheetWidget(
          hasNudge: hasNudge,
          padding: padding,
          child: child,
        );
      },
    );
  }
}

class ModalSheetWidget extends StatelessWidget {
  const ModalSheetWidget({
    super.key,
    required this.hasNudge,
    this.padding,
    required this.child,
  });
  final bool hasNudge;
  final EdgeInsets? padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasNudge)
          Container(
            margin: const EdgeInsets.only(top: 20),
            height: 6,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: AppColors.white,
            ),
          ),
        const Gap(10),
        Flexible(
          child: Container(
            padding: padding ??
                const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}
