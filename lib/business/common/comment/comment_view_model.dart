import 'package:flutter/material.dart';
import 'package:fun_joke/app_providers/api_provider.dart';
import 'package:fun_joke/business/common/comment/comment_state.dart';
import 'package:fun_joke/common/paging_widget/page_data_widget.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comment_view_model.g.dart';

@Riverpod(keepAlive: true)
class CommentVM extends _$CommentVM with PageLogic{

  late TextEditingController commentController;
  late FocusNode focusNode;
  int publishCommentCount = 0;
  String currentJokeId = '';

  @override
  CommentState build() {
    commentController = TextEditingController();
    focusNode = FocusNode();
    return const CommentState([], 0);
  }

  void init(String jokeId) {
    if (currentJokeId != jokeId) {
      currentJokeId = jokeId;
      state = const CommentState([], 0);
      refresh(jokeId);
    }
  }

  Future<void> refresh(String jokeId) async {
    var api = await ref.read(apiProvider);
    sendRefreshPagingRequest(()=> api.getJokeCommentList(jokeId, page), (value) {
      state = state.copyWith(commentList: value.comments, commentSize: value.count);
    });
  }

  Future<void> loadMore(String jokeId) async {
    var api = await ref.read(apiProvider);
    sendLoadMorePagingRequest(api.getJokeCommentList(jokeId, page), (value) {
      state = state.copyWith(commentList: state.commentList + value.comments);
    });
  }

  Future<void> publishComment(String comment, String jokeId) async{
    focusNode.unfocus();
    commentController.text = "";
    var api = await ref.read(apiProvider);
    var response = await api.publishJokeComment(comment, jokeId);
    if (response.isSuccess) {
      publishCommentCount++;
      state = state.copyWith(commentList: [response.data!] + state.commentList, commentSize: state.commentSize + 1);
    }
  }
}