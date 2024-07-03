import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fun_joke/business/app_theme.dart';
import 'package:fun_joke/business/home/follow/follow_page.dart';
import 'package:fun_joke/business/home/home_page_type.dart';
import 'package:fun_joke/business/home/joke_list/joke_list_Page.dart';
import 'package:fun_joke/business/home/search/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {

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
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appDefaultBackgroundColor, toolbarHeight: 0,),
      body: DefaultTabController(
        length: 5,
        initialIndex: 1,
        child: Column(
          children: [
            Container(
              height: 50.w,
              color: appDefaultBackgroundColor,
              child: Row(
                children: [
                  TabBar(
                      tabAlignment: TabAlignment.start,
                      physics: const BouncingScrollPhysics(),
                      indicator: const BoxDecoration(color: Colors.transparent,),
                      isScrollable: true,
                      labelPadding: EdgeInsets.symmetric(horizontal: 10.w),
                      labelStyle:
                      TextStyle(fontSize: 20.sp, color: Colors.black),
                      unselectedLabelStyle:
                      TextStyle(fontSize: 18.sp, color: Colors.grey),
                      tabs: const [
                        Tab(text: '关注'),
                        Tab(text: '推荐'),
                        Tab(text: '新鲜'),
                        Tab(text: '纯文'),
                        Tab(text: '趣图'),
                      ]),
                  const Spacer(),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, CupertinoPageRoute(builder: (context){
                        return const SearchPage();
                      }));
                    },
                      child: const Icon(Icons.search_rounded, size: 30, )),
                  SizedBox(width: 10.w,)
                ],
              ),
            ),
            const Expanded(
                child: TabBarView(children: [
                  FollowPage(),
                  JokeListWidget(type: HomePageType.RECOMMEND),
                  JokeListWidget(type: HomePageType.FRESH),
                  JokeListWidget(type: HomePageType.TEXT),
                  JokeListWidget(type: HomePageType.IMAGE),
                ]))
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

