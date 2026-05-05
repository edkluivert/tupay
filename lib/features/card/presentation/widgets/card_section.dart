import 'package:tupay/features/features.dart';

class CardSection extends StatelessWidget {
  const CardSection({
    required this.title,
    required this.child,
    this.trailing,
    super.key,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.inputBorder.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                    color: AppColors.textColor2,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          context.uiHelper.verticalSpace(28),
          child,
        ],
      ),
    );
  }
}