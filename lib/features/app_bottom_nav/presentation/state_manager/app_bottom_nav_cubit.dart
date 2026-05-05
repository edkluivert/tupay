import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tupay/features/app_bottom_nav/presentation/state_manager/bottom_nav_state.dart';


@lazySingleton
class AppBottomNavCubit extends Cubit<BottomNavState> {
  AppBottomNavCubit() : super(BottomNavState(0, 50));

  void changeTabIndex(int index) {
    emit(BottomNavState(index, state.barWidth));
  }

  void toggleWidth() {
    emit(BottomNavState(state.index, 20));

    Future<void>.delayed(const Duration(milliseconds: 300)).then((_) {
      emit(BottomNavState(state.index, 50));
    });
  }
}
