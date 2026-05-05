import 'package:tupay/features/wallet/data/models/transaction_model.dart';



sealed class WalletState {}

final class WalletLoading extends WalletState {}

final class WalletSuccess extends WalletState {
  WalletSuccess({
    required this.balance,
    required this.exchangeRate,
    required this.rateChange,
    required this.monthlyInterest,
    required this.pendingCount,
    required this.pendingTotal,
    required this.transactions,
    required this.spendingTrend,
  });

  final String balance;
  final String exchangeRate;
  final String rateChange;
  final String monthlyInterest;
  final int pendingCount;
  final String pendingTotal;
  final List<TransactionModel> transactions;


  final List<double> spendingTrend;
}

final class WalletError extends WalletState {
  WalletError(this.message);
  final String message;
}
