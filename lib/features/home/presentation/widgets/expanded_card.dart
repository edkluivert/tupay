import 'package:tupay/common/widgets/bouncing_clickable.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tupay/features/features.dart';

class ExpandedCard extends StatelessWidget {
  const ExpandedCard({
    required this.balance,
    required this.changePercent,
    required this.balanceVisible,
    required this.onToggleVisibility,

    super.key,
  });

  final String balance;
  final String changePercent;
  final bool balanceVisible;
  final VoidCallback onToggleVisibility;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'TOTAL BALANCE',
              style: context.appTextTheme.bodySmall14Regular?.copyWith(
                color: AppColors.grey300,
                fontSize: 16,
              ),
            ),
            BouncyClickableWidget(
              onTap: onToggleVisibility,
              child: Icon(
                balanceVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.grey300,
                size: 20,
              ),
            ),
          ],
        ),

        context.uiHelper.verticalSpace(4),


        AnimatedPriceBalanceText(balance: balance, balanceVisible: balanceVisible),

        context.uiHelper.verticalSpace(4),


        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.secondaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                changePercent,
                style: context.appTextTheme.bodySmall14Regular?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'vs last month',
              style: context.appTextTheme.bodySmall14Regular?.copyWith(
                fontSize: 11,
                color: AppColors.grey300,
              ),
            ),
          ],
        ),
      ],
    );
  }
}




class AnimatedPriceBalanceText extends StatelessWidget {
  const AnimatedPriceBalanceText({
    required this.balance,
    required this.balanceVisible,
    super.key,
  });

  final String balance;
  final bool balanceVisible;

  @override
  Widget build(BuildContext context) {
    final text = balanceVisible ? '₦ $balance' : '₦ ••••••••';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(text.length, (index) {
        final char = text[index];

        return _RollingCharacter(
          key: ValueKey('$index-$char'),
          character: char,
          delay: Duration(milliseconds: index * 35),
        );
      }),
    )
        .animate()
        .fadeIn(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    )
        .slideY(
      begin: 0.12,
      end: 0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
    );
  }
}

class _RollingCharacter extends StatelessWidget {
  const _RollingCharacter({
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
      duration: const Duration(milliseconds: 360),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final offsetAnimation = Tween<Offset>(
          begin: Offset(0, _isDigit ? 0.85 : 0.18),
          end: Offset.zero,
        ).animate(animation);

        return ClipRect(
          child: SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        );
      },
      child: Text(
        character,
        key: ValueKey(character),
        style: context.appTextTheme.bodySmall14Regular?.copyWith(
          color: AppColors.white,
          fontSize: 28,
          fontWeight: FontWeight.w500,
          height: 1,
        ),
      )
          .animate(delay: delay)
          .fadeIn(
        duration: const Duration(milliseconds: 220),
      )
          .slideY(
        begin: _isDigit ? 0.75 : 0.08,
        end: 0,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
      ),
    );
  }
}