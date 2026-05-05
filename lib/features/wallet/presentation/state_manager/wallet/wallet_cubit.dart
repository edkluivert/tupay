import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tupay/features/wallet/data/models/transaction_model.dart';
import 'package:tupay/features/wallet/presentation/state_manager/wallet/wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(WalletLoading());

  Future<void> loadWallet() async {
    if (isClosed) return;
    emit(WalletLoading());
    await Future.delayed(const Duration(milliseconds: 700));
    if (isClosed) return;

    emit(WalletSuccess(
      balance: '12,450.80',
      exchangeRate: '1 USD = 1,485.50 NGN',
      rateChange: '+0.2%',
      monthlyInterest: r'$42.15',
      pendingCount: 2,
      pendingTotal: r'$1,200.00',
      transactions: MockTransactions.usdWallet,
      spendingTrend: [40, 120, 180, 55, 90, 150, 200],
    ));
  }
}
