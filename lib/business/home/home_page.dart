import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fun_joke/business/app_theme.dart';
import 'package:fun_joke/business/home/follow_page.dart';
import 'package:fun_joke/business/home/recommend/recommend_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with KeepAliveParentDataMixin, TickerProviderStateMixin {
  final List<String> _tabs = ['哈哈哈1', '哈哈哈2', '哈哈哈3', '哈哈哈4', '哈哈哈5'];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appDefaultBackgroundColor, toolbarHeight: 0,),
      body: DefaultTabController(
        length: 5,
        initialIndex: 1,
        child: Column(
          children: [
            Container(
              height: 40.h,
              color: appDefaultBackgroundColor,
              child: Row(
                children: [
                  Theme(
                    data: ThemeData(
                      splashColor: Colors.blue, // 点击时的水波纹颜色设置为透明
                      highlightColor: Colors.blue, // 点击时的背景高亮颜色设置为透明
                      tabBarTheme: const TabBarTheme(dividerColor: Colors.transparent),
                    ),
                    child: TabBar(
                        tabAlignment: TabAlignment.start,
                        physics: const BouncingScrollPhysics(),
                        indicator: const BoxDecoration(color: Colors.transparent,),
                        isScrollable: true,
                        labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        labelStyle:
                        TextStyle(fontSize: 16.sp, color: Colors.black),
                        unselectedLabelStyle:
                        TextStyle(fontSize: 14.sp, color: Colors.grey),
                        tabs: [
                          Tab(text: '关注'),
                          Tab(text: '推荐'),
                          Tab(text: '新鲜'),
                          Tab(text: '纯文'),
                          Tab(text: '趣图'),
                        ]),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: (){

                    },
                      child: const Icon(Icons.search_rounded, size: 30, )),
                  SizedBox(width: 10,)
                ],
              ),
            ),
            Expanded(
                child: TabBarView(children: [
                  FollowPage(),
                  RecommendPage(),
                  FollowPage(),
                  FollowPage(),
                  FollowPage(),
                ]))
          ],
        ),
      ),
    );
  }

  @override
  void detach() {}

  @override
  bool get keptAlive => true;
}

