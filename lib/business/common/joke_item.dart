import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fun_joke/business/common/circle_avatar_widget.dart';
import 'package:fun_joke/business/common/joke_video_player.dart';
import 'package:fun_joke/business/common/photo_preview/photo_preivew_page.dart';
import 'package:fun_joke/models/joke_detail_model.dart';
import 'package:fun_joke/utils/joke_log.dart';
import 'package:fun_joke/utils/media_util.dart';

class JokeItemWidget extends StatelessWidget {
  final JokeDetailModel joke;
  final void Function(int jokeId) likeAction;
  final void Function(int jokeId) disLikeAction;
  final void Function(int jokeId) commentAction;
  final void Function(int jokeId) shareAction;

  const JokeItemWidget(
      {super.key,
      required this.joke,
      required this.likeAction,
      required this.disLikeAction,
      required this.commentAction,
      required this.shareAction});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipOval(
              child: CircleAvatarWidget(
                imageUrl: joke.user.avatar,
                size: 35.w,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(joke.user.nickName ?? ""),
                  Text(
                    joke.user.signature ?? "--",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.blue,
                    size: 15,
                  ),
                  Text(
                    '关注',
                    style: TextStyle(color: Colors.blue),
                  )
                ],
              ),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz))
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Builder(builder: (context) {
          if (joke.joke.type == 1) {
            return _contentText(context, joke.joke);
          }
          if (joke.joke.type == 2) {
            return _contentImage(context, joke.joke);
          } else {
            return _contentVideo(context, joke.joke);
          }
        }),
        SizedBox(
          height: 15.h,
        ),
        Row(
          children: [
            Expanded(
                child: Center(
                    child: _jokeInfoItem(
                        Icons.favorite_border, joke.info.likeNum, () {
                          likeAction(joke.joke.jokesId);
                        }
            ))),
            Expanded(
                child: Center(
                    child: _jokeInfoItem(
                        Icons.report, joke.info.disLikeNum, () {
                          disLikeAction(joke.joke.jokesId);
                    }))),
            Expanded(
                child: Center(
                    child: _jokeInfoItem(Icons.comment,
                        joke.info.commentNum, () {
                          commentAction(joke.joke.jokesId);
                        }))),
            Expanded(
                child: Center(
                    child: _jokeInfoItem(
                        Icons.share, joke.info.shareNum, () {
                      shareAction(joke.joke.jokesId);
                    }))),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }

  Widget _jokeInfoItem(IconData iconData, int value, VoidCallback onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            size: 20.w,
          ),
          SizedBox(
            width: 5.w,
          ),
          Text(
            value.toString(),
            style: const TextStyle(color: Colors.black, fontSize: 14),
          )
        ],
      ),
    );
  }

  Widget _contentText(BuildContext context, Joke joke) {
    return Text(
      joke.content,
      style: const TextStyle(color: Colors.black, fontSize: 16),
    );
  }

  Widget _contentImage(BuildContext context, Joke joke) {
    var imgUrls = joke.imageUrl.split(',');
    Widget picBody;
    var maxWidth = 330.w;
    var maxHeight = 247.5.w;
    if (imgUrls.length > 1) {
      //多图
      var imageSize = imgUrls.length;
      double spacing = 12.w;
      var size = (maxWidth - spacing * (imageSize - 1)) / imageSize;
      picBody = Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: imgUrls.map((e) => _picItem(context, e, [Size.square(size)], 6.w, imgUrls, fit: BoxFit.fitWidth)).toList()
      );
    }else {
      var displayWidth = maxWidth;
      var displayHeight =maxHeight;
      var imageUrl = imgUrls[0];
      var realSize = joke.imageSize?.split('x').map((e) => double.parse(e)).toList();

      if (realSize != null) {
        var imageWidth = realSize[0];
        var imageHeight = realSize[1];
        Size displaySize = getDisplaySize(imageWidth, imageHeight, displayWidth, displayHeight);
        displayWidth = displaySize.width;
        displayHeight = displaySize.height;
      }
      picBody = _picItem(context, imageUrl, [Size(displayWidth, displayHeight)], 6.w, imgUrls);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(joke.content),
        SizedBox(
          height: 10.h,
        ),
        picBody,
      ],
    );
  }

  Widget _picItem(BuildContext context, String url, List<Size> sizes, double radius, List<String> imgUrls, {BoxFit fit = BoxFit.cover}) {
    var size = sizes[0];
    return GestureDetector(
      onTap: () {
        var index = imgUrls.indexOf(url);
        Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation, secondAnimation) {
          return FadeTransition(opacity: animation, child: PhotoPreviewPage(imageUrls: imgUrls, index: index, sizes: sizes,),);
        }));
      },
      child: Hero(
        tag: url,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: CachedNetworkImage(imageUrl: decodeMediaUrl(url), fit: fit, width: size.width, height: size.height, )),
      ),
    );
  }

  Widget _contentVideo(BuildContext context, Joke joke) {
    var randomVideo = getTestVideoInfo();
    final maxWidth = 330.w;
    final maxHeight = 247.5.w;
    var displayWidth = maxWidth;
    var displayHeight = maxHeight;

    var size = getDisplaySize(randomVideo['width'].toDouble(), randomVideo['height'].toDouble(), maxWidth, maxHeight);
    displayWidth = size.width;
    displayHeight = size.height;
    JokeLog.i('_contentVideo: $randomVideo');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(joke.content),
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
          width: displayWidth,
          height: displayHeight,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.w),
              child: JokeVideoPlayer(videoUrl: randomVideo['videoUrl'])),
        )
      ],
    );
  }

  Size getDisplaySize(double realWidth, double realHeight, double maxWidth, double maxHeight) {
    double realRatio = realWidth / realHeight;
    double displayWidth = 0;
    double displayHeight = 0;
    if (realRatio > 1) {
      /// 照片实际宽度>=实际高度
      if (maxWidth > realWidth) {
        ///照片最大显示宽度>照片实际宽度
        displayWidth = realWidth;
        displayHeight = realHeight;
      }else {
        double displayRatio = maxWidth / realWidth;
        displayWidth = maxWidth;
        displayHeight = displayRatio * realHeight;
      }
    }else {
      if (maxHeight > realHeight) {
        ///照片最大显示高度>照片实际高度
        displayWidth = realWidth;
        displayHeight = realHeight;
      }else {
        double displayRatio = maxHeight / realHeight;
        displayWidth = displayRatio * realWidth;
        displayHeight = maxHeight;
      }
    }
    return Size(displayWidth, displayHeight);
  }
}
