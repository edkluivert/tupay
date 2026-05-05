import 'package:tupay/features/features.dart';
import 'package:tupay/common/widgets/quick_action_tile.dart';

class WalletQuickActions extends StatelessWidget {
  const WalletQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [

        QuickActionTile(
          label: 'Add Fund',
          icon: Icons.add_circle_sharp,
          iconBgColor: AppColors.secondaryColor.withAlpha(10),
          iconColor: AppColors.secondaryColor,
          onTap: () {},
        ),

        QuickActionTile(
          label: 'Transfer',
          icon: Icons.send_outlined,
          iconBgColor: AppColors.greyBlue,
          iconColor: AppColors.greyBlue200,
          onTap: () {},
        ),

        QuickActionTile(
          label: 'View Card',
          icon: Icons.wallet_outlined,
          iconBgColor: AppColors.blue.withAlpha(10),
          iconColor: AppColors.blue,
          onTap: () {},
        ),

      ],
    );
  }
}