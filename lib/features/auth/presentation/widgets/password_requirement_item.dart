import 'package:tupay/features/features.dart';



class PasswordRequirementItem extends StatelessWidget {
  const PasswordRequirementItem({

    required this.label,
    required this.met,
    super.key,
  });

  final String label;
  final bool met;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: met
                ? const Icon(
              Icons.check_circle,
              key: ValueKey(true),
              color: AppColors.secondaryColor,
              size: 18,
            )
                : Icon(
              Icons.circle_outlined,
              key: const ValueKey(false),
              color: AppColors.textColor1.withValues(alpha: 0.5),
              size: 18,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: context.appTextTheme.bodyMedium!.copyWith(
                fontSize: 12,
                color: met ? AppColors.textColor2 : AppColors.textColor2.withValues(alpha: 0.5),
                fontWeight: met ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}