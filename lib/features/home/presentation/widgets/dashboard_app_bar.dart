import 'package:tupay/common/widgets/bouncing_bubble.dart';
import 'package:tupay/features/features.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({
    super.key,
    this.onNotificationTap,
  });

  final VoidCallback? onNotificationTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 12);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      toolbarHeight: preferredSize.height,
      title: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pagePadding,
        ),
        child: Row(
          children: [
            ClipOval(
              child: Image.asset(
                AppAssets.avatar.png,
                width: 32,
                height: 32,
                fit: BoxFit.cover,
              ),
            ),

            context.uiHelper.horizontalSpace(12),

            Text(
              'Tupay',
              style: context.appTextTheme.heading?.copyWith(
                fontSize: 18,
                color: AppColors.blackv2,
              ),
            ),

            const Spacer(),

            const BellShakeAnimation(
                isLooping: true,
              ),

          ],
        ),
      ),
    );
  }
}