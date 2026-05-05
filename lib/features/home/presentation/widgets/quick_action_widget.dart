import 'package:tupay/features/features.dart';
import 'package:tupay/common/widgets/quick_action_tile.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        QuickActionTile(
          label: 'Fund',
          icon: Icons.add,
          iconBgColor: AppColors.greenText1,
          iconColor: AppColors.greenText2,
          onTap: () {},
        ),

        QuickActionTile(
          label: 'Pay',
          icon: Icons.wallet_outlined,
          iconBgColor: AppColors.greyBlue,
          iconColor: AppColors.blue1,
          onTap: () {},
        ),

        QuickActionTile(
          label: 'Swap',
          icon: Icons.swap_horiz,
          iconBgColor: AppColors.greyBlue,
          iconColor: AppColors.blue1,
          onTap: () {},
        ),
      ],
    );
  }
}