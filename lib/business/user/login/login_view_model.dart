import 'dart:async';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fun_joke/app_providers/api_provider.dart';
import 'package:fun_joke/app_providers/user_provider/user_provider.dart';
import 'package:fun_joke/app_providers/user_service.dart';
import 'package:fun_joke/business/user/login/login_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_view_model.g.dart';

@riverpod
class LoginPageVM extends _$LoginPageVM {

  @override
  LoginState build()  {
    return LoginState(pageType: LoginPageType.code);
  }

  Future<void> login(String code)async {
    var api = await ref.read(apiProvider);
    state = state.copyWith(loading: true);
    var res = await api.loginByCode(state.phoneNumber, code);
    state = state.copyWith(loading: false);
    if (res.isSuccess) {
      ref.read(userManagerProvider.notifier).update(res.data);
      state = state.copyWith(loginSuccess: true);
      UserService.instance.update(res.data);
      SmartDialog.showToast('登录成功');
    }else {
      SmartDialog.showToast(res.msg);
    }
  }

  Future<void> getVerificationCode(String phone) async{
    var api = await ref.read(apiProvider);
    state = state.copyWith(loading: true);
    var res = await api.getLoginVerifyCode(phone);
    state = state.copyWith(loading: false);
    if (res.isSuccess) {
      SmartDialog.showToast('验证码已发送');
      state = state.copyWith(pageType: LoginPageType.login, phoneNumber: phone);
    }
  }
}
