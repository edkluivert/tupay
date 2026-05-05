import 'package:flutter_animate/flutter_animate.dart';
import 'package:tupay/features/features.dart';


class SecurityNotice extends StatelessWidget {
  const SecurityNotice(
      {super.key}
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey100.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputBorder.withValues(alpha: 0.30)
        )
      ),
      child: Row(
        spacing: 20,
        children: [
          const Icon(Icons.verified_user, color: AppColors.secondaryColor, size: 22),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'End-to-End Encryption',
                  style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                    color: AppColors.textColor,
                  ),
                ),
                context.uiHelper.verticalSpace(4),
                Text(
                  'Your transaction is protected by bank-grade\nsecurity protocols.',
                  style: context.appTextTheme.bodySmall14Regular?.copyWith(
                    color: AppColors.textColor2,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate()
        .fadeIn(delay: 200.ms, duration: 350.ms)
        .slideY(begin: 0.12, end: 0, delay: 200.ms, duration: 400.ms, curve: Curves.easeOutCubic);
  }
}