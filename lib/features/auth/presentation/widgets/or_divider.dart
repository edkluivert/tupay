import 'package:tupay/core/extensions/other_extensions.dart';
import 'package:tupay/features/features.dart';


class OrDivider extends StatelessWidget {
  const OrDivider({
    required this.label,
    super.key,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: AppColors.inputBorder, thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            label,
            style: context.appTextTheme.bodyMedium!.copyWith(
              color: AppColors.textColor1,
              fontSize: 12,
            ),
          ),
        ),
        const Expanded(
          child: Divider(color: AppColors.inputBorder, thickness: 1),
        ),
      ],
    );
  }
}