

import 'package:tupay/features/wallet/data/models/transaction_model.dart';
import 'package:tupay/features/wallet/data/models/wallet_model.dart';

sealed class HomeState {}

final class HomeLoading extends HomeState {}

final class HomeSuccess extends HomeState {
  HomeSuccess({
    required this.totalBalance,
    required this.changePercent,
    required this.wallets,
    required this.transactions,
    this.balanceVisible = true,
  });

  final String totalBalance;
  final String changePercent;
  final List<WalletModel> wallets;
  final List<TransactionModel> transactions;
  final bool balanceVisible;

  HomeSuccess copyWith({bool? balanceVisible}) {
    return HomeSuccess(
      totalBalance: totalBalance,
      changePercent: changePercent,
      wallets: wallets,
      transactions: transactions,
      balanceVisible: balanceVisible ?? this.balanceVisible,
    );
  }
}

final class HomeEmpty extends HomeState {}

final class HomeError extends HomeState {
  HomeError(this.message);
  final String message;
}