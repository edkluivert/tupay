import 'package:tupay/common/widgets/bouncing_clickable.dart';
import 'package:tupay/features/features.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onActionTap,
    super.key,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: context.appTextTheme.bodySmall14Regular?.copyWith(
          fontSize: 18,
          color: AppColors.blackv2,
        )),
        BouncyClickableWidget(
          onTap: onActionTap,
          child: Text(actionLabel, style: context.appTextTheme.bodySmall14Regular?.copyWith(
            fontSize: 16,
            color: AppColors.secondaryColor,
          )),
        ),
      ],
    );
  }
}