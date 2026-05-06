import 'package:flutter_animate/flutter_animate.dart';
import 'package:tupay/features/features.dart';
import 'package:tupay/features/transfer/presentation/state_manager/transfer_flow_state.dart';
import 'package:tupay/features/transfer/presentation/widgets/step_next_button.dart';
import 'package:tupay/features/transfer/presentation/widgets/white_card.dart';

class RecipientView extends StatelessWidget {
  const RecipientView({
    required this.state,
    required this.nameController,
    required this.accountController,
    required this.onNameChanged,
    required this.onAccountChanged,
    required this.nameValidator,
    required this.accountValidator,
    required this.onSelectContact,
    required this.onNext,
    required this.onBack,
    super.key,
  });

  final TransferFlowState state;
  final TextEditingController nameController;
  final TextEditingController accountController;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onAccountChanged;
  final FormFieldValidator<String?> nameValidator;
  final FormFieldValidator<String?> accountValidator;
  final VoidCallback onSelectContact;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            WhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Who are you sending to?',
                    style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                      color: AppColors.textColor,
                    ),
                  ),
                  context.uiHelper.verticalSpace(8),
                  Text(
                    "Enter the recipient's details or select\nfrom your saved contacts.",
                    style: context.appTextTheme.bodySmall14Regular?.copyWith(
                      color: AppColors.textColor2,
                    ),
                  ),
                  context.uiHelper.verticalSpace(23),

                  BouncyClickableWidget(
                    onTap: onSelectContact,
                    borderRadius: 8,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.secondaryColor.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.contacts_outlined,
                            color: AppColors.secondaryColor,
                            size: 20,
                          ),
                          context.uiHelper.horizontalSpace(12),
                          Text(
                            'Select from contacts',
                            style: context.appTextTheme.bodySmall14Regular?.copyWith(
                              color: AppColors.secondaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors.secondaryColor,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  context.uiHelper.verticalSpace(20),

                  Row(children: [
                    Expanded(child: Divider(color: AppColors.inputBorder.withValues(alpha: 0.6))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'OR ENTER MANUALLY',
                        style: context.appTextTheme.bodySmall14Regular?.copyWith(
                          color: AppColors.textColor2,
                          fontSize: 11,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.inputBorder.withValues(alpha: 0.6))),
                  ]),

                  context.uiHelper.verticalSpace(20),

                  InputField(
                    hint: 'Full Name',
                    controller: nameController,
                    validator: nameValidator,
                    onChanged: onNameChanged,
                    textInputType: TextInputType.name,
                  ),

                  context.uiHelper.verticalSpace(14),

                  InputField(
                    hint: 'IBAN / Account Number',
                    controller: accountController,
                    validator: accountValidator,
                    onChanged: onAccountChanged,
                    textInputAction: TextInputAction.done,
                  ),

                  // Populated from contacts — show selected contact badge
                  if (nameController.text.isNotEmpty) ...[
                    context.uiHelper.verticalSpace(16),
                    _SelectedContactBadge(name: nameController.text),
                  ],
                ],
              ),
            )
                .animate()
                .fadeIn(delay: 80.ms, duration: 350.ms)
                .slideY(begin: 0.12, end: 0, delay: 80.ms, duration: 400.ms, curve: Curves.easeOutCubic),

            context.uiHelper.verticalSpace(24),


            _AmountSummaryPill(state: state)
                .animate()
                .fadeIn(delay: 140.ms, duration: 350.ms),

            context.uiHelper.verticalSpace(32),

            StepNextButton(
              label: 'Review Transfer',
              onTap: onNext,
            )
                .animate()
                .fadeIn(delay: 200.ms, duration: 350.ms)
                .slideY(begin: 0.12, end: 0, delay: 200.ms, duration: 400.ms, curve: Curves.easeOutCubic),

            context.uiHelper.verticalSpace(40),
          ],
        ),
      ),
    );
  }
}

class _SelectedContactBadge extends StatelessWidget {
  const _SelectedContactBadge({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.secondaryColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: AppColors.secondaryColor, size: 14),
          context.uiHelper.horizontalSpace(8),
          Text(
            'Contact selected: $name',
            style: context.appTextTheme.bodySmall14Regular?.copyWith(
              color: AppColors.secondaryColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountSummaryPill extends StatelessWidget {
  const _AmountSummaryPill({required this.state});

  final TransferFlowState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxTextWidth = constraints.maxWidth * 0.42;

          return Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Icon(
                Icons.swap_horiz,
                color: AppColors.secondaryColor,
                size: 18,
              ),

              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxTextWidth),
                child: Text(
                  state.formattedSending,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.appTextTheme.bodySmall14Regular?.copyWith(
                    color: AppColors.textColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const Icon(
                Icons.arrow_forward,
                size: 14,
                color: AppColors.textColor2,
              ),

              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxTextWidth),
                child: Text(
                  state.formattedRecipientGetsWithCurrency,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.appTextTheme.bodySmall14Regular?.copyWith(
                    color: AppColors.secondaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Text(
                state.exchangeRateText.replaceFirst('Rate: ', ''),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.appTextTheme.bodySmall14Regular?.copyWith(
                  color: AppColors.textColor2,
                  fontSize: 11,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}