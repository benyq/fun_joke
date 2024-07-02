import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fun_joke/business/common/comment/comment_view.dart';
import 'package:fun_joke/business/common/joke_item.dart';
import 'package:fun_joke/business/home/home_page_type.dart';
import 'package:fun_joke/business/home/joke_list/joke_list_view_model.dart';
import 'package:fun_joke/common/paging_widget/page_data_widget.dart';
import 'package:fun_joke/common/view_state/state_view_widget.dart';
import 'package:fun_joke/models/joke_detail_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class JokeListWidget extends ConsumerStatefulWidget {
  final HomePageType type;
  const JokeListWidget({super.key, required this.type});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _JokeListWidgetState();

}

class _JokeListWidgetState extends ConsumerState<JokeListWidget> with AutomaticKeepAliveClientMixin, StateViewMixin, PageStateWidgetMixin{

  late JokeListVMProvider _jokeProvider;
  late final JokeListVM vm;

  @override
  void initState() {
    super.initState();
    _jokeProvider = jokeListVMProvider.call(widget.type);
    vm = ref.read(_jokeProvider.notifier);
    vm.refresh();
  }

  @override
  EasyRefreshController? createRefreshController() {
    return vm.refreshController;
  }

  @override
  void refreshData() {
    vm.refresh();
  }

  @override
  void loadMoreData() {
    vm.loadMore();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = ref.watch(_jokeProvider);
    return buildView(context, ref, state);
  }

  @override
  Widget buildPagingList(WidgetRef ref) {
    final jokes = ref.watch(_jokeProvider.select((value) => value.data))!;
    return ListView.separated(
        separatorBuilder: (context, index) {
          return Container(
            height: 10.w,
            color: Colors.grey.withOpacity(0.2),
          );
        },
        itemCount: jokes.length,
        itemBuilder: (context, index) {
          final joke = jokes[index];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.w),
            child: JokeItemWidget(
              key: ValueKey(joke.joke.jokesId),
              joke: joke,
              likeAction: (id) {},
              disLikeAction: (id) {},
              commentAction: (id) {
                _showCommentBottomSheet(context, joke);
              },
              shareAction: (id) {},
            ),
          );
        });
  }


  @override
  bool get wantKeepAlive => true;

  void _showCommentBottomSheet(BuildContext context, JokeDetailModel joke) {
    showMaterialModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.w), topLeft: Radius.circular(10.w)),
        ),
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 15.w),
            height: ScreenUtil().screenHeight * 0.75,
            child: CommentView(jokeId: joke.joke.jokesId,),
          );
        });

  }
}
