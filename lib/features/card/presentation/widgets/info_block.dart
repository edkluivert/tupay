import 'package:tupay/features/features.dart';



class InfoBlock extends StatelessWidget {
  const InfoBlock({
    required this.label,
    required this.value,
    super.key,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.appTextTheme.bodyNormal16Regular?.copyWith(
            color: AppColors.textColor1,
          ),
        ),
        context.uiHelper.verticalSpace(2),
        Text(
          value,
          style: context.appTextTheme.subHeading?.copyWith(
            color: AppColors.textColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}