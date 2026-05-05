import 'package:tupay/features/card/presentation/state_manager/card_state.dart';
import 'package:tupay/features/features.dart';

class VirtualCard extends StatelessWidget {
  const VirtualCard({
    required this.state,
    super.key,
  });

  final CardSuccess state;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF131B2E),
            Color(0xFF1E293B),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.25),
            blurRadius: 50,
            offset: const Offset(0, 25),
            spreadRadius: -12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  state.cardType,
                  style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                    color: AppColors.white.withValues(alpha: 0.68),
                    letterSpacing: 1.6,
                  ),
                ),
              ),
              const _CardNetworkMark(),
            ],
          ),

          context.uiHelper.verticalSpace(4),

          Text(
            state.cardLabel,
            style: context.appTextTheme.bodyNormal16Regular?.copyWith(
              color: AppColors.greenText3,
            ),
          ),

          context.uiHelper.verticalSpace(4),

          Text(
            state.maskedNumber,
            style: context.appTextTheme.bodyNormal16Regular?.copyWith(
              color: AppColors.white,
              letterSpacing: 3.2,
            ),
          ),

          context.uiHelper.verticalSpace(20),

          Row(
            children: [
              Expanded(
                child: _CardMetaText(
                  title: 'CARD HOLDER',
                  value: state.cardHolder,
                ),
              ),
              _CardMetaText(
                title: 'EXPIRES',
                value: state.expiry,
                crossAxisAlignment: CrossAxisAlignment.end,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardNetworkMark extends StatelessWidget {
  const _CardNetworkMark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 28,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.88),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.48),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardMetaText extends StatelessWidget {
  const _CardMetaText({
    required this.title,
    required this.value,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final String title;
  final String value;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      spacing: 8,
      children: [
        Text(
          title,
          style: context.appTextTheme.bodyNormal16Regular?.copyWith(
            color: AppColors.white.withValues(alpha: 0.62),

          ),
        ),
        Text(
          value,
          style: context.appTextTheme.bodyNormal16Regular?.copyWith(
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}