import 'package:tupay/features/features.dart';
import 'package:tupay/features/profile/presentation/state_manager/profile_state.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    required this.state,
    super.key,
  });

  final ProfileSuccess state;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow:[
          BoxShadow(
            color: AppColors.black.withAlpha(10),
            offset: const Offset(0, 1),
            blurRadius: 2,
          )
        ]
      ),
      child: Column(
        children: [

          Stack(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.cardBg,
                child: Icon(Icons.person, color: AppColors.white, size: 40),
              ),
              if (state.isVerified)
                Positioned(
                  right: 0,
                  bottom: 5,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration:  BoxDecoration(
                      color: AppColors.greenText1,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.inputBorder,
                      )
                    ),
                    child: const Icon(
                      Icons.verified_rounded,
                      color: AppColors.greenText2,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
          context.uiHelper.verticalSpace(28),
          Text(state.name, style: context.appTextTheme.bodyNormal16Regular?.copyWith(
            color: AppColors.textColor,
          )),
          context.uiHelper.verticalSpace(4),
          Text(state.email, style: context.appTextTheme.bodySmall14Regular?.copyWith(
            color: AppColors.textColor2,
          )),
          context.uiHelper.verticalSpace(16),

        
          if (state.isVerified)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.greenText1.withAlpha(20),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 6,
                children: [
                  const Icon(
                    Icons.circle,
                    color: AppColors.secondaryColor,
                    size: 8,
                  ),
                  Text(
                    'Identity Verified',
                    style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                      color: AppColors.greenText2,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: AppSpacing.md),


          PrimaryButton(
            title: 'Edit Profile',
            onPressed: () {},
            color: AppColors.black,
          ),
        ],
      ),
    );
  }
}











