import 'package:tupay/features/features.dart';

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthAppBar({
    super.key,
    this.showBack = true,
    this.showHelp = true,
    this.onHelpTap,
    this.onBackTap,
  });

  final bool showBack;
  final bool showHelp;
  final VoidCallback? onHelpTap;
  final VoidCallback? onBackTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      leading: showBack
          ? Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.pagePadding,
            ),
            child: IconButton(
                    icon: const Icon(
            Icons.arrow_back,
            color: AppColors.iconColor,
            size: 24,
                    ),
                    onPressed: onBackTap ?? () => Navigator.of(context).maybePop(),
                  ),
          )
          : null,
      title: Text('TuPay', style: context.appTextTheme
          .heading!.copyWith(
        fontSize: 18,
        color: AppColors.blackv2,
      )),
      centerTitle: true,
      actions: [
        if (showHelp)
          TextButton(
            onPressed: onHelpTap ?? () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColors.greenText,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding,),
            ),
            child: Text(
              'Help',
              style: context.appTextTheme.subHeading?.copyWith(
                fontSize: 16,
                color: AppColors.greenText,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}