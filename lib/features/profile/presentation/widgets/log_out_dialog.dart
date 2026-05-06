import 'package:tupay/core/injections/injection.dart';
import 'package:tupay/core/services/current_user_service.dart';
import 'package:tupay/features/auth/presentation/state_manager/auth/auth_bloc.dart';
import 'package:tupay/features/auth/presentation/state_manager/auth/auth_event.dart';
import 'package:tupay/features/features.dart';

class LogOutDialog extends StatelessWidget {
  const LogOutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.logout_rounded,
            color: AppColors.secondaryColor,
            size: 42,
          ),

          context.uiHelper.verticalSpace(16),

          Text(
            'Log out?',
            textAlign: TextAlign.center,
            style: context.appTextTheme.bodyNormal16Regular?.copyWith(
              color: AppColors.textColor,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),

          context.uiHelper.verticalSpace(8),

          Text(
            'Are you sure you want to log out of your Tupay account?',
            textAlign: TextAlign.center,
            style: context.appTextTheme.bodySmall14Regular?.copyWith(
              color: AppColors.textColor1,
              height: 1.4,
            ),
          ),

          context.uiHelper.verticalSpace(28),

          Row(
            children: [
              Expanded(
                child: BouncyClickableWidget(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.inputBorder,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.inputBorder.withAlpha(40),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              context.uiHelper.horizontalSpace(12),

              Expanded(
                child: BouncyClickableWidget(
                  onTap: () {
                    Navigator.of(context).pop();

                    sl<CurrentUserService>().clear();
                    context.read<AuthBloc>().add(LogoutRequested());
                  },
                  child: Container(
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'Log out',
                      style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
