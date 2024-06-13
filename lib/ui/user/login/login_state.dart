class LoginState {
  final LoginType loginType;

  LoginState({required this.loginType});

  bool get isPassword => loginType == LoginType.password;

  LoginState copyWith({LoginType? loginType}) {
    return LoginState(
      loginType: loginType ?? this.loginType,
    );
  }
}


enum LoginType {
  password,
  verificationCode
}