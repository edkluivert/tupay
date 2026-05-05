import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tupay/common/widgets/bouncing_clickable.dart';
import 'package:tupay/common/widgets/clickable_widget.dart';
import 'package:tupay/core/injections/injection.dart';
import 'package:tupay/features/auth/presentation/state_manager/login/login_cubit.dart';
import 'package:tupay/features/auth/presentation/state_manager/login/login_state.dart';
import 'package:tupay/features/auth/presentation/widgets/auth_app_bar.dart';
import 'package:tupay/features/auth/presentation/widgets/or_divider.dart';
import 'package:tupay/features/auth/presentation/widgets/social_auth_btn.dart';
import 'package:tupay/features/features.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final navigationService = sl<NavigationService>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    context.read<LoginCubit>().login(
      emailOrUsername: _emailController.text,
      password: _passwordController.text,
    );
  }

  void _goToForgotPassword() {
    navigationService.navigateTo(Routes.forgotPassword);
  }

  void _goToSignup() {
    navigationService.clearLastAndNavigateTo(Routes.signup);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          AppSnackBar.showFailure(
            context,
            message: state.message ?? 'Signup failed.',
          );
        }

        if (state.isSuccess) {
          AppSnackBar.showSuccess(
            context,
            message: state.message ?? 'Welcome back!',
          );
          navigationService.removeAllAndNavigateTo(Routes.appBottomNav);
        }
      },
      builder: (context, state) {
        final isLoading = state.isLoading;

        return Scaffold(
          appBar: const AuthAppBar(),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pagePadding,
              ),
              child: Column(
                
                children: [
                  context.uiHelper.verticalSpace(31),

                  Text(
                    'Welcome Back',
                    style: context.appTextTheme.heading?.copyWith(
                      fontSize: 32,
                      color: AppColors.textColor,
                    ),
                  ),
                  context.uiHelper.verticalSpace(AppSpacing.sm),
                  Text(
                    'Institutional-grade security for your digital assets.',
                    style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                      fontSize: 16,
                      color: AppColors.textColor2,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  context.uiHelper.verticalSpace(AppSpacing.lg),

                  _AuthCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputField(
                          label: 'Email',
                          fillColor: AppColors.primaryColor,
                          hint: 'name@company.com',
                          prefix: const Icon(Icons.mail_outline,
                            color: AppColors.iconColor2,
                          ),
                          controller: _emailController,
                          textInputType: TextInputType.emailAddress,
                        ),

                        context.uiHelper.verticalSpace(AppSpacing.fieldSpacing),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                             'Password',
                              style: context.appTextTheme.subHeading!.copyWith(
                                fontSize: 16,
                                color: AppColors.textColor,
                              ),
                            ),
                            ClickableWidget(
                              onTap: _goToForgotPassword,
                              borderRadius: 4,
                              child: AutoSizeText(
                                 'Forgot Password?',
                                style: context.appTextTheme.bodyMedium!.copyWith(
                                  fontSize: 12,
                                  color: AppColors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        context.uiHelper.verticalSpace(8),
                        InputField(
                          hint: '••••••••',
                          fillColor: AppColors.primaryColor,
                          prefix: const Icon(
                              Icons.lock_outline,
                            color: AppColors.iconColor2,
                            size: 16,
                          ),
                          password: true,
                          controller: _passwordController,
                          textInputAction: TextInputAction.done,

                        ),

                        const SizedBox(height: AppSpacing.lg),

                       PrimaryButton(
                          title: 'Log In',
                          busy: isLoading,
                          onPressed: () {
                            if (isLoading) return;
                            _handleLogin(context);
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

                        const OrDivider(label: 'OR LOGIN WITH'),

                        context.uiHelper.verticalSpace(AppSpacing.lg),

                        Row(
                          spacing: AppSpacing.sm,
                          children: [
                            Expanded(
                              child: SocialAuthButton(
                                label: 'Biometric',
                                icon: const Icon(
                                  Icons.fingerprint,
                                  size: 20,
                                  color: AppColors.textColor,
                                ),
                                onPressed: () {
                                  if (isLoading) return;
                                  context
                                      .read<LoginCubit>()
                                      .loginWithBiometric();
                                },
                              ),
                            ),
                            Expanded(
                              child: SocialAuthButton(
                                label: 'Face ID',
                                icon: const Icon(
                                  Icons.face_retouching_natural,
                                  size: 20,
                                  color: AppColors.textColor,
                                ),
                                onPressed: () {
                                  if (isLoading) return;
                                  context.read<LoginCubit>().loginWithFaceId();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 4,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: context
                              .appTextTheme
                              .bodySmall14Regular!
                              .copyWith(
                            fontSize: 16,
                            color: AppColors.textColor2,
                          ),
                        ),
                        BouncyClickableWidget(
                          onTap: _goToSignup,
                          child: Text(
                            'Sign Up',
                            style: context.appTextTheme.subHeading!
                                .copyWith(
                              fontSize: 16,
                              color: AppColors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  context.uiHelper.verticalSpace(AppSpacing.xl),

                 Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      _SecurityBadge(
                        icon: AppAssets.shield2.svg,
                        label: 'ISO 27001',
                      ),

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

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 6,
                      children: [
                        const Icon(
                          Icons.lock_outline,
                          size: 13,
                          color: AppColors.inputBorder,
                        ),
                        Flexible(
                          child: Text(
                            'Your connection to Tupay is encrypted and secure.',
                            style: context.appTextTheme.bodyMedium!.copyWith(
                              fontSize: 12,
                              color: AppColors.inputBorder,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),
                ],
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
            child: SvgPicture.asset(
              icon,
            ),
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