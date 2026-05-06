import 'dart:isolate';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tupay/core/injections/injection.dart';
import 'package:tupay/core/services/current_user_service.dart';
import 'package:tupay/core/utils/isolate_parser.dart';
import 'package:tupay/features/home/presentation/state_manager/home_state.dart';


class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeLoading());

  Future<void> loadHome() async {
    if (isClosed) return;
    emit(HomeLoading());
    
    // Simulate background isolate processing of a 5MB JSON string
    // This offloads the heavy JSON generation, parsing, and filtering from the UI thread.
    final _ = await Isolate.run(IsolateParser.parseLargeTransactionData);

    if (isClosed) return;
    
    final currentUser = sl<CurrentUserService>().currentUser;
    
    if (currentUser != null) {
      emit(
        HomeSuccess(
          totalBalance: currentUser.totalBalance,
          changePercent: currentUser.changePercent,
          wallets: currentUser.wallets,
          transactions: currentUser.transactions,
        ),
      );
    } else {
      emit(HomeError('User session expired.'));
    }
  }

  void toggleBalanceVisibility() {
    final current = state;
    if (current is! HomeSuccess) return;
    emit(current.copyWith(balanceVisible: !current.balanceVisible));
  }
}