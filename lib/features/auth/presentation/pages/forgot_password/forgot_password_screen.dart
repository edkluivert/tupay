import 'package:flutter_svg/flutter_svg.dart';
import 'package:tupay/common/widgets/bouncing_clickable.dart';
import 'package:tupay/core/injections/injection.dart';
import 'package:tupay/features/auth/presentation/state_manager/forgot_password/forgot_password_cubit.dart';
import 'package:tupay/features/auth/presentation/state_manager/forgot_password/forgot_password_state.dart';
import 'package:tupay/features/auth/presentation/widgets/auth_app_bar.dart';
import 'package:tupay/features/auth/presentation/widgets/auth_header_icon.dart';
import 'package:tupay/features/features.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  final navigationService = sl<NavigationService>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendResetLink(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!_formKey.currentState!.validate()) return;

    context.read<ForgotPasswordCubit>().sendResetLink(
      email: _emailController.text,
    );
  }

  void _goToResetPassword() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigationService.clearLastAndNavigateTo(Routes.resetPassword);
    });

  }

  void _backToLogin() {
    navigationService.popUntil(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state.isFailure) {
          AppSnackBar.showFailure(
            context,
            message: state.message ?? 'Could not send reset link.',
          );
        }

        if (state.isSuccess) {
          AppSnackBar.showSuccess(
            context,
            message: state.message ?? 'Reset link sent.',
          );

          _goToResetPassword();
        }
      },
      builder: (context, state) {
        final forgotPasswordCubit = context.read<ForgotPasswordCubit>();
        final isLoading = state.isLoading;

        return Scaffold(
          appBar: const AuthAppBar(),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pagePadding,
              ),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    context.uiHelper.verticalSpace(31),
                    const AuthHeaderIcon(),
                    context.uiHelper.verticalSpace(23),
                    Text(
                      'Forgot Password',
                      style: context.appTextTheme.heading?.copyWith(
                        fontSize: 32,
                        color: AppColors.textColor,
                      ),
                    ),
                    context.uiHelper.verticalSpace(AppSpacing.sm),
                    Text(
                      "Enter your email address and we'll send you instructions to reset your password.",
                      style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                        fontSize: 16,
                        color: AppColors.textColor2,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    context.uiHelper.verticalSpace(48),

                    _AuthCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InputField(
                            label: 'Email',
                            fillColor: AppColors.lightGrey,
                            hint: 'name@company.com',
                            prefix: const Icon(
                              Icons.mail_outline,
                              color: AppColors.iconColor2,
                            ),
                            controller: _emailController,
                            textInputType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            validator: forgotPasswordCubit.validateEmail,
                            enterPressed: () => _handleSendResetLink(context),
                          ),

                          context.uiHelper.verticalSpace(AppSpacing.lg),

                          PrimaryButton(
                            title: 'Send Reset Link',
                            busy: isLoading,
                            onPressed: () {
                              if (isLoading) return;
                              _handleSendResetLink(context);
                            },
                            icon: isLoading
                                ? null
                                : const Icon(
                              Icons.arrow_forward,
                              color: AppColors.white,
                              size: 18,
                            ),
                          ),

                          context.uiHelper.verticalSpace(AppSpacing.lg),

                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 8,
                              children: [
                                SvgPicture.asset(AppAssets.arrowLeft.svg),
                                BouncyClickableWidget(
                                  onTap: _backToLogin,
                                  child: Text(
                                    'Back to login',
                                    style: context.appTextTheme.subHeading!
                                        .copyWith(
                                      fontSize: 14,
                                      color: AppColors.textColor2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    context.uiHelper.verticalSpace(AppSpacing.lg),

                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 6,
                        children: [
                          const Icon(
                            Icons.lock_outline,
                            size: 13,
                            color: AppColors.iconColor2,
                          ),
                          Flexible(
                            child: Text(
                              'Your connection to Tupay is encrypted and secure.',
                              style: context.appTextTheme.bodyMedium!.copyWith(
                                fontSize: 12,
                                color: AppColors.iconColor2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),

                    context.uiHelper.verticalSpace(AppSpacing.xl),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 40,
                      children: [
                        _SecurityBadge(
                          icon: AppAssets.shield.svg,
                          label: 'PCI DSS',
                        ),
                        _SecurityBadge(
                          icon: AppAssets.fast.svg,
                          label: 'Instant',
                        ),
                      ],
                    ),
                    context.uiHelper.verticalSpace(AppSpacing.lg),
                    Text(
                      '© 2024 Tupay Global. Secure Velocity and Tupay are registered trademarks.',
                      style: context.appTextTheme.bodySmall14Regular?.copyWith(
                        fontSize: 12,
                        color: AppColors.textColor2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    context.uiHelper.verticalSpace(AppSpacing.lg),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AuthCard extends StatelessWidget {
  const _AuthCard({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: child,
    );
  }
}

class _SecurityBadge extends StatelessWidget {
  const _SecurityBadge({
    required this.icon,
    required this.label,
  });

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: AppColors.lightGrey100,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(icon),
          ),
        ),
        Text(
          label,
          style: context.appTextTheme.bodyMedium!.copyWith(
            fontSize: 12,
            color: AppColors.textColor,
          ),
        ),
      ],
    );
  }
}