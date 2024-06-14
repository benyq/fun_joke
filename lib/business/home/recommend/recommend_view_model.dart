import 'package:flutter/material.dart';
import 'package:fun_joke/app_providers/api_provider.dart';
import 'package:fun_joke/business/home/recommend/recommend_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recommend_view_model.g.dart';


@riverpod
class RecommendVM extends _$RecommendVM {
  @override
  RecommendState build()  {
    return RecommendState([], 0);
  }
int s = 0;
  Future<void> refresh() async{
    var api = ref.read(apiProvider);
    var response = await api.getRecommendList();
    if (response.isSuccess) {
      state = state.copyWith(jokeList: response.data!, size: s++);
    }else {
      debugPrint('refresh error');
    }
  }

  Future<void> loadMore()async {
    var api = ref.read(apiProvider);
    var response = await api.getRecommendList();
    if (response.isSuccess) {
      state = state.copyWith(jokeList: state.jokeList + response.data!);
    }
  }
}