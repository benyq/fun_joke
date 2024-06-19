class LoginState {
  final LoginPageType pageType;
  final String phoneNumber;
  final bool loading;
  final bool loginSuccess;

  LoginState({required this.pageType, this.phoneNumber = '', this.loading = false, this.loginSuccess = false});


  LoginState copyWith({
    LoginPageType? pageType,
    String? phoneNumber,
    bool? loading,
    bool? loginSuccess,
  }) {
    return LoginState(
      pageType: pageType ?? this.pageType,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      loading: loading ?? this.loading,
      loginSuccess: loginSuccess ?? this.loginSuccess,
    );
  }
}


enum LoginPageType {
  code,
  login
}