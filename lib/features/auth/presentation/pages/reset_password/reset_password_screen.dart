import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tupay/common/widgets/bouncing_clickable.dart';
import 'package:tupay/core/extensions/other_extensions.dart';
import 'package:tupay/core/injections/injection.dart';
import 'package:tupay/features/auth/presentation/state_manager/reset_password/reset_password_cubit.dart';
import 'package:tupay/features/auth/presentation/state_manager/reset_password/reset_password_state.dart';
import 'package:tupay/features/auth/presentation/widgets/auth_app_bar.dart';
import 'package:tupay/features/auth/presentation/widgets/auth_header_icon.dart';
import 'package:tupay/features/auth/presentation/widgets/password_requirement_item.dart';
import 'package:tupay/features/features.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetPasswordCubit(),
      child: const _ResetPasswordView(),
    );
  }
}

class _ResetPasswordView extends StatefulWidget {
  const _ResetPasswordView();

  @override
  State<_ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<_ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _handleReset(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!_formKey.currentState!.validate()) return;

    context.read<ResetPasswordCubit>().resetPassword(
      password: _passwordController.text,
      confirmPassword: _confirmController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state.isFailure) {
          AppSnackBar.showFailure(
            context,
            message: state.message ?? 'Password reset failed.',
          );
        }

        if (state.isSuccess) {
          AppSnackBar.showSuccess(
            context,
            message: state.message ?? 'Password updated!',
          );

          sl<NavigationService>().removeAllAndNavigateTo(Routes.login);
        }
      },
      builder: (context, state) {
        final resetPasswordCubit = context.read<ResetPasswordCubit>();

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
                    context.uiHelper.verticalSpace(38),

                    const AuthHeaderIcon(),

                    context.uiHelper.verticalSpace(AppSpacing.lg),

                    Text(
                      'Reset Password',
                      style: context.appTextTheme.heading?.copyWith(
                        fontSize: 32,
                        color: AppColors.textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    context.uiHelper.verticalSpace(AppSpacing.sm),

                    Text(
                      'Enter your new password below.',
                      style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                        fontSize: 16,
                        color: AppColors.textColor2,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    context.uiHelper.verticalSpace(AppSpacing.lg),

                    _ResetCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InputField(
                            label: 'New Password',
                            hint: '••••••••',
                            prefix: const Icon(Icons.lock_outline),
                            password: true,
                            controller: _passwordController,
                            validator: resetPasswordCubit.validatePassword,
                            onChanged: resetPasswordCubit.passwordChanged,
                            additionalNote: 'Minimum 8 characters with a mix of letters and numbers.',
                          ),

                          context.uiHelper.verticalSpace(
                            AppSpacing.fieldSpacing,
                          ),

                          InputField(
                            label: 'Confirm New Password',
                            hint: '••••••••',
                            prefix: const Icon(Icons.lock_open_outlined),
                            password: true,
                            controller: _confirmController,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              return resetPasswordCubit.validateConfirmPassword(
                                value,
                                _passwordController.text,
                              );
                            },
                            enterPressed: () => _handleReset(context),
                          ),

                          context.uiHelper.verticalSpace(AppSpacing.md),

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    PasswordRequirementItem(
                                      label: 'Min. 8 characters',
                                      met: state.hasMinLength,
                                    ),
                                    PasswordRequirementItem(
                                      label: 'One uppercase',
                                      met: state.hasUppercase,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    PasswordRequirementItem(
                                      label: 'One number',
                                      met: state.hasNumber,
                                    ),
                                    PasswordRequirementItem(
                                      label: 'Special character',
                                      met: state.hasSpecial,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          context.uiHelper.verticalSpace(AppSpacing.lg),

                          PrimaryButton(
                            title: 'Update Password',
                            busy: state.isLoading,
                            onPressed: () {
                              if (state.isLoading) return;
                              _handleReset(context);
                            },
                          ),
                          context.uiHelper.verticalSpace(30),
                        ],
                      ),
                    ),

                    context.uiHelper.verticalSpace(AppSpacing.lg),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm + 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.verified_user_sharp,
                            size: 16,
                            color: AppColors.secondaryColor,
                          ),
                          context.uiHelper.horizontalSpace(8),
                          Text(
                            'End-to-end encrypted session',
                            style:
                            context.appTextTheme.bodyMedium?.copyWith(
                              color: AppColors.textColor2,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    context.uiHelper.verticalSpace(15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 4,
                      children: [
                        Text(
                          'Having trouble?',
                          style:
                          context.appTextTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            color: AppColors.textColor2,
                          ),
                        ),
                        BouncyClickableWidget(
                          onTap: () {},
                          child: Text(
                            'Contact Support',
                            style: context.appTextTheme.subHeading?.copyWith(
                              fontSize: 12,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),

                    context.uiHelper.verticalSpace(AppSpacing.xxl),

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

class _ResetCard extends StatelessWidget {
  const _ResetCard({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: AppColors.inputBorder.withValues(alpha: 0.030),
        ),
      ),
      child: child,
    );
  }
}