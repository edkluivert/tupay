enum TransactionType { credit, debit }

enum TransactionStatus { success, pending, failed }

enum TransactionCategory { walletFunding, transfer, purchase, deposit, subscription, payout }

class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.currencySymbol,
    required this.type,
    required this.status,
    required this.category,
    required this.timestamp,
  });

  final String id;
  final String title;
  final String subtitle;
  final String amount;
  final String currencySymbol;
  final TransactionType type;
  final TransactionStatus status;
  final TransactionCategory category;
  final DateTime timestamp;

  String get formattedAmount {
    final prefix = type == TransactionType.credit ? '+' : '-';
    return '$prefix$currencySymbol$amount';
  }

  bool get isCredit => type == TransactionType.credit;
}

// ─── Mock data ────────────────────────────────────────────────────────────────

abstract final class MockTransactions {
  static final List<TransactionModel> dashboard = [
    TransactionModel(
      id: 'tx001',
      title: 'Wallet Funding',
      subtitle: 'Via Bank Transfer • 2m ago',
      amount: '250,000',
      currencySymbol: '₦',
      type: TransactionType.credit,
      status: TransactionStatus.success,
      category: TransactionCategory.walletFunding,
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
    TransactionModel(
      id: 'tx002',
      title: 'Transfer to John Doe',
      subtitle: 'External Bank • 1h ago',
      amount: '45,000',
      currencySymbol: '₦',
      type: TransactionType.debit,
      status: TransactionStatus.success,
      category: TransactionCategory.transfer,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    TransactionModel(
      id: 'tx003',
      title: 'Amazon.com',
      subtitle: 'Virtual Card • Yesterday',
      amount: '120.50',
      currencySymbol: '\$',
      type: TransactionType.debit,
      status: TransactionStatus.pending,
      category: TransactionCategory.purchase,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  static final List<TransactionModel> usdWallet = [
    TransactionModel(
      id: 'usd001',
      title: 'Amazon.com Seattle',
      subtitle: 'Oct 24, 2023 • 2:45 PM',
      amount: '124.99',
      currencySymbol: '\$',
      type: TransactionType.debit,
      status: TransactionStatus.success,
      category: TransactionCategory.purchase,
      timestamp: DateTime(2023, 10, 24, 14, 45),
    ),
    TransactionModel(
      id: 'usd002',
      title: 'Deposit from NGN Wallet',
      subtitle: 'Oct 22, 2023 • 11:15 AM',
      amount: '2,500.00',
      currencySymbol: '\$',
      type: TransactionType.credit,
      status: TransactionStatus.success,
      category: TransactionCategory.deposit,
      timestamp: DateTime(2023, 10, 22, 11, 15),
    ),
    TransactionModel(
      id: 'usd003',
      title: 'DigitalOcean Cloud Svcs',
      subtitle: 'Oct 20, 2023 • 09:00 AM',
      amount: '45.00',
      currencySymbol: '\$',
      type: TransactionType.debit,
      status: TransactionStatus.pending,
      category: TransactionCategory.subscription,
      timestamp: DateTime(2023, 10, 20, 9, 0),
    ),
    TransactionModel(
      id: 'usd004',
      title: 'Stripe Payout – Project X',
      subtitle: 'Oct 18, 2023 • 4:20 PM',
      amount: '1,420.00',
      currencySymbol: '\$',
      type: TransactionType.credit,
      status: TransactionStatus.success,
      category: TransactionCategory.payout,
      timestamp: DateTime(2023, 10, 18, 16, 20),
    ),
  ];

  static final List<TransactionModel> card = [
    TransactionModel(
      id: 'card001',
      title: 'Apple Services',
      subtitle: 'Oct 24 • Subscription',
      amount: '14.99',
      currencySymbol: '\$',
      type: TransactionType.debit,
      status: TransactionStatus.success,
      category: TransactionCategory.subscription,
      timestamp: DateTime(2023, 10, 24),
    ),
    TransactionModel(
      id: 'card002',
      title: 'Blue Bottle Coffee',
      subtitle: 'Oct 22 • Dining',
      amount: '8.50',
      currencySymbol: '\$',
      type: TransactionType.debit,
      status: TransactionStatus.success,
      category: TransactionCategory.purchase,
      timestamp: DateTime(2023, 10, 22),
    ),
    TransactionModel(
      id: 'card003',
      title: 'Card Top-up',
      subtitle: 'Oct 20 • Transfer',
      amount: '500.00',
      currencySymbol: '\$',
      type: TransactionType.credit,
      status: TransactionStatus.success,
      category: TransactionCategory.deposit,
      timestamp: DateTime(2023, 10, 20),
    ),
  ];
}
