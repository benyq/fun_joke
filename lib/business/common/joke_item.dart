import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fun_joke/app_routes.dart';
import 'package:fun_joke/business/common/circle_avatar_widget.dart';
import 'package:fun_joke/business/common/joke_video_player.dart';
import 'package:fun_joke/business/common/photo_preview/photo_preivew_page.dart';
import 'package:fun_joke/models/joke_detail_model.dart';
import 'package:fun_joke/utils/asset_util.dart';
import 'package:fun_joke/utils/joke_log.dart';
import 'package:fun_joke/utils/media_util.dart';
import 'package:fun_joke/utils/widget_util.dart';

class JokeItemWidget extends StatelessWidget {
  final JokeDetailModel joke;
  final VoidCallback likeAction;
  final VoidCallback disLikeAction;
  final VoidCallback commentAction;
  final VoidCallback shareAction;
  final bool ownJoke;

  const JokeItemWidget(
      {super.key,
      required this.joke,
      required this.likeAction,
      required this.disLikeAction,
      required this.commentAction,
      required this.shareAction,
      this.ownJoke = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipOval(
              child: ClipOval(
                child: AvatarWidget(
                  imageUrl: joke.user.avatar,
                  size: 35.w,
                ),
              ),
            ),
            10.wSize,
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
            ownJoke? const SizedBox() : GestureDetector(
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
            )
          ],
        ),
        10.hSize,
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
        15.hSize,
        Row(
          children: [
            Expanded(
                child: Center(
                    child: _jokeInfoItem(
                        "ic_like".webp, joke.info.isLike? Colors.redAccent : Colors.black, joke.info.likeNum, () {
                          likeAction();
                        }
            ))),
            Expanded(
                child: Center(
                    child: _jokeInfoItem(
                    "ic_unlike".webp, joke.info.isUnlike? Colors.redAccent : Colors.black, joke.info.disLikeNum, () {
                          disLikeAction();
                    }))),
            Expanded(
                child: Center(
                    child: _jokeInfoItem("ic_comment".webp, Colors.black,
                        joke.info.commentNum, () {
                          commentAction();
                        }))),
            Expanded(
                child: Center(
                    child: _jokeInfoItem(
                        "ic_share".webp, Colors.black, joke.info.shareNum, () {
                      shareAction();
                    }))),
          ],
        ),
        10.hSize
      ],
    );
  }

  Widget _jokeInfoItem(String imgAsset, Color imgColor, int value, VoidCallback onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imgAsset,
            width: 20.w,
            height: 20.w,
            color: imgColor,
          ),
          8.wSize,
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
    var minWidth = maxWidth / 3;
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
        Size displaySize = getDisplaySize(imageWidth, imageHeight, displayWidth, displayHeight, minWidth: minWidth);
        displayWidth = displaySize.width;
        displayHeight = displaySize.height;
      }
      picBody = _picItem(context, imageUrl, [Size(displayWidth, displayHeight)], 6.w, imgUrls);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(joke.content),
        10.hSize,
        picBody,
      ],
    );
  }

  Widget _picItem(BuildContext context, String url, List<Size> sizes, double radius, List<String> imgUrls, {BoxFit fit = BoxFit.cover}) {
    var size = sizes[0];
    return GestureDetector(
      onTap: () {
        var index = imgUrls.indexOf(url);
        Navigator.pushNamed(context, AppRoutes.previewPage, arguments: PreviewArgument(index: index, images: imgUrls));
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
        10.hSize,
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

  Size getDisplaySize(double realWidth, double realHeight, double maxWidth, double maxHeight, {double minWidth = 0}) {
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
        if (displayHeight / displayWidth > 3 && displayWidth < minWidth) {
          displayWidth = minWidth;
        }
      }
    }
    return Size(displayWidth, displayHeight);
  }
}
