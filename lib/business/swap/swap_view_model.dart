import 'package:fun_joke/app_providers/api_provider.dart';
import 'package:fun_joke/business/common/joke_logic.dart';
import 'package:fun_joke/common/paging_widget/page_data_widget.dart';
import 'package:fun_joke/common/view_state/view_state.dart';
import 'package:fun_joke/models/joke_detail_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'swap_view_model.g.dart';

@riverpod
class SwapVM extends _$SwapVM with PageLogic, JokeLogic{

  @override
  ViewState<List<JokeDetailModel>> build() {
    refresh();
    return const ViewState();
  }

  void refresh() async{
    var api = await ref.read(apiProvider);
    sendRefreshPagingRequest(() => api.getSwapData(), (data) {
      state = state.successState(data);
    });
  }

  void loadMoreData() async{
    var api = await ref.read(apiProvider);
    sendLoadMorePagingRequest(api.getSwapData(), (value) {
      state = state.successState(state.data! + value);
    });
  }

  void likeJoke(int jokeId, bool isLike) async{
    var jokeList = state.data ?? [];
    likeJokeReal(await ref.read(apiProvider), jokeId, isLike, ()=> jokeList, (v) {
      state = state.copyWith(data: v);
    });
  }

  void unlikeJoke(int jokeId, bool isUnlike) async{
    var jokeList = state.data ?? [];
    likeJokeReal(await ref.read(apiProvider), jokeId, isUnlike, ()=> jokeList, (v) {
      state = state.copyWith(data: v);
    });
  }

  void updateJokeInfo(JokeDetailModel joke) {
    var jokeList = state.data ?? [];
    updateJokeInfoReal(joke, () => jokeList, (value) {
      state = state.copyWith(data: value);
    });
  }
}