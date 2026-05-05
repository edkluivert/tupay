import 'package:tupay/common/widgets/clickable_widget.dart';
import 'package:tupay/features/features.dart';
import 'package:tupay/features/wallet/data/models/transaction_model.dart';
import 'package:tupay/features/wallet/presentation/widgets/status_badge.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({

    required this.transaction,

    super.key,
  });

  final TransactionModel transaction;


  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onTap: () {},
      borderRadius: 12,
      padding: const EdgeInsets.all(16),
      boxShadow: [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.10),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ],
      child: Row(
        children: [

          _CategoryIcon(category: transaction.category),
          context.uiHelper.horizontalSpace(16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  transaction.title,
                  style: context.appTextTheme.bodySmall14Regular?.copyWith(
                    fontSize: 16,
                    color: AppColors.blackv2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  transaction.subtitle,
                  style: context.appTextTheme.bodySmall14Regular?.copyWith(
                    fontSize: 12,
                    color: AppColors.grey400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                transaction.formattedAmount,
                style: context.appTextTheme.bodySmall14Regular?.copyWith(
                  color: transaction.isCredit
                      ? AppColors.secondaryColor
                      : AppColors.blackv2,
                ),
              ),
              context.uiHelper.verticalSpace(4),
              StatusBadge(status: transaction.status),
            ],
          ),
        ],
      ),
    );
  }
}


class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({required this.category});

  final TransactionCategory category;

  @override
  Widget build(BuildContext context) {
    final (icon, bg, iconColor, iconSize) = switch (category) {
      TransactionCategory.walletFunding => (
      Icons.account_balance_outlined,
      AppColors.greenText1.withAlpha(30),
      AppColors.secondaryColor,
      20.0,
      ),
      TransactionCategory.transfer => (
      Icons.play_arrow_outlined,
      AppColors.greyBlue100.withAlpha(30),
      AppColors.black,
      30.0
      ),
      TransactionCategory.purchase => (
      Icons.shopping_bag_outlined,
      AppColors.greyBlue100.withAlpha(30),
      AppColors.black,
      20.0
      ),
      TransactionCategory.deposit => (
      Icons.south_west,
      AppColors.greyBlue100.withAlpha(30),
      AppColors.black,
      20.0
      ),
      TransactionCategory.subscription => (
      Icons.subscriptions_outlined,
      AppColors.greyBlue100.withAlpha(30),
      AppColors.black,
      20.0
      ),
      TransactionCategory.payout => (
      Icons.account_balance_wallet_outlined,
      AppColors.greyBlue100.withAlpha(30),
      AppColors.black,
      20.0
      ),
    };

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
      )
    );
  }
}
