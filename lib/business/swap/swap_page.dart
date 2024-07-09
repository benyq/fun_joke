import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_joke/business/swap/swap_item.dart';
import 'package:fun_joke/business/swap/swap_view_model.dart';
import 'package:fun_joke/common/paging_widget/page_data_widget.dart';
import 'package:fun_joke/common/view_state/state_view_widget.dart';

class SwapPage extends ConsumerStatefulWidget {
  const SwapPage({super.key});

  @override
  ConsumerState<SwapPage> createState() => _SwapPageState();
}

class _SwapPageState extends ConsumerState<SwapPage>
    with StateViewMixin, PageStateWidgetMixin {
  late SwapVM _swapVM;

  @override
  void initState() {
    super.initState();
    _swapVM = ref.read(swapVMProvider.notifier);
  }

  @override
  Widget buildPagingList(WidgetRef ref) {
    final data = ref.read(swapVMProvider.select((value) => value.data)) ?? [];
    return PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: data.length,
        allowImplicitScrolling: true,
        itemBuilder: (context, index) {
          final jokeDetail = data[index];
          return SwapItem(jokeDetailModel: data[index], likeAction: (){
            _swapVM.likeJoke(jokeDetail.joke.jokesId, !jokeDetail.info.isLike);
          }, commentAction: (){
            _swapVM.showCommentBottomSheet(context, ref, jokeDetail, (joke) {
              _swapVM.updateJokeInfo(joke);
            });
          },);
        });
  }

  @override
  AppBar? buildAppBar() {
    return AppBar(
      toolbarHeight: 0,
      backgroundColor: Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(swapVMProvider);
    return buildView(context, ref, state);
  }

  @override
  EasyRefreshController? createRefreshController() {
    return _swapVM.refreshController;
  }

  @override
  void refreshData() {
    _swapVM.refresh();
  }

  @override
  void loadMoreData() {
    _swapVM.loadMoreData();
  }

  @override
  Widget? buildCustomLoadingWidget() {
    return const Center(child: CircularProgressIndicator(color: Colors.white,));
  }

  @override
  Color? backgroundColor() {
    return Colors.black;
  }
}
