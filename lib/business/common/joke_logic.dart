import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fun_joke/app_providers/api_provider.dart';
import 'package:fun_joke/business/common/comment/comment_view.dart';
import 'package:fun_joke/business/common/comment/comment_view_model.dart';
import 'package:fun_joke/http/joke_service.dart';
import 'package:fun_joke/models/joke_detail_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

mixin JokeLogic {

  void showCommentBottomSheet(BuildContext context, WidgetRef ref, JokeDetailModel joke, ValueChanged<JokeDetailModel> updateAction) {
    // 需要提前处理 CommentVM
    ref.read(commentVMProvider.notifier).init(joke.joke.jokesId.toString());
    showMaterialModalBottomSheet(
        duration: const Duration(milliseconds: 400),
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.w), topLeft: Radius.circular(10.w)),
        ),
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 15.w),
            height: ScreenUtil().screenHeight * 0.75,
            child: CommentView(jokeId: joke.joke.jokesId, commentSizeChanged: (size){
              joke.info.commentNum = size;
              updateAction(joke);
            },),
          );
        });

  }

  void likeJokeReal(JokeService service, int jokeId, bool isLike, ValueGetter<List<JokeDetailModel>> getter, ValueChanged<List<JokeDetailModel>> updateAction) async{
    var jokeList = getter();
    var oldValue = false;
    var oldCount = 0;
    _changeJokeList(jokeList, jokeId, (joke) {
      oldValue = joke.info.isLike;
      oldCount = joke.info.likeNum;
      joke.info.isLike = isLike;
      joke.info.likeNum += isLike ? 1 : -1;
    });
    updateAction(jokeList);
    service.likeJoke(jokeId.toString(), isLike).then((value) {
      if (!value.isSuccess) {
        throw Exception(value.msg);
      }
    }).catchError((e){
      _changeJokeList(jokeList, jokeId, (joke) {
        joke.info.isLike = oldValue;
        joke.info.likeNum = oldCount;
      });
      updateAction(jokeList);
    });
  }

  void unlikeJokeReal(JokeService service, int jokeId, bool isUnlike, ValueGetter<List<JokeDetailModel>> getter, ValueChanged<List<JokeDetailModel>> updateAction) async{
    var jokeList = getter();
    var oldValue = false;
    var oldCount = 0;
    _changeJokeList(jokeList, jokeId, (joke) {
      oldValue = joke.info.isUnlike;
      oldCount = joke.info.disLikeNum;
      joke.info.isUnlike = isUnlike;
      joke.info.disLikeNum += isUnlike ? 1 : -1;
    });
    updateAction(jokeList);
    service.unlikeJoke(jokeId.toString(), isUnlike).then((value) {
      if (!value.isSuccess) {
        throw Exception(value.msg);
      }
    }).catchError((e){
      _changeJokeList(jokeList, jokeId, (joke) {
        joke.info.isUnlike = oldValue;
        joke.info.disLikeNum = oldCount;
      });
      updateAction(jokeList);
    });
  }

  void updateJokeInfoReal(JokeDetailModel joke, ValueGetter<List<JokeDetailModel>> getter, ValueChanged<List<JokeDetailModel>> updateAction) {
    var jokeList = getter();
    for(var i = 0; i < jokeList.length; i++) {
      if(jokeList[i].joke.jokesId == joke.joke.jokesId) {
        jokeList[i] = joke;
        break;
      }
    }
    updateAction(jokeList);
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