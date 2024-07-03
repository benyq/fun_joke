import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fun_joke/app_providers/user_provider/user_provider.dart';
import 'package:fun_joke/app_providers/user_provider/user_state.dart';
import 'package:fun_joke/app_providers/user_service.dart';
import 'package:fun_joke/business/common/circle_avatar_widget.dart';
import 'package:fun_joke/business/joke/examining_joke/examine_joke_page.dart';
import 'package:fun_joke/business/setting/setting_page.dart';
import 'package:fun_joke/business/user/mine/mine_view_model.dart';
import 'package:fun_joke/business/user/user_detail/user_detail_page.dart';
import 'package:fun_joke/utils/asset_util.dart';
import 'package:fun_joke/utils/widget_util.dart';

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
        padding: EdgeInsets.all(16.w),
        color: default_bg,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _basicUserInfo(user, () {
                if (UserService.checkLogin(context)) {
                  Navigator.push(context, CupertinoPageRoute(builder: (context){
                    return const UserDetailPage();
                  }));
                }
              }),
              20.hSize,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _userInfoItemCell('关注', isLoggedIn ? basicInfo.attentionNum.toString() :'-'),
                  _userInfoItemCell('粉丝', isLoggedIn ? basicInfo.fansNum.toString() :'-'),
                  _userInfoItemCell('乐豆', isLoggedIn ? basicInfo.experienceNum.toString() :'-'),
                ],
              ),
              20.hSize,
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
              20.hSize,
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
                  20.hSize,
                  _functionItemCell('分享给朋友', '分享'),
                  _functionItemCell('意见反馈', '意见反馈'),
                  _functionItemCell('设置', '设置', action: (){
                    Navigator.push(context, CupertinoPageRoute(builder: (context){
                      return const SettingPage();
                    }));
                  }),
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
              width: 20.w,
              height: 20.w,
            ),
          ),
          4.hSize,
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
              width: 25.w,
              height: 25.w,
            ),
            10.wSize,
            Text(title, style: const TextStyle(fontSize: 16),),
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
        width: 50.w,
        height: 50.w,
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
        width: 50.w,
        height: 50.w,
      ),
      errorWidget: (context, url, error) => Image(
        image: AssetUtil.getAssetImage('default_avatar'),
        width: 50.w,
        height: 50.w,
      ),
    );
  }


  Widget _basicUserInfo(UserState user, VoidCallback? action) {
    final isLoggedIn = user.isLoggedIn;
    return Row(
      children: [
        AvatarWidget(
          imageUrl: user.avatar,
          size: 50.w,
        ),
        10.wSize,
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
