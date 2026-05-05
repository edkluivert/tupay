import 'package:tupay/common/widgets/bouncing_clickable.dart';
import 'package:tupay/features/features.dart';
import 'package:tupay/features/profile/presentation/state_manager/profile_state.dart';

class LinkedMethodsCard extends StatelessWidget {
  const LinkedMethodsCard({
    required this.state,
    super.key,
  });

  final ProfileSuccess state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
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
              Text('Linked Methods', style: context.appTextTheme
                  .bodyNormal16Regular?.copyWith(
                color: AppColors.textColor,
              )),
              BouncyClickableWidget(
                onTap: () {},
                child: Text('Add New', style: context.appTextTheme
                    .bodyNormal16Regular?.copyWith(
                    color: AppColors.secondaryColor,

                )),
              ),
            ],
          ),
          context.uiHelper.verticalSpace(12),

          ...state.linkedMethods.map((method) => _LinkedMethodRow(
            method: method,
          )),
        ],
      ),
    );
  }
}

class _LinkedMethodRow extends StatelessWidget {
  const _LinkedMethodRow({required this.method});

  final LinkedPaymentMethod method;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.inputBorder.withAlpha(30)),
        ),
        child: Row(
          children: [

            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: method.bankColor,
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.center,
              child: Text(
                method.initials.length > 2
                    ? method.initials.substring(0, 5)
                    : method.initials,
                style: context.appTextTheme.heading?.copyWith(
                  color: AppColors.white,
                  fontSize: 8,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.bankName,
                    style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                      color: AppColors.textColor,
                    ),
                  ),
                  Text(
                    '${method.type} •••• ${method.maskedNumber}',
                    style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                      fontSize: 12,
                      color: AppColors.textColor1,
                    ),
                  ),
                ],
              ),
            ),
            if (method.isDefault)
              const Icon(
                Icons.check_circle,
                color: AppColors.secondaryColor,
                size: 22,
              )
            else
              Icon(
                Icons.circle,
                color: AppColors.textColor1.withValues(alpha: 0.03),
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}