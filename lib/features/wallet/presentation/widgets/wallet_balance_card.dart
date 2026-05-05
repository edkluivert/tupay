import 'dart:ui';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tupay/features/features.dart';
import 'package:tupay/features/wallet/presentation/state_manager/wallet/wallet_state.dart';

class WalletBalanceCard extends StatelessWidget {
  const WalletBalanceCard({
    required this.state,
    super.key,
  });

  final WalletSuccess state;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: AppColors.greyBlue200,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 8),
            blurRadius: 10,
            spreadRadius: -6,
            color: AppColors.black.withAlpha(10)
          ),
          BoxShadow(
              offset: const Offset(0, 20),
              blurRadius: 25,
              spreadRadius: -5,
              color: AppColors.black.withAlpha(10)
          ),
        ]
      ),
      child: Stack(
        children: [
          Positioned(
            right: 16,
            bottom: 16,
            child: SvgPicture.asset(
              height: 106,
              width: 106,
              AppAssets.dollar.svg,
              colorFilter: const ColorFilter.mode(Colors.white30, BlendMode.srcIn),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total USD Balance',
                  style: context.appTextTheme.bodySmall14Regular?.copyWith(
                    fontSize: 16,
                    color: AppColors.grey300,
                  ),
                ),
                context.uiHelper.verticalSpace(8),
                _AnimatedCashBalance(
                  balance: state.balance,
                  currencySymbol: r'$',
                ),
                context.uiHelper.verticalSpace(24),
                _GlassRatePill(
                  exchangeRate: state.exchangeRate,
                  rateChange: state.rateChange,
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}


class _GlassRatePill extends StatelessWidget {
  const _GlassRatePill({
    required this.exchangeRate,
    required this.rateChange,
    super.key,
  });

  final String exchangeRate;
  final String rateChange;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 14,
          sigmaY: 14,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: AppColors.white.withValues(alpha: 0.10),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              const Icon(
                Icons.trending_up,
                color: AppColors.greenText1,
                size: 14,
              ),
              Text(
                exchangeRate,
                style: context.appTextTheme.bodySmall14Regular?.copyWith(
                  color: AppColors.white,
                  fontSize: 16,
                ),
              ),
              Text(
                rateChange,
                style: context.appTextTheme.bodySmall14Regular?.copyWith(
                  color: AppColors.greenText1,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    )
        .slideY(
      begin: 0.15,
      end: 0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }
}

class _AnimatedCashBalance extends StatelessWidget {
  const _AnimatedCashBalance({
    required this.balance,
    super.key,
    this.currencySymbol = r'$',
  });

  final String balance;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final text = '$currencySymbol$balance';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(text.length, (index) {
        final character = text[index];

        return _CashCharacter(
          key: ValueKey('$index-$character'),
          character: character,
          delay: Duration(milliseconds: index * 35),
        );
      }),
    )
        .animate()
        .fadeIn(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    )
        .slideY(
      begin: 0.12,
      end: 0,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }
}

class _CashCharacter extends StatelessWidget {
  const _CashCharacter({
    required this.character,
    required this.delay,
    super.key,
  });

  final String character;
  final Duration delay;

  bool get _isDigit => RegExp(r'\d').hasMatch(character);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 420),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final slideAnimation = Tween<Offset>(
          begin: Offset(0, _isDigit ? 0.85 : 0.2),
          end: Offset.zero,
        ).animate(animation);

        return ClipRect(
          child: FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: slideAnimation,
              child: child,
            ),
          ),
        );
      },
      child: Text(
        character,
        key: ValueKey(character),
        style: context.appTextTheme.bodySmall14Regular?.copyWith(
          fontSize: 48,
          color: AppColors.white,
          fontWeight: FontWeight.w500,
          height: 1,
          fontFeatures: const [
            FontFeature.tabularFigures(),
          ],
        ),
      )
          .animate(delay: delay)
          .fadeIn(
        duration: const Duration(milliseconds: 180),
      )
          .slideY(
        begin: _isDigit ? 0.75 : 0.12,
        end: 0,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      ),
    );
  }
}