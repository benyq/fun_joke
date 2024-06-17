class LoginState {
  final LoginType loginType;
  final bool isCountDown;

  LoginState({required this.loginType, this.isCountDown = false});

  bool get isPassword => loginType == LoginType.password;

  LoginState copyWith({
    LoginType? loginType,
    bool? isCountDown,
  }) {
    return LoginState(
      loginType: loginType ?? this.loginType,
      isCountDown: isCountDown ?? this.isCountDown,
    );
  }
}


enum LoginType {
  password,
  verificationCode
}