import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fun_joke/business/common/comment/comment_view.dart';
import 'package:fun_joke/business/common/joke_item.dart';
import 'package:fun_joke/business/home/recommend/recommend_view_model.dart';
import 'package:fun_joke/models/joke_detail_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class RecommendPage extends ConsumerStatefulWidget {
  const RecommendPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecommendPageState();
}

class _RecommendPageState extends ConsumerState<RecommendPage>
    with AutomaticKeepAliveClientMixin {
  late RecommendVM _vm;

  @override
  void initState() {
    super.initState();
    _vm = ref.read(recommendVMProvider.notifier);

    _vm.refresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final jokes = ref.watch(recommendVMProvider);
    debugPrint('jokes: ${jokes.jokeList.length}');
    return RefreshIndicator(
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return Container(
              height: 10.h,
              color: Colors.grey.withOpacity(0.2),
            );
          },
            itemCount: jokes.jokeList.length,
            itemBuilder: (context, index) {
              final joke = jokes.jokeList[index];
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                child: JokeItemWidget(
                  joke: joke,
                  likeAction: (id) {},
                  disLikeAction: (id) {},
                  commentAction: (id) {
                    _showCommentBottomSheet(context, joke);
                  },
                  shareAction: (id) {},
                ),
              );
            }),
        onRefresh: () {
          return _vm.refresh();
        });
  }

  @override
  bool get wantKeepAlive => true;

  void _showCommentBottomSheet(BuildContext context, JokeDetailModel joke) {
    showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10), topLeft: Radius.circular(10)),
        ),
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            height: ScreenUtil().screenHeight * 0.75,
            child: CommentView(jokeId: joke.joke.jokesId,),
          );
        });

  }

}
