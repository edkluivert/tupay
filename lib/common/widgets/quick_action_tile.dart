import 'package:tupay/common/widgets/bouncing_clickable.dart';
import 'package:tupay/features/features.dart';


class QuickActionTile extends StatelessWidget {
  const QuickActionTile({

    required this.label,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.onTap,
    super.key,
  });

  final String label;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BouncyClickableWidget(
        onTap: onTap,
        child: Container(
          height: 140,
          padding: const EdgeInsets.symmetric(
            horizontal: 27,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
           boxShadow: [
             BoxShadow(
               offset: const Offset(0, 1),
               blurRadius: 2,
               color: AppColors.black.withAlpha(10),
             )
           ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              Text(label, style: context.appTextTheme.bodySmall14Regular?.copyWith(
                fontSize: 16,
                color: AppColors.textColor,
              ),
               textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
