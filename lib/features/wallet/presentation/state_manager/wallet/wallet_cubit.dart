import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tupay/core/injections/injection.dart';
import 'package:tupay/core/services/current_user_service.dart';
import 'package:tupay/features/wallet/data/models/transaction_model.dart';
import 'package:tupay/features/wallet/presentation/state_manager/wallet/wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(WalletLoading());

  Future<void> loadWallet() async {
    if (isClosed) return;
    emit(WalletLoading());
    await Future.delayed(const Duration(milliseconds: 700));
    if (isClosed) return;
    
    final currentUser = sl<CurrentUserService>().currentUser;
    
    if (currentUser != null) {
      emit(WalletSuccess(
        balance: currentUser.totalBalance,
        exchangeRate: '1 USD = 1,485.50 NGN',
        rateChange: currentUser.changePercent,
        monthlyInterest: r'$42.15',
        pendingCount: 2,
        pendingTotal: r'$1,200.00',
        transactions: currentUser.transactions,
        spendingTrend: [40, 120, 180, 55, 90, 150, 200],
      ));
    } else {
      emit(WalletError('User session expired.'));
    }
  }
}
