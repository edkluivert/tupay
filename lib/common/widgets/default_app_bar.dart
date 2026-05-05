import 'package:tupay/core/constants/app_spacing.dart';
import 'package:tupay/core/core.dart';
import 'package:tupay/core/extensions/other_extensions.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar({
    required this.title,
    super.key,});

  final String title;


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return AppBar(
      elevation: 0,
      shadowColor: Colors.transparent,
      centerTitle: true,
      surfaceTintColor: AppColors.white,
      title: Text(
        title,
          style: context.appTextTheme
              .heading!.copyWith(
            fontSize: 18,
            color: AppColors.blackv2,
          )
      ),
      leading: Padding(
        padding: const EdgeInsets.only(
          left: AppSpacing.pagePadding,
        ),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.iconColor,
            size: 24,
          ),
          onPressed:  () => Navigator.of(context).maybePop(),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
