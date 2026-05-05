import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tupay/features/home/presentation/state_manager/home_state.dart';
import 'package:tupay/features/wallet/data/models/transaction_model.dart';
import 'package:tupay/features/wallet/data/models/wallet_model.dart';



class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeLoading());

  Future<void> loadHome() async {
    if (isClosed) return;
    emit(HomeLoading());

    // Mock network delay — replace with real repository call
    await Future.delayed(const Duration(seconds: 3));

    if (isClosed) return;
    emit(
      HomeSuccess(
        totalBalance: '4,850,200.00',
        changePercent: '+2.4%',
        wallets: MockWallets.all,
        transactions: MockTransactions.dashboard,
      ),
    );
  }

  void toggleBalanceVisibility() {
    final current = state;
    if (current is! HomeSuccess) return;
    emit(current.copyWith(balanceVisible: !current.balanceVisible));
  }
}