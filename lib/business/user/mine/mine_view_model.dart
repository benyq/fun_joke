import 'package:fun_joke/app_providers/api_provider.dart';
import 'package:fun_joke/app_providers/user_provider/user_provider.dart';
import 'package:fun_joke/business/user/mine/mine_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mine_view_model.g.dart';

@riverpod
class MinePageVM extends _$MinePageVM {
  @override
  MineState build()  {
    return const MineState();
  }

  void getUserInfo() async{
    final api = await ref.read(apiProvider);
    var res = await api.getUserInfo();
    if (res.isSuccess) {
      state = state.copyWith(
        attentionNum: res.data?.info.attentionNum,
        fansNum: res.data?.info.fansNum,
        likeNum: res.data?.info.likeNum,
        experienceNum: res.data?.info.experienceNum,
      );
      ref.read(userManagerProvider.notifier).update(res.data?.user);
    }
  }
}
