import 'package:flutter_animate/flutter_animate.dart';
import 'package:tupay/features/features.dart';
import 'package:tupay/features/transfer/presentation/state_manager/transfer_flow_state.dart';


class TransferSummaryCard extends StatelessWidget {
  const TransferSummaryCard({
    required this.state,
    required this.onReviewAndSend,
    super.key,
  });

  final TransferFlowState state;
  final VoidCallback onReviewAndSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transfer Summary',
            style: context.appTextTheme.bodyNormal16Regular?.copyWith(
              color: AppColors.white,
            ),
          ),
          context.uiHelper.verticalSpace(12),
          Divider(color: AppColors.white.withValues(alpha: 0.18)),
          context.uiHelper.verticalSpace(8),
          _SummaryRow(label: 'Sending',
              value: state.formattedSending,
          ),
          context.uiHelper.verticalSpace(16),
          _SummaryRow(
            label: 'Fees',
            value: state.formattedFee,
            valueColor: state.formattedFee.contains('Promo')
                ? AppColors.greenText3
                : AppColors.white,
          ),
          context.uiHelper.verticalSpace(16),
          const _SummaryRow(label: 'Estimated Arrival', value: 'Today, ~15 mins'),
          context.uiHelper.verticalSpace(16),
          Divider(color: AppColors.white.withValues(alpha: 0.18)),
          context.uiHelper.verticalSpace(14),
          Text(
            'TOTAL TO PAY',
            style: context.appTextTheme.bodyNormal16Regular?.copyWith(
              color: AppColors.grey300,
              letterSpacing: 2,
            ),
          ),
          context.uiHelper.verticalSpace(4),
          Text(
            state.formattedTotalToPay,
            style: context.appTextTheme.heading?.copyWith(
              color: AppColors.white,
              fontSize: 30,
            ),
          ),
          context.uiHelper.verticalSpace(24),

          BouncyClickableWidget(
            onTap: state.isLoading ? null : onReviewAndSend,
            borderRadius: 8,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondaryColor.withValues(alpha: 0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: state.isLoading
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
                    : Text(
                  'REVIEW & SEND',
                  style: context.appTextTheme.subHeading?.copyWith(
                    color: AppColors.white,
                    fontSize: 14,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate()
        .fadeIn(delay: 140.ms, duration: 350.ms)
        .slideY(begin: 0.12, end: 0, delay: 140.ms, duration: 400.ms, curve: Curves.easeOutCubic);
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label,
    required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: context.appTextTheme.bodyNormal16Regular?.copyWith(
            color: AppColors.white.withValues(alpha: 0.46),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: context.appTextTheme.bodyNormal16Regular?.copyWith(
            color: valueColor ?? AppColors.white,
          ),
        ),
      ],
    );
  }
}