import 'package:tupay/common/widgets/bouncing_bubble.dart';
import 'package:tupay/common/widgets/clickable_widget.dart';
import 'package:tupay/core/injections/injection.dart';
import 'package:tupay/features/features.dart';

class WalletAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WalletAppBar({
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

            ClickableWidget(
              onTap: (){
                sl<NavigationService>().pop();
              },
              borderRadius: 4,
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.textColor,
              ),
            ),
           context.uiHelper.horizontalSpace(24),
            Text(
              'USD Wallet',
              style: context.appTextTheme.heading?.copyWith(
                fontSize: 20,
                color: AppColors.blackv2,
                fontWeight: FontWeight.w900,
              ),
            ),

            const Spacer(),

            const BellShakeAnimation(
              isLooping: true,
            ),

            context.uiHelper.horizontalSpace(12),

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