import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tupay/common/widgets/custom_dropdown.dart';
import 'package:tupay/features/features.dart';
import 'package:tupay/features/transfer/data/models/transfer_currency.dart';
import 'package:tupay/features/transfer/presentation/state_manager/transfer_flow_cubit.dart';
import 'package:tupay/features/transfer/presentation/state_manager/transfer_flow_state.dart';
import 'package:tupay/features/transfer/presentation/widgets/payment_method_card.dart';
import 'package:tupay/features/transfer/presentation/widgets/step_next_button.dart';
import 'package:tupay/features/transfer/presentation/widgets/white_card.dart';

class AmountView extends StatelessWidget {
  const AmountView({
    required this.state,
    required this.amountController,
    required this.onAmountChanged,
    required this.amountValidator,
    required this.onPaymentMethodTap,
    required this.onNext,
    super.key,
  });

  final TransferFlowState state;
  final TextEditingController amountController;
  final ValueChanged<String> onAmountChanged;
  final FormFieldValidator<String?> amountValidator;
  final ValueChanged<PaymentMethodType> onPaymentMethodTap;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: Center(
        child: Column(
          children: [
            _AmountCard(
              state: state,
              amountController: amountController,
              onAmountChanged: onAmountChanged,
              amountValidator: amountValidator,
            )
                .animate()
                .fadeIn(delay: 80.ms, duration: 350.ms)
                .slideY(begin: 0.12, end: 0, delay: 80.ms, duration: 400.ms, curve: Curves.easeOutCubic),

            context.uiHelper.verticalSpace(24),

            PaymentMethodCard(
              state: state,
              onPaymentMethodTap: onPaymentMethodTap,
            )
                .animate()
                .fadeIn(delay: 140.ms, duration: 350.ms)
                .slideY(begin: 0.12, end: 0, delay: 140.ms, duration: 400.ms, curve: Curves.easeOutCubic),

            context.uiHelper.verticalSpace(32),

            StepNextButton(
              label: 'Continue to Recipient',
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

class _AmountCard extends StatelessWidget {
  const _AmountCard({
    required this.state,
    required this.amountController,
    required this.onAmountChanged,
    required this.amountValidator,
  });

  final TransferFlowState state;
  final TextEditingController amountController;
  final ValueChanged<String> onAmountChanged;
  final FormFieldValidator<String?> amountValidator;

  @override
  Widget build(BuildContext context) {
    return WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How much are you sending?',
            style: context.appTextTheme.bodyNormal16Regular?.copyWith(
              color: AppColors.textColor,
            ),
          ),
          context.uiHelper.verticalSpace(8),
          Text(
            'Real-time market rates with zero hidden\nspreads.',
            style: context.appTextTheme.bodySmall14Regular?.copyWith(
              color: AppColors.textColor2,
            ),
          ),
          context.uiHelper.verticalSpace(23),

          _CurrencyAmountField(
            label: 'You Send',
            controller: amountController,
            validator: amountValidator,
            onChanged: onAmountChanged,
            currency: TransferFlowState.sendCurrency,
            flag: '🇺🇸',
            value: '',
          ),

          context.uiHelper.verticalSpace(24),

          BlocBuilder<TransferFlowCubit, TransferFlowState>(
            builder: (context, tState) {
              return _CurrencyAmountField(
                label: 'Recipient Gets',
                value: tState.formattedRecipientGets,
                currency: tState.recipientCurrency.code,
                flag: tState.recipientCurrency.flag,
                readOnly: true,
                selectedCurrency: tState.recipientCurrency,
                currencies: const [
                  TransferCurrency.rmb,
                  TransferCurrency.eur,
                  TransferCurrency.usd,
                ],
                onCurrencyChanged:
                context.read<TransferFlowCubit>().recipientCurrencyChanged,
              );
            },
          ),

          context.uiHelper.verticalSpace(24),
          _RateBreakdown(state: state),
        ],
      ),
    );
  }
}

class _CurrencyAmountField extends StatelessWidget {
  const _CurrencyAmountField({
    required this.label,
    required this.value,
    required this.currency,
    required this.flag,
    this.readOnly = false,
    this.controller,
    this.onChanged,
    this.validator,
    this.selectedCurrency,
    this.currencies = const [],
    this.onCurrencyChanged,
  });

  final String label;
  final String value;
  final String currency;
  final String flag;
  final bool readOnly;

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  final TransferCurrency? selectedCurrency;
  final List<TransferCurrency> currencies;
  final ValueChanged<TransferCurrency>? onCurrencyChanged;

  @override
  Widget build(BuildContext context) {
    final hasCurrencyDropdown =
        selectedCurrency != null && currencies.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.appTextTheme.bodySmall14Regular?.copyWith(
            color: AppColors.textColor2,
          ),
        ),

        context.uiHelper.verticalSpace(8),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.inputBorder.withAlpha(80),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: readOnly
                    ? Text(
                  value.isEmpty ? '0.00' : value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.appTextTheme.bodyNormal16Regular
                      ?.copyWith(
                    color: value.isEmpty ? AppColors.grey200 : AppColors.textColor,
                  ),
                )
                    : TextFormField(
                  controller: controller,
                  onChanged: onChanged,
                  validator: validator,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: context.appTextTheme.bodyNormal16Regular
                      ?.copyWith(
                    color: AppColors.textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration:  InputDecoration(
                    hint: Text('0.00',
                      style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                        color: AppColors.grey200,
                      ),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),

              context.uiHelper.horizontalSpace(12),

              SizedBox(
                width: 110,
                child: !hasCurrencyDropdown
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 6,
                  children: [
                    Text(flag,),

                    Text(
                      currency,
                      style: context.appTextTheme.bodySmall14Regular
                          ?.copyWith(
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                )
                    : CustomDropdown<TransferCurrency>(
                  value: selectedCurrency,
                  fillColor: AppColors.lightGrey,
                  selectedTextBuilder: (currency) {
                    return '${currency.flag} ${currency.code}';
                  },
                  menuItems: currencies.map((currency) {
                    return DropdownMenuItem<TransferCurrency>(
                      value: currency,
                      child: Text(
                        '${currency.flag} ${currency.code}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (currency) {
                    if (currency == null) return;
                    onCurrencyChanged?.call(currency);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CurrencyPill extends StatelessWidget {
  const _CurrencyPill({required this.flag, required this.currency});

  final String flag;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(flag),
          context.uiHelper.horizontalSpace(8),
          Text(
            currency,
            style: context.appTextTheme.bodySmall14Regular?.copyWith(
              color: AppColors.textColor,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _RateBreakdown extends StatelessWidget {
  const _RateBreakdown({required this.state});

  final TransferFlowState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: AppColors.secondaryColor, size: 14),
              context.uiHelper.horizontalSpace(10),
              Expanded(
                child: Text(
                  state.exchangeRateText,
                  style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                    color: AppColors.textColor2,
                  ),
                ),
              ),
              Text(
                state.guaranteedText,
                style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                  color: AppColors.secondaryColor,
                ),
              ),
            ],
          ),
          context.uiHelper.verticalSpace(12),
          const Divider(color: AppColors.white),
          context.uiHelper.verticalSpace(8),
          Row(
            children: [
              Text(
                'Transparent Fee',
                style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                  color: AppColors.textColor2,
                ),
              ),
              const Spacer(),
              Text(
                '\$${TransferFlowState.transparentFee.toStringAsFixed(2)} USD',
                style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}