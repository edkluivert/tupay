import 'package:tupay/features/features.dart';
import 'package:tupay/features/wallet/presentation/widgets/spending_trend_chart.dart';

class SpendingTrendCard extends StatelessWidget {
  const SpendingTrendCard({
    required this.values,
    super.key,
  });

  final List<double> values;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.grey50),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 2,
            color: AppColors.black.withAlpha(10),
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Spending Trend',
                  style: context.appTextTheme.bodySmall14Regular?.copyWith(
                    fontSize: 16,
                    color: AppColors.textColor,
                  ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text('Last 7 Days',
                        style: context.appTextTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          color: AppColors.textColor,
                        )
                    ),
                    const Icon(Icons.arrow_drop_down,
                        size: 16, color: AppColors.textColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          context.uiHelper.verticalSpace(AppSpacing.md),
          SpendingTrendChart(values: values, height: 100),
        ],
      ),
    );
  }
}