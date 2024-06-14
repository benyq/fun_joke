import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fun_joke/business/home/recommend/recommend_view_model.dart';
import 'package:fun_joke/models/joke_detail_model.dart';
import 'package:fun_joke/utils/asset_util.dart';

class RecommendPage extends ConsumerStatefulWidget {
  const RecommendPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecommendPageState();

}

class _RecommendPageState extends ConsumerState<RecommendPage> {

  late RecommendVM _vm;

  @override
  void initState() {
    super.initState();
    _vm = ref.read(recommendVMProvider.notifier);

    _vm.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final jokes = ref.watch(recommendVMProvider);

    debugPrint('jokes: ${jokes.jokeList.length}');
    return RefreshIndicator(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: ListView.builder(
              itemCount: jokes.jokeList.length,
              itemBuilder: (context, index) {
                final joke = jokes.jokeList[index];
                return itemBuilder(context, joke);
              }),
        ),
        onRefresh: () {
          return _vm.refresh();
        });
  }

  Widget itemBuilder(BuildContext context, JokeDetailModel joke) {
    return Column(
      children: [
        Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: joke.user.avatar,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => Image(
                  image: AssetUtil.getAssetImage('default_avatar'),
                ),
                width: 35.w,
                height: 35.w,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(joke.user.nickName),
                  Text(
                    joke.user.signature,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.blue,
                  ),
                  Text(
                    '关注',
                    style: TextStyle(color: Colors.blue),
                  )
                ],
              ),
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz))
          ],
        ),
        Builder(builder: (context) {
          if (joke.joke.type == 1) {
            return _contentText(context, joke.joke);
          } else {
            return Text('Hello');
          }
        }),
        Row(
          children: [
            Expanded(child: Center(child: _jokeInfoItem(Icons.favorite_border, '1', () {}))),
            Expanded(child: Center(child: _jokeInfoItem(Icons.report, '2', () {}))),
            Expanded(child: Center(child: _jokeInfoItem(Icons.comment, '3', () {}))),
            Expanded(child: Center(child: _jokeInfoItem(Icons.share, '4', () {}))),
          ],
        )
      ],
    );
  }

  Widget _jokeInfoItem(IconData iconData, String value, VoidCallback onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            size: 25.w,
          ),
          Text(
            '',
            style: TextStyle(color: Colors.black),
          )
        ],
      ),
    );
  }

  Widget _contentText(BuildContext context, Joke joke) {
    return Text(joke.content);
  }

  Widget _contentImage(BuildContext context, Joke joke) {
    return Text(joke.content);
  }

  Widget _contentVideo(BuildContext context, Joke joke) {
    return Text(joke.content);
  }
}