

import 'package:flutter_test/flutter_test.dart';
import 'package:tupay/features/transfer/presentation/state_manager/transfer_flow_state.dart';



/// Creates a [TransferFlowIdle] pre-filled with [sendAmount] so we can drive
/// the conversion getters without standing up the full UI.
import 'package:flutter_test/flutter_test.dart';
import 'package:tupay/features/transfer/data/models/transfer_currency.dart';
import 'package:tupay/features/transfer/presentation/state_manager/transfer_flow_state.dart';

TransferFlowIdle _stateWith(
    String sendAmount, {
      TransferCurrency recipientCurrency = TransferCurrency.rmb,
    }) {
  return TransferFlowIdle(
    step: TransferStep.amount,
    sendAmount: sendAmount,
    recipientName: '',
    recipientAccount: '',
    selectedPaymentMethod: PaymentMethodType.tupayBalance,
    recipientCurrency: recipientCurrency,
  );
}

void main() {
  group('Currency Conversion Logic', () {
    test('converts USD to RMB correctly', () {
      final state = _stateWith(
        '1000',
      );

      final expected =
      (1000 * TransferCurrency.rmb.rateFromUsd).toStringAsFixed(2);

      expect(state.formattedRecipientGets, equals(expected));
      expect(state.formattedRecipientGetsWithCurrency, equals('$expected RMB'));
    });

    test('converts USD to EUR correctly', () {
      final state = _stateWith(
        '1000',
        recipientCurrency: TransferCurrency.eur,
      );

      final expected =
      (1000 * TransferCurrency.eur.rateFromUsd).toStringAsFixed(2);

      expect(state.formattedRecipientGets, equals(expected));
      expect(state.formattedRecipientGetsWithCurrency, equals('$expected EUR'));
    });

    test('converts USD to USD correctly', () {
      final state = _stateWith(
        '1000',
        recipientCurrency: TransferCurrency.usd,
      );

      final expected =
      (1000 * TransferCurrency.usd.rateFromUsd).toStringAsFixed(2);

      expect(state.formattedRecipientGets, equals(expected));
      expect(state.formattedRecipientGetsWithCurrency, equals('$expected USD'));
    });


    test('converts a decimal amount correctly', () {
      final state = _stateWith(
        '250.50',
      );

      final expected =
      (250.50 * TransferCurrency.rmb.rateFromUsd).toStringAsFixed(2);

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

    test('returns empty string when amount is invalid', () {
      final state = _stateWith('abc');

      expect(state.formattedRecipientGets, equals(''));
    });

    test('handles comma-formatted amounts correctly', () {
      final state = _stateWith(
        '1,000',
      );

      final expected = (1000 * TransferCurrency.rmb.rateFromUsd).toStringAsFixed(2);

      expect(state.formattedRecipientGets, equals(expected));
    });

    test('formattedRecipientGetsWithCurrency appends RMB currency code', () {
      final state = _stateWith(
        '500',
      );

      expect(state.formattedRecipientGetsWithCurrency, endsWith('RMB'));
    });

    test('formattedRecipientGetsWithCurrency appends USD currency code', () {
      final state = _stateWith(
        '500',
        recipientCurrency: TransferCurrency.usd,
      );

      expect(state.formattedRecipientGetsWithCurrency, endsWith('USD'));
    });

    test('formattedRecipientGetsWithCurrency falls back to 0.00 for blank amount', () {
      final state = _stateWith(
        '',
      );

      expect(state.formattedRecipientGetsWithCurrency, equals('0.00 RMB'));
    });

    test('exchangeRateText is formatted correctly for RMB', () {
      final state = _stateWith(
        '100',
      );

      expect(
        state.exchangeRateText,
        equals(
          'Rate: 1 ${TransferFlowState.sendCurrency} = '
              '${TransferCurrency.rmb.rateFromUsd.toStringAsFixed(4)} RMB',
        ),
      );
    });

    test('exchangeRateText is formatted correctly for USD', () {
      final state = _stateWith(
        '100',
        recipientCurrency: TransferCurrency.usd,
      );

      expect(
        state.exchangeRateText,
        equals(
          'Rate: 1 ${TransferFlowState.sendCurrency} = '
              '${TransferCurrency.usd.rateFromUsd.toStringAsFixed(4)} USD',
        ),
      );
    });

    test('formattedFee shows promo label when fee is zero', () {
      final state = _stateWith('200');

      expect(state.formattedFee, contains('Promo'));
    });

    test('formattedTotalToPay equals send amount when fee is zero', () {
      final state = _stateWith('750');

      expect(state.formattedTotalToPay, equals('750.00 USD'));
    });

    test('formattedSending appends send currency code', () {
      final state = _stateWith('300');

      expect(state.formattedSending, equals('300.00 USD'));
    });

    test('large amounts are formatted with comma separators', () {
      final state = _stateWith('10000');

      expect(state.formattedSending, equals('10,000.00 USD'));
    });

    test('exchange rate precision uses four decimal places', () {
      final state = _stateWith(
        '1000',
      );

      expect(
        state.exchangeRateText,
        contains(TransferCurrency.rmb.rateFromUsd.toStringAsFixed(4)),
      );
    });
  });
}