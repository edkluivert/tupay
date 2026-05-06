import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tupay/features/transfer/data/models/transfer_draft.dart';
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

