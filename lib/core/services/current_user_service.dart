import 'package:tupay/features/auth/domain/models/user_model.dart';

class CurrentUserService {
  UserModel? currentUser;

  bool get hasCurrentUser => currentUser != null;

  void clear() {
    currentUser = null;
  }
}
