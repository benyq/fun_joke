import 'package:fun_joke/app_providers/api_provider.dart';
import 'package:fun_joke/business/home/home_page_type.dart';
import 'package:fun_joke/common/paging_widget/page_data_widget.dart';
import 'package:fun_joke/common/view_state/view_state.dart';
import 'package:fun_joke/http/api_response.dart';
import 'package:fun_joke/models/joke_detail_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'joke_list_view_model.g.dart';

@riverpod
class JokeListVM extends _$JokeListVM with PageLogic{
  @override
  ViewState<List<JokeDetailModel>> build(HomePageType type) {
    return const ViewState();
  }

  void refresh() {
    sendRefreshPagingRequest(requestFuture(page), (value) {
      state = state.successState(value!);
    }, failCallback: () {
      state = state.errorState();
    }, emptyCallback: () {
      state = state.emptyState();
    });
  }

  void loadMore() {
    sendLoadMorePagingRequest(requestFuture(page), (data){
      state = state.successState(state.data! + data!);
    });
  }

  Future<ApiResponse<List<JokeDetailModel>>> requestFuture(int pageNum) async{
    var api = await ref.read(apiProvider);
    switch(type) {
      case HomePageType.RECOMMEND:
        return api.getRecommendList();
      case HomePageType.FRESH:
        return api.getFreshList();
      case HomePageType.TEXT:
        return api.getTextList();
      case HomePageType.IMAGE:
        return api.getImageList();
    }
  }
}


