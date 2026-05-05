import 'package:tupay/features/features.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    required this.label,
    required this.leading,
    required this.trailing,
    this.backgroundColor = Colors.transparent,
    this.borderColor = Colors.transparent,
    this.labelColor = AppColors.black,
    super.key,
  });

  final String label;
  final Widget leading;
  final Widget trailing;
  final Color backgroundColor;
  final Color borderColor;
  final Color labelColor;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(
            label,
            style: context.appTextTheme.bodySmall14Regular?.copyWith(
              fontSize: 16,
              color: labelColor,
            ),
          ),
          leading,
          trailing,
        ],
      ),
    );
  }
}