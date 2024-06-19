import 'package:fun_joke/app_providers/user_provider/user_state.dart';
import 'package:fun_joke/models/login_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
class UserManager extends _$UserManager {
  @override
  UserState build() {
    return UserState();
  }

  void update(LoginModel? model) {
    state = state.copyWith(
      avatar: model?.userInfo.avatar,
      nickname: model?.userInfo.nickname,
      userId: model?.userInfo.userId,
      userPhone: model?.userInfo.userPhone,
      birthday: model?.userInfo.birthday,
      inviteCode: model?.userInfo.inviteCode,
      invitedCode: model?.userInfo.invitedCode,
      sex: model?.userInfo.sex,
      signature: model?.userInfo.signature,
    );
  }
}
