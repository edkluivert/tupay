import 'package:flutter_animate/flutter_animate.dart';
import 'package:tupay/features/features.dart';
import 'package:tupay/features/transfer/presentation/state_manager/transfer_flow_state.dart';
import 'package:tupay/features/transfer/presentation/widgets/section_tile.dart';
import 'package:tupay/features/transfer/presentation/widgets/security_notice.dart';
import 'package:tupay/features/transfer/presentation/widgets/transfer_summary_card.dart';
import 'package:tupay/features/transfer/presentation/widgets/white_card.dart';


class ReviewView extends StatelessWidget {
  const ReviewView({
    required this.state,
    required this.onReviewAndSend,
    required this.onBack,
    super.key,
  });

  final TransferFlowState state;
  final VoidCallback onReviewAndSend;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: Center(
        child: Column(
          children: [

            WhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Review your transfer',
                    style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                      color: AppColors.textColor,
                    ),
                  ),
                  context.uiHelper.verticalSpace(8),
                  Text(
                    'Please confirm all details before sending.',
                    style: context.appTextTheme.bodySmall14Regular?.copyWith(
                      color: AppColors.textColor2,
                    ),
                  ),
                  context.uiHelper.verticalSpace(24),


                  _ReviewSection(
                    title: 'TRANSFER DETAILS',
                    rows: [
                      _ReviewRow(
                        label: 'You Send',
                        value: state.formattedSending,
                        valueColor: AppColors.textColor,
                      ),
                      _ReviewRow(
                        label: 'Recipient Gets',
                        value: state.formattedRecipientGetsWithCurrency,
                        valueColor: AppColors.secondaryColor,
                      ),
                      _ReviewRow(
                        label: 'Exchange Rate',
                        value: state.exchangeRateText.replaceFirst('Rate: ', ''),
                      ),
                      _ReviewRow(
                        label: 'Fee',
                        value: state.formattedFee,
                        valueColor: state.formattedFee.contains('Promo')
                            ? AppColors.secondaryColor
                            : AppColors.textColor,
                      ),
                      _ReviewRow(
                        label: 'Estimated Arrival',
                        value: 'Today, ~15 mins',
                      ),
                    ],
                  ),

                  context.uiHelper.verticalSpace(20),


                  _ReviewSection(
                    title: 'RECIPIENT',
                    rows: [
                      _ReviewRow(
                        label: 'Name',
                        value: state.recipientName.isEmpty
                            ? '—'
                            : state.recipientName,
                      ),
                      _ReviewRow(
                        label: 'Account',
                        value: state.recipientAccount.isEmpty
                            ? '—'
                            : state.recipientAccount,
                        isMonospace: true,
                      ),
                    ],
                  ),

                  context.uiHelper.verticalSpace(20),


                  _ReviewSection(
                    title: 'PAYMENT METHOD',
                    rows: [
                      _ReviewRow(
                        label: 'Method',
                        value: TransferFlowState.paymentMethods
                            .firstWhere(
                              (m) => m.type == state.selectedPaymentMethod,
                        )
                            .title,
                      ),
                    ],
                  ),

                  // Edit link
                  context.uiHelper.verticalSpace(16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: BouncyClickableWidget(
                      onTap: onBack,
                      child: Text(
                        '← Edit details',
                        style: context.appTextTheme.bodySmall14Regular?.copyWith(
                          color: AppColors.secondaryColor,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: 60.ms, duration: 350.ms)
                .slideY(begin: 0.10, end: 0, delay: 60.ms, duration: 380.ms, curve: Curves.easeOutCubic),

            context.uiHelper.verticalSpace(24),


            TransferSummaryCard(
              state: state,
              onReviewAndSend: onReviewAndSend,
            ),

            context.uiHelper.verticalSpace(24),

            const SecurityNotice(),

            context.uiHelper.verticalSpace(120),
          ],
        ),
      ),
    );
  }
}


class _ReviewSection extends StatelessWidget {
  const _ReviewSection({required this.title, required this.rows});

  final String title;
  final List<_ReviewRow> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title),

        context.uiHelper.verticalSpace(12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: List.generate(rows.length, (i) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Text(
                          rows[i].label,
                          style: context.appTextTheme.bodySmall14Regular?.copyWith(
                            color: AppColors.textColor2,
                            fontSize: 13,
                          ),
                        ),
                        const Spacer(),
                        Flexible(
                          child: Text(
                            rows[i].value,
                            textAlign: TextAlign.right,
                            style: context.appTextTheme.bodySmall14Regular?.copyWith(
                              color: rows[i].valueColor ?? AppColors.textColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              fontFamily: rows[i].isMonospace ? 'monospace' : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (i < rows.length - 1)
                    Divider(
                      height: 1,
                      indent: 14,
                      endIndent: 14,
                      color: AppColors.inputBorder.withValues(alpha: 0.6),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _ReviewRow {
  const _ReviewRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isMonospace = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool isMonospace;
}