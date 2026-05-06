import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tupay/core/injections/injection.dart';
import 'package:tupay/core/services/current_user_service.dart';
import 'package:tupay/features/features.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileLoading());

  Future<void> loadProfile() async {
    if (isClosed) return;
    emit(ProfileLoading());
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (isClosed) return;
    
    final currentUser = sl<CurrentUserService>().currentUser;
    
    if (currentUser != null) {
      emit(ProfileSuccess(
        name: currentUser.name,
        email: currentUser.email,
        isVerified: currentUser.isVerified,
        securityPercent: currentUser.securityPercent,
        dailyLimit: currentUser.dailyLimit,
        dailyUsed: currentUser.dailyUsed,
        linkedMethods: currentUser.linkedMethods,
      ));
    } else {
      emit(ProfileError('User session expired.'));
    }
  }


}
