import 'package:tupay/common/widgets/bouncing_clickable.dart';
import 'package:tupay/features/features.dart';

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({

    required this.icon,
    required this.label,
    required this.onTap,
    this.showDivider = true,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BouncyClickableWidget(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 16, color: AppColors.black
                    ),
                ),
                context.uiHelper.horizontalSpace(16),
                Expanded(
                  child: Text(label, style: context.appTextTheme
                      .bodyNormal16Regular?.copyWith(
                    color: AppColors.textColor,
                  )),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: AppColors.textColor,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Divider(height: 1, color: AppColors.inputBorder),
          ),
      ],
    );
  }
}
