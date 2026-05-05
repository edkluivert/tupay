import 'package:auto_size_text/auto_size_text.dart';
import 'package:gap/gap.dart';
import 'package:tupay/common/widgets/widget.dart';

class QuickTab extends StatelessWidget {
  const QuickTab({

    required this.text,
    this.onTap,
    this.isActive = false,
    super.key,
  });
  final String text;
  final VoidCallback? onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final uiHelper = UiHelper(context);
    return Flexible(
      child: TouchableOpacity(
        onTap: onTap,
        child: Column(
          children: [
            AutoSizeText(
              text,
              style: textTheme.bodySmall14Bold!.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const Gap(5),
            Container(
              height: 3,
              width: uiHelper.screenSize.width / 2,
              color: isActive ? AppColors.secondaryColor : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
