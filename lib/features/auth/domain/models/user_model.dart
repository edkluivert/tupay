import 'dart:ui';
import 'package:tupay/features/wallet/data/models/transaction_model.dart';
import 'package:tupay/features/wallet/data/models/wallet_model.dart';

class LinkedPaymentMethod {
  const LinkedPaymentMethod({
    required this.bankName,
    required this.type,
    required this.maskedNumber,
    required this.initials,
    required this.isDefault,
    required this.bankColor,
  });

  final String bankName;
  final String type;
  final String maskedNumber;
  final String initials;
  final bool isDefault;
  final Color bankColor;
}

class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.password,
    required this.isVerified,
    required this.securityPercent,
    required this.dailyLimit,
    required this.dailyUsed,
    required this.linkedMethods,
    required this.totalBalance,
    required this.changePercent,
    required this.wallets,
    required this.transactions,
  });

  final String id;
  final String name;
  final String email;
  final String username;
  final String password;
  
  // Profile
  final bool isVerified;
  final int securityPercent;
  final String dailyLimit;
  final String dailyUsed;
  final List<LinkedPaymentMethod> linkedMethods;
  
  // Wallet / Home
  final String totalBalance;
  final String changePercent;
  final List<WalletModel> wallets;
  final List<TransactionModel> transactions;
}
