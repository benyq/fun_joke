import 'package:flutter/cupertino.dart';
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
    sendRefreshPagingRequest(()=> requestFuture(page), (value) {
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

  void updateJokeInfo(JokeDetailModel joke) {
    var jokeList = state.data ?? [];
    for(var i = 0; i < jokeList.length; i++) {
      if(jokeList[i].joke.jokesId == joke.joke.jokesId) {
        jokeList[i] = joke;
        break;
      }
    }
    state = state.copyWith(data: jokeList);
  }


  void likeJoke(int jokeId, bool isLike) async{
    var jokeList = state.data ?? [];
    var oldValue = false;
    var oldCount = 0;
    _changeJokeList(jokeList, jokeId, (joke) {
      oldValue = joke.info.isLike;
      oldCount = joke.info.likeNum;
      joke.info.isLike = isLike;
      joke.info.likeNum += isLike ? 1 : -1;
    });
    state = state.copyWith(data: jokeList);
    var api = await ref.read(apiProvider);
    api.likeJoke(jokeId.toString(), isLike).then((value) {
      if (!value.isSuccess) {
        throw Exception(value.msg);
      }
    }).catchError((e){
      _changeJokeList(jokeList, jokeId, (joke) {
        joke.info.isLike = oldValue;
        joke.info.likeNum = oldCount;
      });
      state = state.copyWith(data: jokeList);
    });
  }

  void unlikeJoke(int jokeId, bool isUnlike) async{
    var jokeList = state.data ?? [];
    var oldValue = false;
    var oldCount = 0;
    _changeJokeList(jokeList, jokeId, (joke) {
      oldValue = joke.info.isUnlike;
      oldCount = joke.info.disLikeNum;
      joke.info.isUnlike = isUnlike;
      joke.info.disLikeNum += isUnlike ? 1 : -1;
    });
    state = state.copyWith(data: jokeList);
    var api = await ref.read(apiProvider);
    api.unlikeJoke(jokeId.toString(), isUnlike).then((value) {
      if (!value.isSuccess) {
        throw Exception(value.msg);
      }
    }).catchError((e){
      _changeJokeList(jokeList, jokeId, (joke) {
        joke.info.isUnlike = oldValue;
        joke.info.disLikeNum = oldCount;
      });
      state = state.copyWith(data: jokeList);
    });
  }

  void _changeJokeList(List<JokeDetailModel> jokeList, int jokeId, ValueChanged<JokeDetailModel> changed) {
    for(var i = 0; i < jokeList.length; i++) {
      if(jokeList[i].joke.jokesId == jokeId) {
        changed(jokeList[i]);
        break;
      }
    }
  }
}


