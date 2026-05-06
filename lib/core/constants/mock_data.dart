import 'package:flutter/material.dart';
import 'package:tupay/core/constants/app_colors.dart';
import 'package:tupay/features/auth/domain/models/user_model.dart';
import 'package:tupay/features/wallet/data/models/transaction_model.dart';
import 'package:tupay/features/wallet/data/models/wallet_model.dart';

abstract final class MockData {
  static final Map<String, UserModel> users = {
    'tola@tupay.demo': UserModel(
      id: 'usr_tola',
      name: 'Tola Ade',
      email: 'tola@tupay.demo',
      username: 'tola',
      password: 'Password1!',
      isVerified: true,
      securityPercent: 85,
      dailyLimit: '₦10,000,000.00',
      dailyUsed: '₦5,750,000.00',
      linkedMethods: const [
        LinkedPaymentMethod(
          bankName: 'GTBank',
          type: 'Savings',
          maskedNumber: '4421',
          initials: 'GTB',
          isDefault: true,
          bankColor: AppColors.blackv2,
        ),
      ],
      totalBalance: '4,850,200.00',
      changePercent: '+2.4%',
      wallets: MockWallets.all,
      transactions: MockTransactions.dashboard,
    ),
    'ada@tupay.demo': UserModel(
      id: 'usr_ada',
      name: 'Ada Obi',
      email: 'ada@tupay.demo',
      username: 'ada',
      password: 'Ada12345!',
      isVerified: false,
      securityPercent: 40,
      dailyLimit: '₦1,000,000.00',
      dailyUsed: '₦250,000.00',
      linkedMethods: const [
        LinkedPaymentMethod(
          bankName: 'Access Bank',
          type: 'Savings',
          maskedNumber: '0982',
          initials: 'ACC',
          isDefault: false,
          bankColor: AppColors.greenText,
        ),
      ],
      totalBalance: '25,000.00',
      changePercent: '-1.2%',
      wallets: [MockWallets.all[1]],
      transactions: MockTransactions.usdWallet,
    ),
    'seyi@tupay.demo': UserModel(
      id: 'usr_seyi',
      name: 'Seyi Cole',
      email: 'seyi@tupay.demo',
      username: 'seyi',
      password: 'Seyi123!',
      isVerified: true,
      securityPercent: 100,
      dailyLimit: '₦50,000,000.00',
      dailyUsed: '₦0.00',
      linkedMethods: const [],
      totalBalance: '120,400.00',
      changePercent: '+5.0%',
      wallets: [MockWallets.all[0], MockWallets.all[2]],
      transactions: MockTransactions.card,
    ),
  };



  static final Map<String, String> userPhones = {
    'tola@tupay.demo': '+2348012345678',
    'ada@tupay.demo': '+2348023456789',
    'seyi@tupay.demo': '+2348034567890',
  };

  static UserModel? findUserByEmailOrUsername(String identifier) {
    final normalizedIdentifier = identifier.trim().toLowerCase();

    for (final user in users.values) {
      final emailMatches = user.email.toLowerCase() == normalizedIdentifier;
      final usernameMatches = user.username.toLowerCase() == normalizedIdentifier;

      if (emailMatches || usernameMatches) {
        return user;
      }
    }

    return null;
  }

  static UserModel? findUserByCredentials({
    required String emailOrUsername,
    required String password,
  }) {
    final normalizedIdentifier = emailOrUsername.trim().toLowerCase();
    final normalizedPassword = password.trim();

    for (final user in users.values) {
      final emailMatches = user.email.toLowerCase() == normalizedIdentifier;
      final usernameMatches = user.username.toLowerCase() == normalizedIdentifier;
      final passwordMatches = user.password == normalizedPassword;

      if ((emailMatches || usernameMatches) && passwordMatches) {
        return user;
      }
    }

    return null;
  }

  static bool emailExists(String email) {
    final normalizedEmail = email.trim().toLowerCase();

    return users.values.any(
          (user) => user.email.toLowerCase() == normalizedEmail,
    );
  }

  static bool usernameExists(String username) {
    final normalizedUsername = username.trim().toLowerCase();

    return users.values.any(
          (user) => user.username.toLowerCase() == normalizedUsername,
    );
  }

  static bool phoneExists(String phone) {
    final normalizedPhone = phone.trim();

    return userPhones.values.any(
          (savedPhone) => savedPhone == normalizedPhone,
    );
  }

  static UserModel createUser({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) {
    final normalizedName = fullName.trim();
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedPhone = phone.trim();

    final username = _generateUsername(normalizedName, normalizedEmail);
    final userId = 'usr_${DateTime.now().microsecondsSinceEpoch}';

    final user = UserModel(
      id: userId,
      name: normalizedName,
      email: normalizedEmail,
      username: username,
      password: password,
      isVerified: false,
      securityPercent: 25,
      dailyLimit: '₦1,000,000.00',
      dailyUsed: '₦0.00',
      linkedMethods: const [],
      totalBalance: '0.00',
      changePercent: '+0.0%',
      wallets: [MockWallets.all[0], MockWallets.all[1]],
      transactions: const [],
    );

    users[normalizedEmail] = user;
    userPhones[normalizedEmail] = normalizedPhone;

    return user;
  }

  static String _generateUsername(String fullName, String email) {
    final nameParts = fullName
        .trim()
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    final baseUsername = nameParts.isNotEmpty
        ? nameParts.first.replaceAll(RegExp('[^a-z0-9]'), '')
        : email.split('@').first.replaceAll(RegExp('[^a-z0-9]'), '');

    if (!usernameExists(baseUsername)) {
      return baseUsername;
    }

    var counter = 2;
    var candidate = '$baseUsername$counter';

    while (usernameExists(candidate)) {
      counter++;
      candidate = '$baseUsername$counter';
    }

    return candidate;
  }
}