import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tupay/core/injections/injection.dart';
import 'package:tupay/features/transfer/presentation/state_manager/transfer_flow_state.dart';

class TransferFlowCubit extends Cubit<TransferFlowState> {
  TransferFlowCubit() : super(const TransferFlowInitial());



  void sendAmountChanged(String value) {
    emit(state.copyWith(sendAmount: value, clearMessage: true));
  }

  void recipientNameChanged(String value) {
    emit(state.copyWith(recipientName: value, clearMessage: true));
  }

  void recipientAccountChanged(String value) {
    emit(state.copyWith(recipientAccount: value, clearMessage: true));
  }

  void paymentMethodChanged(PaymentMethodType method) {
    emit(state.copyWith(selectedPaymentMethod: method, clearMessage: true));
  }



  void selectContact(MockContact contact) {
    emit(state.copyWith(
      recipientName: contact.name,
      recipientAccount: contact.account,
      clearMessage: true,
    ));
  }


  void selectMockContact() {
    selectContact(TransferFlowState.contacts.first);
  }


  bool nextStep() {
    switch (state.step) {
      case TransferStep.amount:
        final error = validateAmount(state.sendAmount);
        if (error != null) {
          emit(TransferFlowFailure(
            step: state.step,
            sendAmount: state.sendAmount,
            recipientName: state.recipientName,
            recipientAccount: state.recipientAccount,
            selectedPaymentMethod: state.selectedPaymentMethod,
            message: error,
          ));
          return false;
        }
        emit(state.copyWith(step: TransferStep.recipient, clearMessage: true));
        return true;

      case TransferStep.recipient:
        final nameError = validateRecipientName(state.recipientName);
        final accountError = validateRecipientAccount(state.recipientAccount);
        final error = nameError ?? accountError;
        if (error != null) {
          emit(TransferFlowFailure(
            step: state.step,
            sendAmount: state.sendAmount,
            recipientName: state.recipientName,
            recipientAccount: state.recipientAccount,
            selectedPaymentMethod: state.selectedPaymentMethod,
            message: error,
          ));
          return false;
        }
        emit(state.copyWith(step: TransferStep.review, clearMessage: true));
        return true;

      case TransferStep.review:

        return false;
    }
  }


  void previousStep() {
    switch (state.step) {
      case TransferStep.amount:
        break;
      case TransferStep.recipient:
        emit(state.copyWith(step: TransferStep.amount, clearMessage: true));
      case TransferStep.review:
        emit(state.copyWith(step: TransferStep.recipient, clearMessage: true));
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

    emit(state.copyWith(step: targetStep, clearMessage: true));
  }


  void restoreFlow({
    required TransferStep step,
    required String sendAmount,
    required String recipientName,
    required String recipientAccount,
  }) {
    emit(
      state.copyWith(
        step: step,
        sendAmount: sendAmount,
        recipientName: recipientName,
        recipientAccount: recipientAccount,
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
      emit(TransferFlowFailure(
        step: state.step,
        sendAmount: state.sendAmount,
        recipientName: state.recipientName,
        recipientAccount: state.recipientAccount,
        selectedPaymentMethod: state.selectedPaymentMethod,
        message: firstError,
      ));
      return;
    }

    emit(TransferFlowSubmitting(
      step: TransferStep.review,
      sendAmount: state.sendAmount,
      recipientName: state.recipientName,
      recipientAccount: state.recipientAccount,
      selectedPaymentMethod: state.selectedPaymentMethod,
    ));

    await Future<void>.delayed(const Duration(milliseconds: 1400));

    if (isClosed) return;

    // Mock securely storing a transaction ID
    final txId = 'tx_${DateTime.now().millisecondsSinceEpoch}';
    await sl<FlutterSecureStorage>().write(key: 'last_tx_id', value: txId);

    emit(TransferFlowSuccess(
      step: TransferStep.review,
      sendAmount: state.sendAmount,
      recipientName: state.recipientName,
      recipientAccount: state.recipientAccount,
      selectedPaymentMethod: state.selectedPaymentMethod,
      message: 'Transfer submitted successfully.',
    ));
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