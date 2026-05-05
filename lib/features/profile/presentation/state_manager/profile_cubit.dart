import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tupay/features/features.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileLoading());

  Future<void> loadProfile() async {
    if (isClosed) return;
    emit(ProfileLoading());
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (isClosed) return;

    emit(ProfileSuccess(
      name: 'Alexander Vance',
      email: 'alex.vance@example.com',
      isVerified: true,
      securityPercent: 85,
      dailyLimit: r'$10,000.00',
      dailyUsed: r'$5,750.00',
      linkedMethods: const [
        LinkedPaymentMethod(
          bankName: 'Chase Bank Premier',
          type: 'Checking',
          maskedNumber: '4421',
          initials: 'CHASE',
          isDefault: true,
          bankColor: AppColors.blackv2,
        ),
        LinkedPaymentMethod(
          bankName: 'Wells Fargo Savings',
          type: 'Savings',
          maskedNumber: '0982',
          initials: 'WF',
          isDefault: false,
          bankColor: AppColors.greenText,
        ),
      ],
    ));
  }


}
