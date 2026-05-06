import 'package:tupay/common/views/error_view.dart';
import 'package:tupay/common/views/loading_view.dart';
import 'package:tupay/common/widgets/bouncing_clickable.dart';
import 'package:tupay/features/features.dart';
import 'package:tupay/features/home/presentation/widgets/dashboard_app_bar.dart';
import 'package:tupay/features/profile/presentation/state_manager/profile_cubit.dart';
import 'package:tupay/features/profile/presentation/state_manager/profile_state.dart';
import 'package:tupay/features/profile/presentation/widgets/log_out_dialog.dart';
import 'package:tupay/features/profile/presentation/widgets/menu_card.dart';
import 'package:tupay/features/profile/presentation/widgets/profile_card.dart';



class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit()..loadProfile(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return switch (state) {
          ProfileLoading() => const LoadingView(),
          ProfileError(:final message) => ErrorView(
            message: message,
          ),
          ProfileSuccess() => _SuccessBody(state: state),
        };
      },
    );
  }
}

class _SuccessBody extends StatelessWidget {
  const _SuccessBody({required this.state});

  final ProfileSuccess state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DashboardAppBar(),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePadding,
          ),
          child: Column(
            children: [


              context.uiHelper.verticalSpace(10),


              ProfileCard(state: state),

              context.uiHelper.verticalSpace(48),

              MenuCard(
                state:state
              ),

              context.uiHelper.verticalSpace(12),


              BouncyClickableWidget(
                onTap: (){

                  showDialog<void>
                    (context: context, builder: (c){
                    return const LogOutDialog();
                  });
                },
                backgroundColor: AppColors.redLight.withValues(alpha: 0.1),
                borderRadius: 12,
                border: Border.all(
                  color: AppColors.redLight.withValues(alpha: 0.3)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 6,
                    children: [
                      const Icon(Icons.logout, color: AppColors.error, size: 18),
                      Text(
                        'Log Out',
                        style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                          color: AppColors.error,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              context.uiHelper.verticalSpace(70),
            ],
          ),
        ),
      ),
    );
  }
}



