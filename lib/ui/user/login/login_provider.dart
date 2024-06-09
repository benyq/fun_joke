import 'package:fun_joke/ui/user/login/login_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_provider.g.dart';

@riverpod
class LoginProvider extends _$LoginProvider {
    Future<LoginState> build() async {
      return LoginState();
    }
}