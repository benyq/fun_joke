import 'package:fun_joke/app_providers/api_provider.dart';
import 'package:fun_joke/business/common/comment/comment_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comment_view_model.g.dart';

@riverpod
class CommentVM extends _$CommentVM {

  var _page = 1;

  @override
  CommentState build() {
    return const CommentState([], 0);
  }

  Future<void> getCommentList(String jokeId) async {
    var api = await ref.read(apiProvider);
    var response = await api.getJokeCommentList(jokeId, _page);
    if (response.isSuccess) {
      state = state.copyWith(commentList: response.data?.comments, commentSize: response.data?.count);
    }
  }
}