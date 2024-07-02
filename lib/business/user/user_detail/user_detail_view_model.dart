import 'package:fun_joke/business/user/user_detail/user_detail_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_detail_view_model.g.dart';

@riverpod
class UserDetailVM extends _$UserDetailVM {
  @override
  UserDetailState build() {
    return const UserDetailState();
  }

  void titleBarVisibility(bool visible) {
    state = state.copyWith(showTitleBar: visible);
  }
}