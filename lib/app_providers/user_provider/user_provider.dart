import 'package:fun_joke/app_providers/user_provider/user_state.dart';
import 'package:fun_joke/models/login_model.dart';
import 'package:fun_joke/models/user_info.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@Riverpod(keepAlive: true)
class UserManager extends _$UserManager {
  @override
  UserState build() {
    return const UserState();
  }

  void update(UserInfo? userInfo) {
    state = state.copyWith(
      avatar: userInfo?.avatar,
      nickname: userInfo?.nickname,
      userId: userInfo?.userId,
      birthday: userInfo?.birthday,
      sex: userInfo?.sex,
      signature: userInfo?.signature,
    );
  }
}
