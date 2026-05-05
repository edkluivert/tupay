import 'package:tupay/features/features.dart';

class TransferAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TransferAppBar({
    required this.onBack,
    super.key,
  });

  final VoidCallback onBack;

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      toolbarHeight: preferredSize.height,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
        child: Row(
          children: [
            BouncyClickableWidget(
              onTap: onBack,
              child: const Icon(Icons.arrow_back, color: AppColors.textColor),
            ),
            context.uiHelper.horizontalSpace(24),
            Text(
              'Tupay',
              style: context.appTextTheme.subHeading?.copyWith(
                fontSize: 18,
                color: AppColors.textColor,
              ),
            ),
            const Spacer(),
            ClipOval(
              child: Image.asset(
                AppAssets.avatar.png,
                width: 32,
                height: 32,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}