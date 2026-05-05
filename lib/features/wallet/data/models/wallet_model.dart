class WalletModel {
  const WalletModel({
    required this.currency,
    required this.currencySymbol,
    required this.countryFlag,
    required this.countryName,
    required this.balance,
  });

  final String currency;
  final String currencySymbol;
  final String countryFlag;
  final String countryName;
  final String balance;

  String get formattedBalance => '$currencySymbol$balance';
}

abstract final class MockWallets {
  static const List<WalletModel> all = [
    WalletModel(
      currency: 'CNY',
      currencySymbol: '¥',
      countryFlag: '🇨🇳',
      countryName: 'CHINA',
      balance: '85,000',
    ),
    WalletModel(
      currency: 'USD',
      currencySymbol: '\$',
      countryFlag: '🇺🇸',
      countryName: 'UNITED STATES',
      balance: '12,450',
    ),
    WalletModel(
      currency: 'GBP',
      currencySymbol: '£',
      countryFlag: '🇬🇧',
      countryName: 'UNITED KINGDOM',
      balance: '8,200',
    ),
  ];
}
