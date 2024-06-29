import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_joke/app_providers/user_provider/user_provider.dart';
import 'package:fun_joke/app_providers/user_provider/user_state.dart';
import 'package:fun_joke/app_providers/user_service.dart';
import 'package:fun_joke/business/joke/examining_joke/examine_joke_page.dart';
import 'package:fun_joke/business/user/mine/mine_view_model.dart';
import 'package:fun_joke/utils/asset_util.dart';

const default_bg = Color(0xFFEDEDED);

class MinePage extends ConsumerStatefulWidget {
  const MinePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MinePageState();
}

class _MinePageState extends ConsumerState<MinePage> {

  @override
  void initState() {
    super.initState();
    ref.read(minePageVMProvider.notifier).getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userManagerProvider);
    final isLoggedIn = user.isLoggedIn;
    final basicInfo = ref.watch(minePageVMProvider);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: default_bg,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: default_bg,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _basicUserInfo(user, () {
                if (UserService.checkLogin(context)) {

                }
              }),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _userInfoItemCell('关注', isLoggedIn ? basicInfo.attentionNum.toString() :'-'),
                  _userInfoItemCell('粉丝', isLoggedIn ? basicInfo.fansNum.toString() :'-'),
                  _userInfoItemCell('乐豆', isLoggedIn ? basicInfo.experienceNum.toString() :'-'),
                ],
              ),
              const SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _postItemCell('帖子', 'post', Colors.greenAccent),
                    _postItemCell('评论', 'comment', Colors.blueAccent),
                    _postItemCell('赞过', 'thumb_up', Colors.redAccent),
                    _postItemCell('收藏', 'collect', Colors.deepOrangeAccent),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Column(
                children: [
                  _functionItemCell('审核中', '审核中', action: () {
                    if (UserService.checkLogin(context)) {
                      Navigator.push(context, CupertinoPageRoute(builder: (context) {
                        return ExamineJokePage(status: 0);
                      }));
                    }
                  }),
                  _functionItemCell('审核失败', '失败', action: () {
                    if (UserService.checkLogin(context)) {
                      Navigator.push(context, CupertinoPageRoute(builder: (context) {
                        return ExamineJokePage(status: 1);
                      }));
                    }
                  }),
                  const SizedBox(height: 20),
                  _functionItemCell('分享给朋友', '分享'),
                  _functionItemCell('意见反馈', '意见反馈'),
                  _functionItemCell('设置', '设置'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _userInfoItemCell(String title, String value, {VoidCallback? action}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: action,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value),
          Text(title),
        ],
      ),
    );
  }

  Widget _postItemCell(String title, String iconName, Color color,
      {VoidCallback? action}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: action,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.all(6),
            child: Image(
              image: AssetUtil.getAssetImage(iconName),
              width: 20,
              height: 20,
            ),
          ),
          const SizedBox(height: 4,),
          Text(title),
        ],
      ),
    );
  }

  Widget _functionItemCell(String title, String iconName, {VoidCallback? action}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: action,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            Image(
              image: AssetUtil.getAssetImage(iconName),
              width: 25,
              height: 25,
            ),
            const SizedBox(width: 10,),
            Text(title, style: TextStyle(fontSize: 16),),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded, size: 15, color: Colors.grey,),
          ],
        ),
      ),
    );
  }


  Widget _circleAvatar(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Image(
        image: AssetUtil.getAssetImage('default_avatar'),
        width: 50,
        height: 50,
      ),
      errorWidget: (context, url, error) => Image(
        image: AssetUtil.getAssetImage('default_avatar'),
        width: 50,
        height: 50,
      ),
    );
  }


  Widget _basicUserInfo(UserState user, VoidCallback? action) {
    final isLoggedIn = user.isLoggedIn;
    return Row(
      children: [
        _circleAvatar(user.avatar),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: action,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLoggedIn ? user.nickname : '登录/注册',
                      style: const TextStyle(
                          fontSize: 18, color: Colors.black),
                    ),
                    Text(isLoggedIn? user.signature : '快来开始你的创作吧~'),
                  ],
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey)
              ],
            ),
          ),
        ),
      ],
    );
  }

}
