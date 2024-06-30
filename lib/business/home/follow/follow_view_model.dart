import 'package:fun_joke/app_providers/api_provider.dart';
import 'package:fun_joke/business/home/follow/follow_state.dart';
import 'package:fun_joke/common/paging_widget/page_data_widget.dart';
import 'package:fun_joke/common/view_state/view_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'follow_view_model.g.dart';

@riverpod
class FollowVM extends _$FollowVM with PageLogic{
  @override
  ViewState<FollowState> build() {
    getRecommendUser();
    return const ViewState();
  }


  void getRecommendUser() async{
    var api = await ref.read(apiProvider);
    var response = await api.getRecommendUser();
    if(response.isSuccess){
      var users = response.data ?? [];
      FollowState followState = state.data ?? const FollowState();
      state = state.successState(followState.copyWith(users: users));
    }
  }


  void refresh() async{
    var api = await ref.read(apiProvider);
    sendRefreshPagingRequest(api.getAttentionJoke(page), (data){
      FollowState followState = state.data ?? const FollowState();
      state = state.successState(followState.copyWith(jokes: data));
    }, );
  }

  void loadMore() async{
    var api = await ref.read(apiProvider);
    sendLoadMorePagingRequest(api.getAttentionJoke(page), (data){
      FollowState followState = state.data ?? const FollowState();
      state = state.successState(followState.copyWith(jokes: followState.jokes + data));
    });
  }
}