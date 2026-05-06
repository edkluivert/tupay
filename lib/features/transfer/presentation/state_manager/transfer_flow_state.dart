import 'package:flutter/material.dart';
import 'package:tupay/core/injections/injection.dart';
import 'package:tupay/core/services/current_user_service.dart';
import 'package:tupay/features/transfer/data/models/transfer_currency.dart';

enum TransferStep { amount, recipient, review }

enum PaymentMethodType { tupayBalance, applePay, googlePay }

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
    required this.recipientCurrency,
    this.pendingTransactionId,
    this.message,
  });

  final TransferStep step;
  final String sendAmount;
  final String recipientName;
  final String recipientAccount;
  final PaymentMethodType selectedPaymentMethod;
  final TransferCurrency recipientCurrency;
  final String? pendingTransactionId;
  final String? message;

  static const String sendCurrency = 'USD';
  static const double transparentFee = 0;

  static double get availableBalance {
    final user = sl<CurrentUserService>().currentUser;
    if (user == null) return 0;

    return double.tryParse(
      user.totalBalance.replaceAll(',', '').trim(),
    ) ??
        0.0;
  }

  static List<PaymentMethodOption> get paymentMethods {
    final balance = availableBalance;
    final formattedBalance = _formatAmount(balance);

    return [
      PaymentMethodOption(
        type: PaymentMethodType.tupayBalance,
        title: 'Tupay Balance',
        subtitle: '\$$formattedBalance available',
      ),
      const PaymentMethodOption(
        type: PaymentMethodType.applePay,
        title: 'Apple Pay',
        subtitle: 'Instant processing',
      ),
      const PaymentMethodOption(
        type: PaymentMethodType.googlePay,
        title: 'Google Pay',
        subtitle: 'Secure checkout',
      ),
    ];
  }

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

  double get exchangeRate => recipientCurrency.rateFromUsd;

  double get _parsedAmount {
    return double.tryParse(
      sendAmount.replaceAll(',', '').trim(),
    ) ??
        0.0;
  }

  String get formattedRecipientGets {
    if (_parsedAmount == 0) return '';

    final converted = _parsedAmount * exchangeRate;
    return _formatAmount(converted);
  }

  String get exchangeRateText {
    return 'Rate: 1 $sendCurrency = ${exchangeRate.toStringAsFixed(4)} ${recipientCurrency.code}';
  }

  String get guaranteedText => 'Guaranteed\nfor 2h';

  String get formattedSending {
    return '${_formatAmount(_parsedAmount)} $sendCurrency';
  }

  String get formattedFee {
    return transparentFee == 0
        ? '0.00 $sendCurrency (Promo)'
        : '\$${transparentFee.toStringAsFixed(2)} $sendCurrency';
  }

  String get formattedTotalToPay {
    return '${_formatAmount(_parsedAmount + transparentFee)} $sendCurrency';
  }

  String get formattedRecipientGetsWithCurrency {
    final value = formattedRecipientGets.isEmpty ? '0.00' : formattedRecipientGets;
    return '$value ${recipientCurrency.code}';
  }

  bool get isLoading => this is TransferFlowSubmitting;
  bool get isFailure => this is TransferFlowFailure;
  bool get isSuccess => this is TransferFlowSuccess;

  bool get canProceedFromAmount {
    return _parsedAmount > 0 && _parsedAmount <= availableBalance;
  }

  bool get canProceedFromRecipient {
    return recipientName.trim().length >= 3 &&
        recipientAccount.trim().length >= 8;
  }

  bool get canSubmit => canProceedFromAmount && canProceedFromRecipient;

  bool get isLastStep => step == TransferStep.review;
  bool get isFirstStep => step == TransferStep.amount;

  static String _formatAmount(double value) {
    final parts = value.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];

    final buffer = StringBuffer();

    for (var i = 0; i < intPart.length; i++) {
      if (i != 0 && (intPart.length - i) % 3 == 0) {
        buffer.write(',');
      }

      buffer.write(intPart[i]);
    }

    return '$buffer.$decPart';
  }

  TransferFlowState copyWith({
    TransferStep? step,
    String? sendAmount,
    String? recipientName,
    String? recipientAccount,
    PaymentMethodType? selectedPaymentMethod,
    TransferCurrency? recipientCurrency,
    String? pendingTransactionId,
    bool clearPendingTransactionId = false,
    bool clearMessage = false,
    String? message,
  });
}

final class TransferFlowInitial extends TransferFlowState {
  const TransferFlowInitial()
      : super(
    step: TransferStep.amount,
    sendAmount: '',
    recipientName: '',
    recipientAccount: '',
    selectedPaymentMethod: PaymentMethodType.tupayBalance,
    recipientCurrency: TransferCurrency.rmb,
  );

  @override
  TransferFlowState copyWith({
    TransferStep? step,
    String? sendAmount,
    String? recipientName,
    String? recipientAccount,
    PaymentMethodType? selectedPaymentMethod,
    TransferCurrency? recipientCurrency,
    String? pendingTransactionId,
    bool clearPendingTransactionId = false,
    bool clearMessage = false,
    String? message,
  }) {
    return TransferFlowIdle(
      step: step ?? this.step,
      sendAmount: sendAmount ?? this.sendAmount,
      recipientName: recipientName ?? this.recipientName,
      recipientAccount: recipientAccount ?? this.recipientAccount,
      selectedPaymentMethod:
      selectedPaymentMethod ?? this.selectedPaymentMethod,
      recipientCurrency: recipientCurrency ?? this.recipientCurrency,
      pendingTransactionId: clearPendingTransactionId
          ? null
          : pendingTransactionId ?? this.pendingTransactionId,
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}

final class TransferFlowIdle extends TransferFlowState {
  const TransferFlowIdle({
    required super.step,
    required super.sendAmount,
    required super.recipientName,
    required super.recipientAccount,
    required super.selectedPaymentMethod,
    required super.recipientCurrency,
    super.pendingTransactionId,
    super.message,
  });

  @override
  TransferFlowState copyWith({
    TransferStep? step,
    String? sendAmount,
    String? recipientName,
    String? recipientAccount,
    PaymentMethodType? selectedPaymentMethod,
    TransferCurrency? recipientCurrency,
    String? pendingTransactionId,
    bool clearPendingTransactionId = false,
    bool clearMessage = false,
    String? message,
  }) {
    return TransferFlowIdle(
      step: step ?? this.step,
      sendAmount: sendAmount ?? this.sendAmount,
      recipientName: recipientName ?? this.recipientName,
      recipientAccount: recipientAccount ?? this.recipientAccount,
      selectedPaymentMethod:
      selectedPaymentMethod ?? this.selectedPaymentMethod,
      recipientCurrency: recipientCurrency ?? this.recipientCurrency,
      pendingTransactionId: clearPendingTransactionId
          ? null
          : pendingTransactionId ?? this.pendingTransactionId,
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}

final class TransferFlowSubmitting extends TransferFlowState {
  const TransferFlowSubmitting({
    required super.step,
    required super.sendAmount,
    required super.recipientName,
    required super.recipientAccount,
    required super.selectedPaymentMethod,
    required super.recipientCurrency,
    super.pendingTransactionId,
  });

  @override
  TransferFlowState copyWith({
    TransferStep? step,
    String? sendAmount,
    String? recipientName,
    String? recipientAccount,
    PaymentMethodType? selectedPaymentMethod,
    TransferCurrency? recipientCurrency,
    String? pendingTransactionId,
    bool clearPendingTransactionId = false,
    bool clearMessage = false,
    String? message,
  }) {
    return TransferFlowSubmitting(
      step: step ?? this.step,
      sendAmount: sendAmount ?? this.sendAmount,
      recipientName: recipientName ?? this.recipientName,
      recipientAccount: recipientAccount ?? this.recipientAccount,
      selectedPaymentMethod:
      selectedPaymentMethod ?? this.selectedPaymentMethod,
      recipientCurrency: recipientCurrency ?? this.recipientCurrency,
      pendingTransactionId: clearPendingTransactionId
          ? null
          : pendingTransactionId ?? this.pendingTransactionId,
    );
  }
}

final class TransferFlowSuccess extends TransferFlowState {
  const TransferFlowSuccess({
    required super.step,
    required super.sendAmount,
    required super.recipientName,
    required super.recipientAccount,
    required super.selectedPaymentMethod,
    required super.recipientCurrency,
    super.pendingTransactionId,
    super.message,
  });


  @override
  TransferFlowState copyWith({
    TransferStep? step,
    String? sendAmount,
    String? recipientName,
    String? recipientAccount,
    PaymentMethodType? selectedPaymentMethod,
    TransferCurrency? recipientCurrency,
    String? pendingTransactionId,
    bool clearPendingTransactionId = false,
    bool clearMessage = false,
    String? message,
  }) {
    return TransferFlowIdle(
      step: step ?? this.step,
      sendAmount: sendAmount ?? this.sendAmount,
      recipientName: recipientName ?? this.recipientName,
      recipientAccount: recipientAccount ?? this.recipientAccount,
      selectedPaymentMethod:
      selectedPaymentMethod ?? this.selectedPaymentMethod,
      recipientCurrency: recipientCurrency ?? this.recipientCurrency,
      pendingTransactionId: clearPendingTransactionId
          ? null
          : pendingTransactionId ?? this.pendingTransactionId,
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}

final class TransferFlowFailure extends TransferFlowState {
  const TransferFlowFailure({
    required super.step,
    required super.sendAmount,
    required super.recipientName,
    required super.recipientAccount,
    required super.selectedPaymentMethod,
    required super.recipientCurrency,
    super.pendingTransactionId,
    super.message,
  });

  @override
  TransferFlowState copyWith({
    TransferStep? step,
    String? sendAmount,
    String? recipientName,
    String? recipientAccount,
    PaymentMethodType? selectedPaymentMethod,
    TransferCurrency? recipientCurrency,
    String? pendingTransactionId,
    bool clearPendingTransactionId = false,
    bool clearMessage = false,
    String? message,
  }) {
    return TransferFlowIdle(
      step: step ?? this.step,
      sendAmount: sendAmount ?? this.sendAmount,
      recipientName: recipientName ?? this.recipientName,
      recipientAccount: recipientAccount ?? this.recipientAccount,
      selectedPaymentMethod:
      selectedPaymentMethod ?? this.selectedPaymentMethod,
      recipientCurrency: recipientCurrency ?? this.recipientCurrency,
      pendingTransactionId: clearPendingTransactionId
          ? null
          : pendingTransactionId ?? this.pendingTransactionId,
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}