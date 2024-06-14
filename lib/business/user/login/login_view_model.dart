import 'package:fun_joke/business/user/login/login_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_view_model.g.dart';

@riverpod
class LoginPageVM extends _$LoginPageVM {

  @override
  LoginState build()  {
    return LoginState(loginType: LoginType.verificationCode);
  }

  void toggleLoginType() {
    if (state.isPassword) {
      state = state.copyWith(loginType: LoginType.verificationCode);
    } else {
      state = state.copyWith(loginType: LoginType.password);
    }
  }
}
