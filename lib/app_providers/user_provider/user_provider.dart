import 'package:fun_joke/app_providers/user_provider/user_state.dart';
import 'package:fun_joke/app_providers/user_service.dart';
import 'package:fun_joke/models/login_model.dart';
import 'package:fun_joke/models/user_info.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@Riverpod(keepAlive: true)
class UserManager extends _$UserManager {
  @override
  UserState build() {
    var user = const UserState();
    var model = UserService.instance.loginModel;
    if (model != null) {
      user = user.copyWith(
        avatar: model.userInfo.avatar,
        nickname: model.userInfo.nickname,
        userId: model.userInfo.userId,
        birthday: model.userInfo.birthday,
        sex: model.userInfo.sex,
        signature: model.userInfo.signature,
      );
    }
    return user;
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
