import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fun_joke/app_providers/api_provider.dart';
import 'package:fun_joke/app_providers/user_provider/user_state.dart';
import 'package:fun_joke/app_providers/user_service.dart';
import 'package:fun_joke/models/login_model.dart';
import 'package:fun_joke/models/user_info.dart';
import 'package:fun_joke/utils/joke_log.dart';
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

  void updateUserAvatar(String avatar) {
    state = state.copyWith(avatar: avatar);
  }

  void clear() {
    state = const UserState();
  }

  void updateUserGender(String gender) async{
    _updateUserInfo(gender, 3, ()=> state.sex, (value) {
      state = state.copyWith(sex: value);
    });
  }

  void updateUserBirthday(String birthday) async{
    _updateUserInfo(birthday, 4, ()=> state.birthday, (value) {
      state = state.copyWith(birthday: value);
    });
  }

  void updateUserNickName(String nickName) async{
    _updateUserInfo(nickName, 1, ()=> state.nickname, (value) {
      state = state.copyWith(nickname: value);
    });
  }

  void updateUserSignature(String signature) async{
    _updateUserInfo(signature, 2, ()=> state.signature, (value) {
      state = state.copyWith(signature: value);
    });
  }

  void _updateUserInfo(String content, int type, ValueGetter<String> valueGetter, ValueChanged<String> updateAction)async {
    var oldValue = valueGetter();
    if (content == oldValue) return;
    var api = await ref.read(apiProvider);
    // 先改值
    updateAction(content);
    api.updateUserInfo(content, type).then((value) {
      if (!value.isSuccess) {
        throw Exception(value.msg);
      }
    }).catchError((e){
      updateAction(oldValue);
      SmartDialog.showToast(e.message);
    });
  }
}
