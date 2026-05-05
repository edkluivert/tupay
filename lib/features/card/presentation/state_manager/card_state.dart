

import 'package:tupay/features/wallet/data/models/transaction_model.dart';

sealed class CardState {}

final class CardLoading extends CardState {}

final class CardSuccess extends CardState {
  CardSuccess({
    required this.cardType,
    required this.cardLabel,
    required this.maskedNumber,
    required this.cardHolder,
    required this.expiry,
    required this.isActive,
    required this.isFrozen,
    required this.billingAddress,
    required this.transactions,
  });

  final String cardType;
  final String cardLabel;
  final String maskedNumber;
  final String cardHolder;
  final String expiry;
  final bool isActive;
  final bool isFrozen;
  final String billingAddress;
  final List<TransactionModel> transactions;

  CardSuccess copyWith({bool? isFrozen, bool? isActive}) {
    return CardSuccess(
      cardType: cardType,
      cardLabel: cardLabel,
      maskedNumber: maskedNumber,
      cardHolder: cardHolder,
      expiry: expiry,
      isActive: isActive ?? this.isActive,
      isFrozen: isFrozen ?? this.isFrozen,
      billingAddress: billingAddress,
      transactions: transactions,
    );
  }
}

final class CardError extends CardState {
  CardError(this.message);
  final String message;
}
