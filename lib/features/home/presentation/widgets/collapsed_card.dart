import 'package:tupay/features/features.dart';

class CollapsedCard extends StatelessWidget {
  const CollapsedCard({
    required this.balance,
    required this.balanceVisible,
    super.key,
  });

  final String balance;
  final bool balanceVisible;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'TOTAL BALANCE',
          style:  context.appTextTheme.bodySmall14Regular?.copyWith(
            color: AppColors.white,
            letterSpacing: 1.2,
          ),
        ),
        const Spacer(),
        Text(
          balanceVisible ? '₦ $balance' : '₦ ••••••••',
          style: context.appTextTheme.bodySmall14Regular?.copyWith(
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}