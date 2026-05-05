import 'package:tupay/features/features.dart';
import 'package:tupay/features/home/presentation/widgets/expanded_card.dart';



class BalanceCardDelegate extends StatelessWidget {
  const BalanceCardDelegate({
    required this.totalBalance,
    required this.changePercent,
    required this.balanceVisible,
    required this.onToggleVisibility,
    super.key,
  });

  final String totalBalance;
  final String changePercent;
  final bool balanceVisible;
  final VoidCallback onToggleVisibility;



  @override
  Widget build(
      BuildContext context,

      ) {



    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      clipBehavior: Clip.hardEdge,
      child: ExpandedCard(
        balance: totalBalance,
        changePercent: changePercent,
        balanceVisible: balanceVisible,
        onToggleVisibility: onToggleVisibility,

      ),
    );
  }
}


