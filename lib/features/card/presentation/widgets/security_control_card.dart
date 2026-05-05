import 'package:tupay/features/card/presentation/state_manager/card_cubit.dart';
import 'package:tupay/features/card/presentation/state_manager/card_state.dart';
import 'package:tupay/features/card/presentation/widgets/card_section.dart';
import 'package:tupay/features/features.dart';

class SecurityControlsCard extends StatelessWidget {
  const SecurityControlsCard({
    required this.state,
    super.key,
  });

  final CardSuccess state;

  @override
  Widget build(BuildContext context) {
    return CardSection(
      title: 'SECURITY CONTROLS',
      child: Column(
        children: [
          SecurityControlTile(
            icon: Icons.ac_unit_rounded,
            title: 'Freeze Card',
            trailing: Switch.adaptive(
              value: state.isFrozen,
              activeThumbColor: AppColors.secondaryColor,
              onChanged: (_) {
                context.read<CardCubit>().toggleFreeze();
              },
            ),
            onTap: () {
              context.read<CardCubit>().toggleFreeze();
            },
          ),
          context.uiHelper.verticalSpace(12),
          SecurityControlTile(
            icon: Icons.tune_rounded,
            title: 'Set Limits',
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.grey200,
              size: 30,
            ),
            onTap: () {},
          ),
          context.uiHelper.verticalSpace(12),
          SecurityControlTile(
            icon: Icons.lock_reset_rounded,
            title: 'Reset PIN',
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.grey200,
              size: 30,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class SecurityControlTile extends StatelessWidget {
  const SecurityControlTile({
    required this.icon,
    required this.title,
    required this.trailing,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final Widget trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BouncyClickableWidget(
      onTap: onTap,
      borderRadius: 8,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
              color: AppColors.textColor2,
            ),
            context.uiHelper.horizontalSpace(12),
            Expanded(
              child: Text(
                title,
                style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                  color: AppColors.textColor,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}