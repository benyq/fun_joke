import 'package:flutter/material.dart';
import 'package:fun_joke/utils/asset_util.dart';

const default_bg = Color(0xFFEDEDED);

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  late VoidCallback _loginAction;

  @override
  void initState() {
    super.initState();
    _loginAction = () {
      Navigator.pushNamed(context, '/login');
    };
  }

  @override
  Widget build(BuildContext context) {
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
              Row(
                children: [
                  Image(
                    image: AssetUtil.getAssetImage('default_avatar'),
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _loginAction,
                      child: const Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '登录/注册',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                              Text('快来开始你的创作吧~')
                            ],
                          ),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _userInfoItemCell('关注', '-'),
                  _userInfoItemCell('粉丝', '-'),
                  _userInfoItemCell('乐豆', '-'),
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
                  _functionItemCell('审核中', '审核中'),
                  _functionItemCell('审核失败', '失败'),
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
      onTap: action ?? _loginAction,
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
      onTap: action ?? _loginAction,
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
}
