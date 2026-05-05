import 'package:tupay/features/features.dart';
import 'package:tupay/features/profile/presentation/state_manager/profile_state.dart';


class DailyLimitCard extends StatelessWidget {
  const DailyLimitCard({
    required this.state,
    super.key,
  });

  final ProfileSuccess state;

  @override
  Widget build(BuildContext context) {

    var progress = 0.575;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.inputBorder.withAlpha(30)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(3),
            offset: const Offset(0, 4),
            blurRadius: 12,
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.greenText1.withAlpha(20),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: AppColors.secondaryColor,
                  size: 20,
                ),
              ),
              Text('Daily Limit', style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                color: AppColors.textColor2,
              )),
            ],
          ),
          context.uiHelper.verticalSpace(16),
          Text(
            state.dailyLimit,
            style: context.appTextTheme.bodyNormal16Regular?.copyWith(
              color: AppColors.textColor,
            ),
          ),
          context.uiHelper.verticalSpace(4),
          Text(
            'Remaining: ${state.dailyUsed}',
            style: context.appTextTheme.bodyNormal16Regular?.copyWith(
              color: AppColors.iconColor2,
            ),
          ),
          context.uiHelper.verticalSpace(4),

          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.lightGrey100,
              valueColor: const AlwaysStoppedAnimation(AppColors.secondaryColor),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}