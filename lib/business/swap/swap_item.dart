import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fun_joke/business/common/circle_avatar_widget.dart';
import 'package:fun_joke/business/common/joke_video_player.dart';
import 'package:fun_joke/models/joke_detail_model.dart';
import 'package:fun_joke/utils/joke_log.dart';
import 'package:fun_joke/utils/media_util.dart';
import 'package:fun_joke/utils/string_util.dart';
import 'package:fun_joke/utils/widget_util.dart';

class SwapItem extends StatefulWidget {
  final JokeDetailModel jokeDetailModel;
  final VoidCallback? likeAction;
  final VoidCallback? commentAction;
  final VoidCallback? shareAction;
  final VoidCallback? userCenterAction;
  final VoidCallback? followUserAction;

  const SwapItem({
    super.key,
    required this.jokeDetailModel,
    this.likeAction,
    this.commentAction,
    this.shareAction,
    this.userCenterAction,
    this.followUserAction,
  });

  @override
  State<SwapItem> createState() => _SwapItemState();
}

class _SwapItemState extends State<SwapItem> {
  late final JokeDetailModel _detailModel;

  @override
  void initState() {
    super.initState();
    _detailModel = widget.jokeDetailModel;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center, // 子Widget居中显示
      fit: StackFit.expand, // 子Widget扩展以填满Stack
      children: [
        Positioned.fill(child: _contentVideo(context, _detailModel.joke)),
        Positioned(right: 15.w, bottom: 220.w, child: _videoInfo(_detailModel)),
        Positioned(
          bottom: 100.w,
            left: 0,
            right: 0,
            child: _videoBottomWidget(
                _detailModel.user.nickName ?? "-", _detailModel.joke.content))
      ],
    );
  }

  Widget _videoInfo(JokeDetailModel joke) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _posterWidget(joke.user.avatar, joke.info.isAttention, () {
          widget.userCenterAction?.call();
        }, () {
          widget.followUserAction?.call();
        }),
        10.hSize,
        _videoInfoItem(Icons.favorite, joke.info.likeNum, () {
          widget.likeAction?.call();
        }, isSelected: joke.info.isLike),
        20.hSize,
        _videoInfoItem(Icons.comment, joke.info.commentNum, () {
          widget.commentAction?.call();
        }),
        20.hSize,
        _videoInfoItem(Icons.share, joke.info.shareNum, () {
          widget.shareAction?.call();
        }),
      ],
    );
  }

  Widget _videoBottomWidget(String nickName, String content) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "@$nickName",
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          5.hSize,
          Text(
            content,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _posterWidget(String avatar, bool isAttention, VoidCallback userAction,
      VoidCallback followAction) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: userAction,
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white, // 边框颜色
                  width: 1.w, // 边框宽度
                )),
            child: ClipOval(
              child: AvatarWidget(
                imageUrl: avatar,
                size: 50.w,
              ),
            ),
          ),
        ),
        Offstage(
          offstage: isAttention,
          child: Transform.translate(
            offset: Offset(0, -10.w),
            child: SizedBox.square(
              dimension: 20.w,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: followAction,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.add,
                    color: Colors.red,
                    size: 15.w,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _videoInfoItem(IconData iconData, int value, VoidCallback onAction,
      {bool isSelected = false}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onAction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            size: 30.w,
            color: isSelected ? Colors.red : Colors.white,
          ),
          5.hSize,
          Text(
            value.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 14),
          )
        ],
      ),
    );
  }

  Widget _contentVideo(BuildContext context, Joke joke) {
    var randomVideo = getTestVideoInfo();
    JokeLog.i('_contentVideo: $randomVideo');
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(8.w),
          child: JokeVideoPlayer(videoUrl: randomVideo['videoUrl'])),
    );
  }

}
