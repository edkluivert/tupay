import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tupay/features/features.dart';
import 'package:tupay/features/home/presentation/widgets/expanded_card.dart';


const double _kMaxCardHeight = 160;
const double _kMinCardHeight = 90;


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
  bool shouldRebuild(BalanceCardSliverDelegate old) =>
      old.totalBalance != totalBalance ||
      old.changePercent != changePercent ||
      old.balanceVisible != balanceVisible;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {

    final t = (shrinkOffset / (_kMaxCardHeight - _kMinCardHeight)).clamp(0.0, 1.0);
    final cardPadding = lerpDouble(24, 12, t)!;
    final radius = lerpDouble(AppSpacing.cardRadius, 0, t)!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 80),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(radius),
            bottomRight: Radius.circular(radius),
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: t < 0.7
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
    );
  }
}


class _CollapsedCard extends StatelessWidget {
  const _CollapsedCard({
    required this.balance,
    required this.balanceVisible,
    required this.onToggleVisibility,
  });

  final String balance;
  final bool balanceVisible;
  final VoidCallback onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 2,
          children: [
            Text(
              'TOTAL BALANCE',
              style: context.appTextTheme.bodySmall14Regular?.copyWith(
                color: AppColors.grey300,
                fontSize: 11,
              ),
            ),
            Text(
              balanceVisible ? '₦ $balance' : '₦ ••••••••',
              style: context.appTextTheme.bodySmall14Regular?.copyWith(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        IconButton(
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



