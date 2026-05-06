

import 'package:flutter_test/flutter_test.dart';
import 'package:tupay/features/transfer/presentation/state_manager/transfer_flow_state.dart';



/// Creates a [TransferFlowIdle] pre-filled with [sendAmount] so we can drive
/// the conversion getters without standing up the full UI.
TransferFlowIdle _stateWith(String sendAmount) => TransferFlowIdle(
      step: TransferStep.amount,
      sendAmount: sendAmount,
      recipientName: '',
      recipientAccount: '',
      selectedPaymentMethod: PaymentMethodType.tupayBalance,
    );



void main() {
  group('Currency Conversion Logic', () {
    // Exchange rate is defined as a constant on TransferFlowState
    const rate = TransferFlowState.exchangeRate; // 0.9245

    test('converts a round number correctly', () {
      final state = _stateWith('1000');

      // Expected: 1000 × 0.9245 = 924.50
      final expected = (1000 * rate).toStringAsFixed(2);
      expect(state.formattedRecipientGets, equals(expected));
    });

    test('converts a decimal amount correctly', () {
      final state = _stateWith('250.50');

      final expected = (250.50 * rate).toStringAsFixed(2);
      expect(state.formattedRecipientGets, equals(expected));
    });

    test('returns empty string when amount is zero', () {
      final state = _stateWith('0');
      expect(state.formattedRecipientGets, equals(''));
    });

    test('returns empty string when amount is empty', () {
      final state = _stateWith('');
      expect(state.formattedRecipientGets, equals(''));
    });

    test('handles comma-formatted amounts (e.g. 1,000)', () {
      final state = _stateWith('1,000');

      // Parser strips commas before conversion
      final expected = (1000 * rate).toStringAsFixed(2);
      expect(state.formattedRecipientGets, equals(expected));
    });

    test('formattedRecipientGetsWithCurrency appends currency code', () {
      final state = _stateWith('500');

      const currency = TransferFlowState.recipientCurrency; // 'EUR'
      expect(
        state.formattedRecipientGetsWithCurrency,
        contains(currency),
      );
    });

    test('formattedRecipientGetsWithCurrency falls back to 0.00 for blank', () {
      final state = _stateWith('');
      expect(state.formattedRecipientGetsWithCurrency, startsWith('0.00'));
    });

    test('exchangeRateText is formatted correctly', () {
      final state = _stateWith('100');
      expect(
        state.exchangeRateText,
        equals(
          'Rate: 1 ${TransferFlowState.sendCurrency} = '
          '${rate.toStringAsFixed(4)} ${TransferFlowState.recipientCurrency}',
        ),
      );
    });

    test('formattedFee shows promo label when fee is zero', () {
      final state = _stateWith('200');
      expect(state.formattedFee, contains('Promo'));
    });

    test('formattedTotalToPay equals send amount when fee is zero', () {
      final state = _stateWith('750');

      // With zero fee, total = send amount
      expect(state.formattedTotalToPay, contains('750.00'));
    });

    test('formattedSending appends send currency code', () {
      final state = _stateWith('300');
      expect(
        state.formattedSending,
        endsWith(TransferFlowState.sendCurrency),
      );
    });

    test('large amounts are formatted with comma separators', () {
      final state = _stateWith('10000');

      // formattedSending should produce "10,000.00 USD"
      expect(state.formattedSending, contains('10,000.00'));
    });
  });
}
