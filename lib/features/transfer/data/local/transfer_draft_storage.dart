import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tupay/features/transfer/data/models/transfer_currency.dart';
import 'package:tupay/features/transfer/presentation/state_manager/transfer_flow_state.dart';

class TransferDraftStorage {
  const TransferDraftStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _keyPrefix = 'transfer_draft';

  String _keyForUser(String userId) => '$_keyPrefix.$userId';

  Future<void> save({
    required String userId,
    required TransferFlowState state,
  }) async {
    final payload = {
      'stepIndex': state.step.index,
      'sendAmount': state.sendAmount,
      'recipientName': state.recipientName,
      'recipientAccount': state.recipientAccount,
      'selectedPaymentMethod': state.selectedPaymentMethod.name,
      'recipientCurrency': state.recipientCurrency.name,
      'pendingTransactionId': state.pendingTransactionId,
      'updatedAt': DateTime.now().toIso8601String(),
    };

    await _storage.write(
      key: _keyForUser(userId),
      value: jsonEncode(payload),
    );
  }

  Future<TransferDraft?> read(String userId) async {
    final raw = await _storage.read(key: _keyForUser(userId));
    if (raw == null || raw.isEmpty) return null;

    final decoded = jsonDecode(raw);

    if (decoded is! Map<String, dynamic>) return null;

    return TransferDraft.fromJson(decoded);
  }

  Future<void> clear(String userId) async {
    await _storage.delete(key: _keyForUser(userId));
  }
}

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

  final TransferStep step;
  final String sendAmount;
  final String recipientName;
  final String recipientAccount;
  final PaymentMethodType selectedPaymentMethod;
  final TransferCurrency recipientCurrency;
  final String? pendingTransactionId;

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