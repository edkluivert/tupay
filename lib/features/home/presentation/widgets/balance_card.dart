import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tupay/features/features.dart';
import 'package:tupay/features/home/presentation/widgets/expanded_card.dart';

const double _kMaxCardHeight = 180;
const double _kMinCardHeight = 84;

class BalanceCardSliverDelegate extends SliverPersistentHeaderDelegate {
  const BalanceCardSliverDelegate({
    required this.totalBalance,
    required this.changePercent,
    required this.balanceVisible,
    required this.onToggleVisibility,
  });

  final String totalBalance;
  final String changePercent;
  final bool balanceVisible;
  final VoidCallback onToggleVisibility;

  @override
  double get minExtent => _kMinCardHeight;

  @override
  double get maxExtent => _kMaxCardHeight;

  @override
  bool shouldRebuild(BalanceCardSliverDelegate oldDelegate) {
    return oldDelegate.totalBalance != totalBalance ||
        oldDelegate.changePercent != changePercent ||
        oldDelegate.balanceVisible != balanceVisible;
  }

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    final currentExtent = (maxExtent - shrinkOffset).clamp(
      minExtent,
      maxExtent,
    );

    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(
      0.0,
      1.0,
    );

    final cardPadding = lerpDouble(24, 12, progress)!;
    final bottomRadius = lerpDouble(AppSpacing.cardRadius, 0, progress)!;
    final topRadius = progress <= 0.01 ? AppSpacing.cardRadius : 0.0;


    final showExpanded = currentExtent >= 150;

    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pagePadding,
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topRadius),
              topRight: Radius.circular(topRadius),
              bottomLeft: Radius.circular(bottomRadius),
              bottomRight: Radius.circular(bottomRadius),
            ),
          ),
          clipBehavior: Clip.hardEdge,


          child: showExpanded
              ? ExpandedCard(
            balance: totalBalance,
            changePercent: changePercent,
            balanceVisible: balanceVisible,
            onToggleVisibility: onToggleVisibility,
          )
              : _CollapsedCard(
            balance: totalBalance,
            balanceVisible: balanceVisible,
            onToggleVisibility: onToggleVisibility,
          ),
        ),
      ),
    );
  }
}

class _CollapsedCard extends StatelessWidget {
  const _CollapsedCard({
    required this.balance,
    required this.balanceVisible,
    required this.onToggleVisibility,
    super.key,
  });

  final String balance;
  final bool balanceVisible;
  final VoidCallback onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    final text = balanceVisible ? '₦ $balance' : '₦ ••••••••';

    return Row(
      children: [
        Expanded(
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TOTAL BALANCE',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.appTextTheme.bodySmall14Regular
                              ?.copyWith(
                            color: AppColors.grey300,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          text,
                          maxLines: 1,
                          style: context.appTextTheme.bodySmall14Regular
                              ?.copyWith(
                            color: AppColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 36,
            minHeight: 36,
          ),
          onPressed: onToggleVisibility,
          icon: Icon(
            balanceVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: AppColors.grey300,
            size: 20,
          ),
        ),
      ],
    );
  }
}

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
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 160,
      ),
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