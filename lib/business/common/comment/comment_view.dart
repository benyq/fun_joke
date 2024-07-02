import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fun_joke/app_providers/user_service.dart';
import 'package:fun_joke/business/common/circle_avatar_widget.dart';
import 'package:fun_joke/business/common/comment/comment_view_model.dart';
import 'package:fun_joke/models/joke_comment_model.dart';

class CommentView extends ConsumerStatefulWidget {
  final int jokeId;
  const CommentView({super.key, required this.jokeId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CommentBottomSheetState();
}

class _CommentBottomSheetState extends ConsumerState<CommentView> {

  late String _jokeId;
  late TextEditingController _commentController;

  bool _enableSendComment = false;


  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController()..addListener(() {
      setState(() {
        _enableSendComment = _commentController.text.isNotEmpty;
      });
    });
    _jokeId = widget.jokeId.toString();
    ref.read(commentVMProvider.notifier).getCommentList(_jokeId);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final vm = ref.read(commentVMProvider.notifier);
    final comments = ref.watch(commentVMProvider.select((value) => value.commentList));
    final commentSize = ref.watch(commentVMProvider.select((value) => value.commentSize));
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Column(
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
          SizedBox(height: 10.h),
          Expanded(child: comments.isEmpty ? const SizedBox() : MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  var comment = comments[index];
                  return _itemComment(comment);
                }),
          )),
          const Divider(color: Colors.grey,),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 35.h,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: TextField(
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
                  if (_commentController.text.isNotEmpty) {
                    if (UserService.checkLogin(context)) {

                    }
                  }
                },
                child: Icon(Icons.send_rounded, size: 27.h, color: _enableSendComment? Colors.blue: Colors.grey,))
            ],
          )
        ],
      ),
    );
  }

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
