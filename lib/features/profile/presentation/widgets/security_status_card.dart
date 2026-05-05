import 'package:flutter_svg/flutter_svg.dart';
import 'package:tupay/common/widgets/bouncing_clickable.dart';
import 'package:tupay/features/features.dart';


class SecurityStatusCard extends StatelessWidget {
  const SecurityStatusCard({
    required this.percent,
    super.key,
  });

  final int percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: SvgPicture.asset(
              AppAssets.shield3.svg,
              colorFilter: const ColorFilter.mode(Colors.white30, BlendMode.srcIn),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SECURITY STATUS',
                  style: context.appTextTheme.bodySmall14Regular?.copyWith(
                    fontSize: 16,
                    color: AppColors.grey300,
                  ),
                ),
                context.uiHelper.verticalSpace(8),
                Text(
                  'Your account is',
                  style: context.appTextTheme.bodySmall14Regular?.copyWith(
                    fontSize: 16,
                    color: AppColors.white,
                  )
                ),
                Text(
                  '$percent% Secured',
                    style: context.appTextTheme.bodySmall14Regular?.copyWith(
                      fontSize: 16,
                      color: AppColors.greenText1,
                    )
                ),
                context.uiHelper.verticalSpace(30),
                BouncyClickableWidget(
                  onTap: () {},
                  child: Row(
                    spacing: 6,
                    children: [
                      Text(
                        'Review Security ',
                        style: context.appTextTheme.bodySmall14Regular?.copyWith(
                          fontSize: 16,
                          color: AppColors.grey600,
                        ),
                      ),
                      const Icon(Icons.arrow_forward,
                        color: AppColors.grey600,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}