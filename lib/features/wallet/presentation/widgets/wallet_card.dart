import 'package:tupay/common/widgets/bouncing_clickable.dart';
import 'package:tupay/common/widgets/widget.dart';
import 'package:tupay/core/constants/app_spacing.dart';
import 'package:tupay/core/extensions/other_extensions.dart';
import 'package:tupay/features/wallet/data/models/wallet_model.dart';


class WalletCard extends StatelessWidget {
  const WalletCard({

    required this.wallet,
    required this.onTap,
    super.key,
  });

  final WalletModel wallet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BouncyClickableWidget(
      onTap: onTap,
      child: Container(
        width: 142,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
         border: Border.all(
           color: AppColors.grey50,
         ),
         boxShadow: [
           BoxShadow(
             color: AppColors.black.withValues(alpha: 0.10),
             blurRadius: 2,
             offset: const Offset(0, 1),
           ),
         ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [

            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.grey50,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(wallet.countryFlag,
                        style: context.appTextTheme.bodySmall14Regular),
                  ),
                ),
                context.uiHelper.horizontalSpace(8),
                Text(
                  wallet.currency,
                  style: context.appTextTheme.bodySmall14Regular?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            context.uiHelper.verticalSpace(8),

            Text(
              wallet.formattedBalance,
              style: context.appTextTheme.bodySmall14Regular?.copyWith(
                fontSize: 18,
                color: AppColors.blackv2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            Text(
              wallet.countryName,
              style: context.appTextTheme.bodySmall14Regular?.copyWith(
                color: AppColors.grey200,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
