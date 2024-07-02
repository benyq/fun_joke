import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fun_joke/business/common/joke_item.dart';
import 'package:fun_joke/business/joke/examining_joke/examine_joke_view_model.dart';
import 'package:fun_joke/common/paging_widget/page_data_widget.dart';
import 'package:fun_joke/common/view_state/state_view_widget.dart';
import 'package:fun_joke/utils/joke_log.dart';

class ExamineJokePage extends ConsumerWidget with StateViewMixin, PageStateWidgetMixin{
  ExamineJokePage({super.key, required this.status});

  final int status;
  late WidgetRef _ref;
  late ExamineJokeVMProvider _jokeProvider;

  @override
  Widget buildPagingList(WidgetRef ref) {
    var jokes = ref.watch(_jokeProvider.select((value) => value.data?.jokes)) ?? [];
    return ListView.builder(
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
              },
              shareAction: (id) {},
            ),
          );
    });
  }


  @override
  AppBar? buildAppBar() {
    return AppBar(
      title: Text('审核列表'),
    );
  }

  @override
  void refreshData() {
    _ref.read(_jokeProvider.notifier).refresh();
  }

  @override
  void loadMoreData() {
    _ref.read(_jokeProvider.notifier).loadMoreData();
  }

  @override
  EasyRefreshController? createRefreshController() {
    return _ref.read(_jokeProvider.notifier).refreshController;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _jokeProvider = examineJokeVMProvider.call(status);
    _ref = ref;
    var state = ref.watch(_jokeProvider);
    JokeLog.i('ExamineJokePage $state');
    return buildView(context, ref, state);
  }

}
