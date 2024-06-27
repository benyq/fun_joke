import 'package:fun_joke/app_providers/api_provider.dart';
import 'package:fun_joke/business/joke/examining_joke/examine_joke_state.dart';
import 'package:fun_joke/common/paging_widget/page_data_widget.dart';
import 'package:fun_joke/common/view_state/view_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'examine_joke_view_model.g.dart';

@riverpod
class ExamineJokeVM extends _$ExamineJokeVM with PageLogic{

  @override
  ViewState<ExamineJokeState> build(int status) {
    refresh();
    return const ViewState<ExamineJokeState>();
  }

  void refresh() async {
    page = 0;
    final api = await ref.read(apiProvider);
    sendRefreshPagingRequest(api.getAuditJokes(status, page), (data){
      state = state.successState(ExamineJokeState(jokes: data!));
    }, failCallback: () {
      state = state.errorState();
    }, emptyCallback: () {
      state = state.emptyState();
    });
  }

  void loadMoreData()async {
    final api = await ref.read(apiProvider);
    sendLoadMorePagingRequest(api.getAuditJokes(status, page), (data){
      state = state.successState(ExamineJokeState(jokes: state.data!.jokes + data!));
    });
  }
}

