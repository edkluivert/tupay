import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tupay/common/widgets/bouncing_clickable.dart';
import 'package:tupay/common/widgets/clickable_widget.dart';
import 'package:tupay/common/widgets/custom_dropdown.dart';
import 'package:tupay/core/extensions/other_extensions.dart';
import 'package:tupay/core/injections/injection.dart';
import 'package:tupay/features/auth/presentation/state_manager/sign_up/sign_up_cubit.dart';
import 'package:tupay/features/auth/presentation/state_manager/sign_up/sign_up_state.dart';
import 'package:tupay/features/auth/presentation/widgets/auth_app_bar.dart';
import 'package:tupay/features/auth/presentation/widgets/or_divider.dart';
import 'package:tupay/features/auth/presentation/widgets/social_auth_btn.dart';
import 'package:tupay/features/features.dart';



class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupCubit(),
      child: const _SignupView(),
    );
  }
}

class _SignupView extends StatefulWidget {
  const _SignupView();

  @override
  State<_SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<_SignupView> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignup(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!_formKey.currentState!.validate()) return;

    context.read<SignupCubit>().signup(
      fullName: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
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
            message: state.message ?? 'Account created!',
          );

        }
      },
      builder: (context, state) {
        final signupCubit = context.read<SignupCubit>();

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
                    _SignupCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Create Account',
                              style: context.appTextTheme.heading?.copyWith(
                                fontSize: 32,
                                color: AppColors.textColor,
                              ),
                            ),
                          ),
                          context.uiHelper.verticalSpace(AppSpacing.sm),
                          Center(
                            child: Text(
                              'Join global citizens managing finance with speed and security.',
                              style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                                fontSize: 16,
                                color: AppColors.textColor2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          context.uiHelper.verticalSpace(AppSpacing.lg),

                          InputField(
                            label: 'Full Name',
                            hint: 'John Doe',
                            controller: _nameController,
                            textInputType: TextInputType.name,
                            validator: signupCubit.validateFullName,
                          ),

                          context.uiHelper.verticalSpace(AppSpacing.fieldSpacing),

                          InputField(
                            label: 'Email Address',
                            hint: 'name@company.com',
                            prefix: const Icon(Icons.mail_outline),
                            controller: _emailController,
                            textInputType: TextInputType.emailAddress,
                            validator: signupCubit.validateEmail,
                          ),

                          context.uiHelper.verticalSpace(AppSpacing.fieldSpacing),

                          Text(
                            'Phone Number',
                            style: context.appTextTheme.subHeading!.copyWith(
                              fontSize: 16,
                              color: AppColors.textColor,
                            ),
                          ),
                          context.uiHelper.verticalSpace(8),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 12,
                            children: [
                              Expanded(
                                flex: 2,
                                child: CustomDropdown<SignupCountry>(
                                  value: state.selectedCountry,
                                  fillColor: AppColors.lightGrey,
                                  selectedTextBuilder: (country) => country.dialCode,
                                  menuItems: SignupCountry.supportedCountries.map((country) {
                                    return DropdownMenuItem<SignupCountry>(
                                      value: country,
                                      child: Text(
                                        '${country.name} (${country.dialCode})',
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (country) {
                                    if (country == null) return;

                                    context
                                        .read<SignupCubit>()
                                        .countryChanged(country);

                                    _phoneController.clear();
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: InputField(
                                  hint: state.selectedCountry.example,
                                  controller: _phoneController,
                                  textInputType: TextInputType.phone,
                                  validator: signupCubit.validatePhone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(
                                      state.selectedCountry.maxLength,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          context.uiHelper.verticalSpace(AppSpacing.fieldSpacing),

                          InputField(
                            label: 'Password',
                            hint: '••••••••',
                            password: true,
                            controller: _passwordController,
                            textInputAction: TextInputAction.done,
                            validator: signupCubit.validatePassword,
                          ),

                          const SizedBox(height: AppSpacing.lg),

                          PrimaryButton(
                            title: 'Create Account',
                            busy: state.isLoading,
                            onPressed: () {
                              if (state.isLoading) return;
                              _handleSignup(context);
                            },
                          ),

                          context.uiHelper.verticalSpace(AppSpacing.lg),

                          const OrDivider(label: 'OR CONTINUE WITH'),

                          context.uiHelper.verticalSpace(AppSpacing.lg),

                          Row(
                            spacing: AppSpacing.sm,
                            children: [
                              Expanded(
                                child: SocialAuthButton(
                                  label: 'Google',
                                  icon: Image.asset(AppAssets.google.png),
                                  onPressed: () {},
                                ),
                              ),
                              Expanded(
                                child: SocialAuthButton(
                                  label: 'Apple',
                                  icon: SvgPicture.asset(AppAssets.apple.svg),
                                  iconSize: 18,
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),

                          context.uiHelper.verticalSpace(AppSpacing.lg),

                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 4,
                              children: [
                                Text(
                                  'Already have an account? ',
                                  style: context
                                      .appTextTheme
                                      .bodySmall14Regular!
                                      .copyWith(
                                    fontSize: 16,
                                    color: AppColors.textColor2,
                                  ),
                                ),
                                BouncyClickableWidget(
                                  onTap: () => sl<NavigationService>().navigateTo(Routes.login),
                                  child: Text(
                                    'Log In',
                                    style: context.appTextTheme.subHeading!
                                        .copyWith(
                                      fontSize: 16,
                                      color: AppColors.secondaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _TrustBadge(
                          icon: SvgPicture.asset(AppAssets.shield.svg),
                          label: 'Bank-grade Security',
                        ),
                        context.uiHelper.horizontalSpace(AppSpacing.xl),
                        _TrustBadge(
                          icon: SvgPicture.asset(AppAssets.world.svg),
                          label: 'GDPR Compliant',
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
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


class _SignupCard extends StatelessWidget {
  const _SignupCard({
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

class _TrustBadge extends StatelessWidget {
  const _TrustBadge({
    required this.icon,
    required this.label,
  });

  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        icon,
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