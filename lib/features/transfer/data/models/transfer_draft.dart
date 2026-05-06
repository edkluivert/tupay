import 'package:tupay/features/transfer/data/models/transfer_currency.dart';
import 'package:tupay/features/transfer/presentation/state_manager/transfer_flow_state.dart';

class TransferDraft {
  const TransferDraft({
    required this.step,
    required this.sendAmount,
    required this.recipientName,
    required this.recipientAccount,
    required this.selectedPaymentMethod,
    required this.recipientCurrency,
    this.pendingTransactionId,
  });

  factory TransferDraft.fromJson(Map<String, dynamic> json) {
    final stepIndex = json['stepIndex'] as int? ?? 0;

    final safeStepIndex = stepIndex.clamp(
      0,
      TransferStep.values.length - 1,
    );

    return TransferDraft(
      step: TransferStep.values[safeStepIndex],
      sendAmount: json['sendAmount'] as String? ?? '1000',
      recipientName: json['recipientName'] as String? ?? '',
      recipientAccount: json['recipientAccount'] as String? ?? '',
      selectedPaymentMethod: _paymentMethodFromName(
        json['selectedPaymentMethod'] as String?,
      ),
      recipientCurrency: _currencyFromName(
        json['recipientCurrency'] as String?,
      ),
      pendingTransactionId: json['pendingTransactionId'] as String?,
    );
  }

  final TransferStep step;
  final String sendAmount;
  final String recipientName;
  final String recipientAccount;
  final PaymentMethodType selectedPaymentMethod;
  final TransferCurrency recipientCurrency;
  final String? pendingTransactionId;

  static PaymentMethodType _paymentMethodFromName(String? value) {
    return PaymentMethodType.values.firstWhere(
          (method) => method.name == value,
      orElse: () => PaymentMethodType.tupayBalance,
    );
  }

  static TransferCurrency _currencyFromName(String? value) {
    return TransferCurrency.values.firstWhere(
          (currency) => currency.name == value,
      orElse: () => TransferCurrency.rmb,
    );
  }
}