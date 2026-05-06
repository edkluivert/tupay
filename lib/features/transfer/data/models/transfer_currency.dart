enum TransferCurrency {
  rmb,
  eur,
  usd;

  String get code {
    switch (this) {
      case TransferCurrency.rmb:
        return 'RMB';
      case TransferCurrency.eur:
        return 'EUR';
      case TransferCurrency.usd:
        return 'USD';
    }
  }

  String get flag {
    switch (this) {
      case TransferCurrency.rmb:
        return '🇨🇳';
      case TransferCurrency.eur:
        return '🇪🇺';
      case TransferCurrency.usd:
        return '🇺🇸';
    }
  }

  String get label {
    switch (this) {
      case TransferCurrency.rmb:
        return 'Chinese Yuan';
      case TransferCurrency.eur:
        return 'Euro';
      case TransferCurrency.usd:
        return 'US Dollar';
    }
  }

  double get rateFromUsd {
    switch (this) {
      case TransferCurrency.rmb:
        return 7.2400;
      case TransferCurrency.eur:
        return 0.9245;
      case TransferCurrency.usd:
        return 1;
    }
  }
}