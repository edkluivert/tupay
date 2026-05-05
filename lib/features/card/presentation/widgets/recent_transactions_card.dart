import 'package:tupay/features/card/presentation/widgets/card_section.dart';
import 'package:tupay/features/features.dart';
import 'package:tupay/features/wallet/data/models/transaction_model.dart';
import 'package:tupay/features/wallet/presentation/widgets/transaction_item.dart';

class RecentTransactionsCard extends StatelessWidget {
  const RecentTransactionsCard({
    required this.transactions,
    super.key,
  });

  final List<TransactionModel> transactions;

  @override
  Widget build(BuildContext context) {
    final visibleTransactions = transactions.take(3).toList();

    return CardSection(
      title: 'RECENT TRANSACTIONS',
      trailing: BouncyClickableWidget(
        onTap: () {},
        child: Text(
          'View All',
          style: context.appTextTheme.bodyNormal16Regular?.copyWith(
            color: AppColors.secondaryColor,
          ),
        ),
      ),
      child: Column(
        children: List.generate(visibleTransactions.length, (index) {
          final transaction = visibleTransactions[index];

          return Padding(
            padding: EdgeInsets.only(
              bottom: index == visibleTransactions.length - 1 ? 0 : 26,
            ),
            child: _RecentTransactionItem(transaction: transaction),
          );
        }),
      ),
    );
  }
}

class _RecentTransactionItem extends StatelessWidget {
  const _RecentTransactionItem({
    required this.transaction,
  });

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final amountColor =
    transaction.isCredit ? AppColors.secondaryColor : AppColors.error;

    return Row(
      children: [
        _TransactionIcon(transaction: transaction),
        context.uiHelper.horizontalSpace(16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.title,
                style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                  color: AppColors.textColor
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              context.uiHelper.verticalSpace(2),
              Text(
                transaction.subtitle,
                style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                  color: AppColors.textColor1,
                  fontSize: 17,
                  height: 1.25,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        context.uiHelper.horizontalSpace(12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              transaction.formattedAmount,
              style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                color: amountColor,
                fontSize: 18,
              ),
            ),
            context.uiHelper.verticalSpace(8),
            Text(
              _statusText(transaction.status),
              style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                color: AppColors.secondaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _statusText(Object status) {
    final raw = status.toString().split('.').last;
    return raw[0].toUpperCase() + raw.substring(1);
  }
}

class _TransactionIcon extends StatelessWidget {
  const _TransactionIcon({
    required this.transaction,
  });

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final icon = _resolveIcon(transaction.title);

    return Container(
      width: 45,
      height: 45,
      decoration: const BoxDecoration(
        color: AppColors.lightGrey100,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: AppColors.textColor2,
        size: 22,
      ),
    );
  }

  IconData _resolveIcon(String title) {
    final normalized = title.toLowerCase();

    if (normalized.contains('coffee') || normalized.contains('dining')) {
      return Icons.restaurant_rounded;
    }

    if (normalized.contains('top') || normalized.contains('wallet')) {
      return Icons.account_balance_wallet_outlined;
    }

    if (normalized.contains('apple') || normalized.contains('service')) {
      return Icons.shopping_bag_outlined;
    }

    return Icons.receipt_long_outlined;
  }
}