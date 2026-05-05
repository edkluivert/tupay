import 'package:tupay/core/injections/injection.dart';
import 'package:tupay/features/features.dart';
import 'package:tupay/features/profile/presentation/state_manager/profile_state.dart';
import 'package:tupay/features/profile/presentation/widgets/profile_menu_item.dart';

class MenuCard extends StatefulWidget {
  MenuCard({required this.state, super.key});
  ProfileSuccess state;

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow:[
          BoxShadow(
            color: AppColors.black.withAlpha(3),
            offset: const Offset(0, 4),
            blurRadius: 12,
          )
        ]
      ),
      child: Column(
        children: [
          ProfileMenuItem(
            icon: Icons.person_outline,
            label: 'Personal Information',
            onTap: () {},
          ),
          ProfileMenuItem(
            icon: Icons.security,
            label: 'Security (Biometrics/PIN)',
            onTap: () {},
          ),
          ProfileMenuItem(
            icon: Icons.account_balance_outlined,
            label: 'Linked Bank Accounts',
            onTap: () {
              sl<NavigationService>().navigateTo(
                  Routes.linkedAccounts,
                 arguments: widget.state,
              );
            },
          ),
          ProfileMenuItem(
            icon: Icons.help_outline,
            label: 'Help & Support',
            onTap: () {},
            showDivider: false,
          ),
        ],
      ),
    );
  }
}
