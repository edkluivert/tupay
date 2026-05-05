import 'package:tupay/features/features.dart';


class SectionTitle extends StatelessWidget {
  const SectionTitle(
      this.text,
      {
        super.key,
      }
      );

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.appTextTheme.bodyNormal16Regular?.copyWith(
        color: AppColors.textColor,
      ),
    );
  }
}