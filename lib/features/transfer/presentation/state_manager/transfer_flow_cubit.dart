import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tupay/core/injections/injection.dart';
import 'package:tupay/core/services/current_user_service.dart';
import 'package:tupay/features/transfer/data/local/transfer_draft_storage.dart';
import 'package:tupay/features/transfer/data/models/transfer_currency.dart';
import 'package:tupay/features/transfer/presentation/state_manager/transfer_flow_state.dart';

class TransferFlowCubit extends Cubit<TransferFlowState> {
  TransferFlowCubit({
    TransferDraftStorage? draftStorage,
    CurrentUserService? currentUserService,
  })  : _draftStorage = draftStorage ?? sl<TransferDraftStorage>(),
        _currentUserService = currentUserService ?? sl<CurrentUserService>(),
        super(const TransferFlowInitial());

  final TransferDraftStorage _draftStorage;
  final CurrentUserService _currentUserService;

  String? get _currentUserId => _currentUserService.currentUser?.id;

  Future<void> loadSavedDraft() async {
    final userId = _currentUserId;
    if (userId == null) return;

    final draft = await _draftStorage.read(userId);
    if (draft == null || isClosed) return;

    emit(
      state.copyWith(
        step: draft.step,
        sendAmount: draft.sendAmount,
        recipientName: draft.recipientName,
        recipientAccount: draft.recipientAccount,
        selectedPaymentMethod: draft.selectedPaymentMethod,
        recipientCurrency: draft.recipientCurrency,
        pendingTransactionId: draft.pendingTransactionId,
        clearMessage: true,
      ),
    );
  }

  void _emitAndSave(TransferFlowState nextState) {
    emit(nextState);
    unawaited(_saveDraft(nextState));
  }

  Future<void> _saveDraft(TransferFlowState draftState) async {
    final userId = _currentUserId;
    if (userId == null) return;

    await _draftStorage.save(
      userId: userId,
      state: draftState,
    );
  }

  Future<void> _clearDraft() async {
    final userId = _currentUserId;
    if (userId == null) return;

    await _draftStorage.clear(userId);
  }

  void sendAmountChanged(String value) {
    _emitAndSave(
      state.copyWith(
        sendAmount: value,
        clearMessage: true,
      ),
    );
  }

  void recipientNameChanged(String value) {
    _emitAndSave(
      state.copyWith(
        recipientName: value,
        clearMessage: true,
      ),
    );
  }

  void recipientAccountChanged(String value) {
    _emitAndSave(
      state.copyWith(
        recipientAccount: value,
        clearMessage: true,

      ),
    );
  }

  void recipientCurrencyChanged(TransferCurrency currency) {
    _emitAndSave(
      state.copyWith(
        recipientCurrency: currency,
        clearMessage: true,
      ),
    );
  }

  void paymentMethodChanged(PaymentMethodType method) {
    _emitAndSave(
      state.copyWith(
        selectedPaymentMethod: method,
        clearMessage: true,
      ),
    );
  }

  void selectContact(MockContact contact) {
    _emitAndSave(
      state.copyWith(
        recipientName: contact.name,
        recipientAccount: contact.account,
        clearMessage: true,
      ),
    );
  }

  void selectMockContact() {
    selectContact(TransferFlowState.contacts.first);
  }

  bool nextStep() {
    switch (state.step) {
      case TransferStep.amount:
        final error = validateAmount(state.sendAmount);

        if (error != null) {
          emit(
            TransferFlowFailure(
              step: state.step,
              sendAmount: state.sendAmount,
              recipientName: state.recipientName,
              recipientAccount: state.recipientAccount,
              selectedPaymentMethod: state.selectedPaymentMethod,
              recipientCurrency: state.recipientCurrency,
              pendingTransactionId: state.pendingTransactionId,
              message: error,
            ),
          );
          return false;
        }

        _emitAndSave(
          state.copyWith(
            step: TransferStep.recipient,
            clearMessage: true,
          ),
        );

        return true;

      case TransferStep.recipient:
        final nameError = validateRecipientName(state.recipientName);
        final accountError = validateRecipientAccount(state.recipientAccount);
        final error = nameError ?? accountError;

        if (error != null) {
          emit(
            TransferFlowFailure(
              step: state.step,
              sendAmount: state.sendAmount,
              recipientName: state.recipientName,
              recipientAccount: state.recipientAccount,
              selectedPaymentMethod: state.selectedPaymentMethod,
              recipientCurrency: state.recipientCurrency,
              pendingTransactionId: state.pendingTransactionId,
              message: error,
            ),
          );
          return false;
        }

        _emitAndSave(
          state.copyWith(
            step: TransferStep.review,
            clearMessage: true,
          ),
        );

        return true;

      case TransferStep.review:
        return false;
    }
  }

  void previousStep() {
    switch (state.step) {
      case TransferStep.amount:
        return;

      case TransferStep.recipient:
        _emitAndSave(
          state.copyWith(
            step: TransferStep.amount,
            clearMessage: true,
          ),
        );
        return;

      case TransferStep.review:
        _emitAndSave(
          state.copyWith(
            step: TransferStep.recipient,
            clearMessage: true,
          ),
        );
        return;
    }
  }

  void stepChanged(TransferStep targetStep) {
    if (targetStep == state.step) return;

    if (targetStep.index > state.step.index) {
      while (state.step.index < targetStep.index) {
        final advanced = nextStep();
        if (!advanced) return;
      }

      return;
    }

    _emitAndSave(
      state.copyWith(
        step: targetStep,
        clearMessage: true,
      ),
    );
  }

  void restoreFlow({
    required TransferStep step,
    required String sendAmount,
    required String recipientName,
    required String recipientAccount,
    required TransferCurrency recipientCurrency,
    PaymentMethodType selectedPaymentMethod = PaymentMethodType.tupayBalance,
    String? pendingTransactionId,
  }) {
    _emitAndSave(
      state.copyWith(
        step: step,
        sendAmount: sendAmount,
        recipientName: recipientName,
        recipientAccount: recipientAccount,
        selectedPaymentMethod: selectedPaymentMethod,
        recipientCurrency: recipientCurrency,
        pendingTransactionId: pendingTransactionId,
        clearMessage: true,
      ),
    );
  }

  Future<void> reviewAndSend() async {
    final amountError = validateAmount(state.sendAmount);
    final nameError = validateRecipientName(state.recipientName);
    final accountError = validateRecipientAccount(state.recipientAccount);
    final firstError = amountError ?? nameError ?? accountError;

    if (firstError != null) {
      emit(
        TransferFlowFailure(
          step: state.step,
          sendAmount: state.sendAmount,
          recipientName: state.recipientName,
          recipientAccount: state.recipientAccount,
          selectedPaymentMethod: state.selectedPaymentMethod,
          recipientCurrency: state.recipientCurrency,
          pendingTransactionId: state.pendingTransactionId,
          message: firstError,
        ),
      );
      return;
    }

    final txId =
        state.pendingTransactionId ?? 'tx_${DateTime.now().millisecondsSinceEpoch}';

    final submittingState = TransferFlowSubmitting(
      step: TransferStep.review,
      sendAmount: state.sendAmount,
      recipientName: state.recipientName,
      recipientAccount: state.recipientAccount,
      selectedPaymentMethod: state.selectedPaymentMethod,
      recipientCurrency: state.recipientCurrency,
      pendingTransactionId: txId,
    );

    emit(submittingState);
    await _saveDraft(submittingState);

    await Future<void>.delayed(const Duration(milliseconds: 1400));

    if (isClosed) return;

    await _clearDraft();

    emit(
      const TransferFlowSuccess(
        step: TransferStep.amount,
        sendAmount: '',
        recipientName: '',
        recipientAccount: '',
        selectedPaymentMethod: PaymentMethodType.tupayBalance,
        recipientCurrency: TransferCurrency.rmb,
        message: 'Transfer submitted successfully.',
      ),
    );
  }

  String? validateAmount(String? value) {
    final amount =
        double.tryParse((value ?? '').replaceAll(',', '').trim()) ?? 0;

    if (amount <= 0) return 'Enter an amount to send.';

    if (amount > TransferFlowState.availableBalance) {
      return 'Amount exceeds your Tupay balance.';
    }

    return null;
  }

  String? validateRecipientName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) return 'Enter recipient full name.';
    if (name.length < 3) return 'Recipient name is too short.';

    return null;
  }

  String? validateRecipientAccount(String? value) {
    final account = value?.trim() ?? '';

    if (account.isEmpty) return 'Enter IBAN or account number.';
    if (account.length < 8) return 'Enter a valid IBAN or account number.';

    return null;
  }
}