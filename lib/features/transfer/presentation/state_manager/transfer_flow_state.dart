import 'package:flutter/material.dart';

// ─── Enums ────────────────────────────────────────────────────────────────────

enum TransferStep { amount, recipient, review }

enum PaymentMethodType { tupayBalance, applePay, googlePay }

// ─── Supporting types ─────────────────────────────────────────────────────────

class PaymentMethodOption {
  const PaymentMethodOption({
    required this.type,
    required this.title,
    required this.subtitle,
  });

  final PaymentMethodType type;
  final String title;
  final String subtitle;
}

class MockContact {
  const MockContact({
    required this.name,
    required this.account,
    required this.bank,
    required this.initials,
    required this.color,
  });

  final String name;
  final String account;
  final String bank;
  final String initials;
  final Color color;
}



sealed class TransferFlowState {
  const TransferFlowState({
    required this.step,
    required this.sendAmount,
    required this.recipientName,
    required this.recipientAccount,
    required this.selectedPaymentMethod,
    this.message,
  });

  final TransferStep step;
  final String sendAmount;
  final String recipientName;
  final String recipientAccount;
  final PaymentMethodType selectedPaymentMethod;
  final String? message;



  static const String sendCurrency = 'USD';
  static const String recipientCurrency = 'EUR';


  static const double exchangeRate = 0.9245;


  static const double transparentFee = 0;

  static const double availableBalance = 12450;

  static const List<PaymentMethodOption> paymentMethods = [
    PaymentMethodOption(
      type: PaymentMethodType.tupayBalance,
      title: 'Tupay Balance',
      subtitle: r'$12,450.00 available',
    ),
    PaymentMethodOption(
      type: PaymentMethodType.applePay,
      title: 'Apple Pay',
      subtitle: 'Instant processing',
    ),
    PaymentMethodOption(
      type: PaymentMethodType.googlePay,
      title: 'Google Pay',
      subtitle: 'Secure checkout',
    ),
  ];

  static const List<MockContact> contacts = [
    MockContact(
      name: 'Alexander Roland',
      account: 'DE89 3704 0044 0532 0130 00',
      bank: 'Deutsche Bank',
      initials: 'AR',
      color: Color(0xFF1B6B45),
    ),
    MockContact(
      name: 'Sarah Johnson',
      account: 'GB29 NWBK 6016 1331 9268 19',
      bank: 'Natwest UK',
      initials: 'SJ',
      color: Color(0xFF3B6CB7),
    ),
    MockContact(
      name: 'David Okafor',
      account: 'NG50 0690 0000 0001 2345 67',
      bank: 'Access Bank',
      initials: 'DO',
      color: Color(0xFFB84A4A),
    ),
    MockContact(
      name: 'Mei Lin Zhang',
      account: 'HK12 3456 7890 1234 5678',
      bank: 'HSBC Hong Kong',
      initials: 'ML',
      color: Color(0xFF7B5EA7),
    ),
    MockContact(
      name: 'James Williams',
      account: 'US42 0000 1234 5678 9012',
      bank: 'Chase Bank',
      initials: 'JW',
      color: Color(0xFFD97706),
    ),
    MockContact(
      name: 'Amina Hassan',
      account: 'AE07 0331 2345 6789 0123 456',
      bank: 'Emirates NBD',
      initials: 'AH',
      color: Color(0xFF0E7490),
    ),
  ];


  double get _parsedAmount =>
      double.tryParse(sendAmount.replaceAll(',', '').trim()) ?? 0.0;


  String get formattedRecipientGets {
    if (_parsedAmount == 0) return '';
    final converted = _parsedAmount * exchangeRate;
    return converted.toStringAsFixed(2);
  }

  String get exchangeRateText =>
      'Rate: 1 $sendCurrency = ${exchangeRate.toStringAsFixed(4)} $recipientCurrency';

  String get guaranteedText => 'Guaranteed\nfor 2h';

  String get formattedSending =>
      '${_formatAmount(_parsedAmount)} $sendCurrency';

  String get formattedFee => transparentFee == 0
      ? '0.00 $sendCurrency (Promo)'
      : '\$${transparentFee.toStringAsFixed(2)} $sendCurrency';

  String get formattedTotalToPay =>
      '${_formatAmount(_parsedAmount + transparentFee)} $sendCurrency';

  String get formattedRecipientGetsWithCurrency =>
      '${formattedRecipientGets.isEmpty ? "0.00" : formattedRecipientGets} $recipientCurrency';



  bool get isLoading => this is TransferFlowSubmitting;
  bool get isFailure => this is TransferFlowFailure;
  bool get isSuccess => this is TransferFlowSuccess;

  bool get canProceedFromAmount =>
      _parsedAmount > 0 && _parsedAmount <= availableBalance;

  bool get canProceedFromRecipient =>
      recipientName.trim().length >= 3 && recipientAccount.trim().length >= 8;

  bool get canSubmit => canProceedFromAmount && canProceedFromRecipient;

  bool get isLastStep => step == TransferStep.review;
  bool get isFirstStep => step == TransferStep.amount;

  // ─── Helpers ───────────────────────────────────────────────────────────────

  static String _formatAmount(double value) {
    // Format with comma separator, e.g. 1000.00 → "1,000.00"
    final parts = value.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];
    final buffer = StringBuffer();
    for (var i = 0; i < intPart.length; i++) {
      if (i != 0 && (intPart.length - i) % 3 == 0) buffer.write(',');
      buffer.write(intPart[i]);
    }
    return '$buffer.$decPart';
  }

  // ─── copyWith ──────────────────────────────────────────────────────────────

  TransferFlowState copyWith({
    TransferStep? step,
    String? sendAmount,
    String? recipientName,
    String? recipientAccount,
    PaymentMethodType? selectedPaymentMethod,
    bool clearMessage = false,
    String? message,
  });
}

// ─── Concrete subclasses ──────────────────────────────────────────────────────

final class TransferFlowInitial extends TransferFlowState {
  const TransferFlowInitial()
      : super(
    step: TransferStep.amount,
    sendAmount: '1000',
    recipientName: '',
    recipientAccount: '',
    selectedPaymentMethod: PaymentMethodType.tupayBalance,
  );

  @override
  TransferFlowState copyWith({
    TransferStep? step,
    String? sendAmount,
    String? recipientName,
    String? recipientAccount,
    PaymentMethodType? selectedPaymentMethod,
    bool clearMessage = false,
    String? message,
  }) =>
      TransferFlowIdle(
        step: step ?? this.step,
        sendAmount: sendAmount ?? this.sendAmount,
        recipientName: recipientName ?? this.recipientName,
        recipientAccount: recipientAccount ?? this.recipientAccount,
        selectedPaymentMethod:
        selectedPaymentMethod ?? this.selectedPaymentMethod,
        message: clearMessage ? null : (message ?? this.message),
      );
}

final class TransferFlowIdle extends TransferFlowState {
  const TransferFlowIdle({
    required super.step,
    required super.sendAmount,
    required super.recipientName,
    required super.recipientAccount,
    required super.selectedPaymentMethod,
    super.message,
  });

  @override
  TransferFlowState copyWith({
    TransferStep? step,
    String? sendAmount,
    String? recipientName,
    String? recipientAccount,
    PaymentMethodType? selectedPaymentMethod,
    bool clearMessage = false,
    String? message,
  }) =>
      TransferFlowIdle(
        step: step ?? this.step,
        sendAmount: sendAmount ?? this.sendAmount,
        recipientName: recipientName ?? this.recipientName,
        recipientAccount: recipientAccount ?? this.recipientAccount,
        selectedPaymentMethod:
        selectedPaymentMethod ?? this.selectedPaymentMethod,
        message: clearMessage ? null : (message ?? this.message),
      );
}

final class TransferFlowSubmitting extends TransferFlowState {
  const TransferFlowSubmitting({
    required super.step,
    required super.sendAmount,
    required super.recipientName,
    required super.recipientAccount,
    required super.selectedPaymentMethod,
  });

  @override
  TransferFlowState copyWith({
    TransferStep? step,
    String? sendAmount,
    String? recipientName,
    String? recipientAccount,
    PaymentMethodType? selectedPaymentMethod,
    bool clearMessage = false,
    String? message,
  }) =>
      TransferFlowSubmitting(
        step: step ?? this.step,
        sendAmount: sendAmount ?? this.sendAmount,
        recipientName: recipientName ?? this.recipientName,
        recipientAccount: recipientAccount ?? this.recipientAccount,
        selectedPaymentMethod:
        selectedPaymentMethod ?? this.selectedPaymentMethod,
      );
}

final class TransferFlowSuccess extends TransferFlowState {
  const TransferFlowSuccess({
    required super.step,
    required super.sendAmount,
    required super.recipientName,
    required super.recipientAccount,
    required super.selectedPaymentMethod,
    super.message,
  });

  @override
  TransferFlowState copyWith({
    TransferStep? step,
    String? sendAmount,
    String? recipientName,
    String? recipientAccount,
    PaymentMethodType? selectedPaymentMethod,
    bool clearMessage = false,
    String? message,
  }) =>
      TransferFlowSuccess(
        step: step ?? this.step,
        sendAmount: sendAmount ?? this.sendAmount,
        recipientName: recipientName ?? this.recipientName,
        recipientAccount: recipientAccount ?? this.recipientAccount,
        selectedPaymentMethod:
        selectedPaymentMethod ?? this.selectedPaymentMethod,
        message: clearMessage ? null : (message ?? this.message),
      );
}

final class TransferFlowFailure extends TransferFlowState {
  const TransferFlowFailure({
    required super.step,
    required super.sendAmount,
    required super.recipientName,
    required super.recipientAccount,
    required super.selectedPaymentMethod,
    super.message,
  });

  @override
  TransferFlowState copyWith({
    TransferStep? step,
    String? sendAmount,
    String? recipientName,
    String? recipientAccount,
    PaymentMethodType? selectedPaymentMethod,
    bool clearMessage = false,
    String? message,
  }) =>
      TransferFlowFailure(
        step: step ?? this.step,
        sendAmount: sendAmount ?? this.sendAmount,
        recipientName: recipientName ?? this.recipientName,
        recipientAccount: recipientAccount ?? this.recipientAccount,
        selectedPaymentMethod:
        selectedPaymentMethod ?? this.selectedPaymentMethod,
        message: clearMessage ? null : (message ?? this.message),
      );
}