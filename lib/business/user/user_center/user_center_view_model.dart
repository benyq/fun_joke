import 'package:fun_joke/business/user/user_center/user_center_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_center_view_model.g.dart';

@riverpod
class UserCenterVM extends _$UserCenterVM {
  @override
  UserCenterState build() {
    return const UserCenterState();
  }

  void titleBarVisibility(bool visible) {
    state = state.copyWith(showTitleBar: visible);
  }
}