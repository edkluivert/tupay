import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tupay/features/card/presentation/state_manager/card_state.dart';
import 'package:tupay/features/wallet/data/models/transaction_model.dart';


class CardCubit extends Cubit<CardState> {
  CardCubit() : super(CardLoading());

  Future<void> loadCard() async {
    if (isClosed) return;
    emit(CardLoading());
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (isClosed) return;

    emit(CardSuccess(
      cardType: 'VIRTUAL PLATINUM',
      cardLabel: 'USD Card',
      maskedNumber: '•••• •••• •••• 8842',
      cardHolder: 'ALEXANDER ROLAND',
      expiry: '09 / 27',
      isActive: true,
      isFrozen: false,
      billingAddress: '128 Innovation Way, Suite 400\nSan Francisco, CA 94105',
      transactions: MockTransactions.card,
    ));
  }

  void toggleFreeze() {
    final current = state;
    if (current is! CardSuccess) return;
    emit(current.copyWith(isFrozen: !current.isFrozen));
  }
}
