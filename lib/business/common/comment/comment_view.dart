import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fun_joke/app_providers/user_service.dart';
import 'package:fun_joke/business/common/circle_avatar_widget.dart';
import 'package:fun_joke/business/common/comment/comment_view_model.dart';
import 'package:fun_joke/common/paging_widget/page_data_widget.dart';
import 'package:fun_joke/common/view_state/state_view_widget.dart';
import 'package:fun_joke/models/joke_comment_model.dart';

class CommentView extends ConsumerStatefulWidget {
  final int jokeId;
  final ValueChanged<int> commentSizeChanged;
  const CommentView({super.key, required this.jokeId, required this.commentSizeChanged});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CommentBottomSheetState();
}

class _CommentBottomSheetState extends ConsumerState<CommentView> with StateViewMixin, PageStateWidgetMixin{

  late final String _jokeId;
  late TextEditingController _commentController;

  bool _enableSendComment = false;
  late final CommentVM _commentVM;

  @override
  void initState() {
    super.initState();
    _commentVM = ref.read(commentVMProvider.notifier);
    _commentController = _commentVM.commentController..addListener(() {
      setState(() {
        _enableSendComment = _commentController.text.isNotEmpty;
      });
    });
    _jokeId = widget.jokeId.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: buildBody(context, ref),
    );
  }


  @override
  Widget buildBody(BuildContext context, WidgetRef ref) {
    final commentSize = ref.watch(commentVMProvider.select((value) => value.commentSize));
    ref.listen(commentVMProvider.select((value) => value.commentSize), (previous, next) {
      if (next > commentSize) {
        widget.commentSizeChanged.call(next);
      }
    });
    return ScrollConfiguration(
      behavior: const ScrollBehavior()
          .copyWith(physics: const BouncingScrollPhysics()),
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          scrollNotificationCallback(scrollNotification);
          return false;
        },
        child: Column(
          children: [
            Row(
              children: [
                Text('评论($commentSize)'),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 10.w),
            Expanded(
              child: EasyRefresh(
                  header: const CupertinoHeader(),
                  controller: refreshController,
                  onRefresh: () {
                    refreshData();
                  },
                  onLoad: () {
                    loadMoreData();
                  },
                  child: buildPagingList(ref)),
            ),
            const Divider(color: Colors.grey,),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 35.w,
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(30.w),
                    ),
                    child: TextField(
                      focusNode: _commentVM.focusNode,
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: '留下你的精彩评论...',
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                SizedBox(width: 10.w,),
                GestureDetector(
                    onTap: () {
                      String content = _commentController.text;
                      if (content.isNotEmpty) {
                        if (UserService.checkLogin(context)) {
                          _commentVM.publishComment(content, _jokeId);
                        }
                      }
                    },
                    child: Icon(Icons.send_rounded, size: 27.w, color: _enableSendComment? Colors.blue: Colors.grey,))
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget buildPagingList(WidgetRef ref) {
    final comments = ref.watch(commentVMProvider.select((value) => value.commentList));
    return comments.isEmpty ? const SizedBox() : MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: ListView.builder(
          itemCount: comments.length,
          itemBuilder: (context, index) {
            var comment = comments[index];
            return _itemComment(comment);
          }),
    );
  }


  @override
  void refreshData() {
    _commentVM.refresh(_jokeId);
  }

  @override
  void loadMoreData() {
    _commentVM.loadMore(_jokeId);
  }

  @override
  EasyRefreshController get refreshController => _commentVM.refreshController;

  Widget _itemComment(Comment comment) {
    // IntrinsicHeight Row 高度居中关键
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: AvatarWidget(
              imageUrl: comment.commentUser.userAvatar,
              size: 35.w,
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.commentUser.nickname,
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    comment.content,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    comment.timeStr,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              )),
          Center(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.favorite,
                    color: comment.isLike ? Colors.red : Colors.grey,
                  ),
                  Text(
                    '${comment.likeNum}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ]),
          )
        ],
      ),
    );
  }

}
