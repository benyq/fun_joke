import 'dart:math';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fun_joke/app_providers/user_provider/user_provider.dart';
import 'package:fun_joke/app_providers/user_provider/user_state.dart';
import 'package:fun_joke/app_routes.dart';
import 'package:fun_joke/business/common/circle_avatar_widget.dart';
import 'package:fun_joke/business/common/nested_page.dart';
import 'package:fun_joke/business/user/mine/mine_state.dart';
import 'package:fun_joke/business/user/mine/mine_view_model.dart';
import 'package:fun_joke/business/user/user_center/user_center_view_model.dart';
import 'package:fun_joke/utils/widget_util.dart';
import 'package:visibility_detector/visibility_detector.dart';

class UserCenterPage extends ConsumerStatefulWidget {
  const UserCenterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends ConsumerState<UserCenterPage>
    with SingleTickerProviderStateMixin, NestedPage {
  late final TabController _controller;
  double _nicknameWidgetBottom = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return buildView(context);
  }

  @override
  double pinnedHeaderHeight(BuildContext context) {
    return 60.w;
  }

  @override
  Widget buildNestedBody(BuildContext context) {
    return TabBarView(
      controller: _controller,
      children: [

      ],
    );
  }

  @override
  Widget buildNestedHeader(BuildContext context) {
    final detailVM = ref.read(userCenterVMProvider.notifier);
    var currentUser = ref.watch(userManagerProvider);
    scrollController.addListener(() {
      double maxScrollOffset =
          _nicknameWidgetBottom + pinnedHeaderHeight(context);
      double fraction =
          max(0, min(1, scrollController.offset / maxScrollOffset));
      detailVM.titleBarVisibility(fraction > 0.8);
    });

    return SliverAppBar(
      expandedHeight: 320.w,
      pinned: true,
      elevation: 0,
      titleSpacing: 0,
      title: _titleBar(currentUser),
      flexibleSpace: _flexibleSpace(context),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(40.w),
        child: TabBar(
            controller: _controller,
            overlayColor:  MaterialStateProperty.all(Colors.transparent),
            physics: const BouncingScrollPhysics(),
            indicator: const BoxDecoration(color: Colors.transparent,),
            isScrollable: false,
            labelPadding: EdgeInsets.symmetric(horizontal: 10.w),
            labelStyle: TextStyle(fontSize: 20.sp, color: Colors.black),
            unselectedLabelStyle:
                TextStyle(fontSize: 18.sp, color: Colors.grey),
            tabs: const [
              Tab(text: '关注'),
              Tab(text: '推荐'),
              Tab(text: '新鲜'),
              Tab(text: '纯文'),
            ]),
      ),
    );
  }

  Widget _flexibleSpace(BuildContext context) {
    var currentUser = ref.watch(userManagerProvider);
    var mineState = ref.watch(minePageVMProvider);
    return FlexibleSpaceBar(
      collapseMode: CollapseMode.pin,
      background: Stack(
        children: [
          _blurBackground(currentUser),
          _cardBackground(),
          _flexibleContent(context, currentUser, mineState)
        ],
      ),
    );
  }

  Widget _blurBackground(UserState user) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 30.w, sigmaY: 30.w),
        child: AvatarWidget(imageUrl: user.avatar, size: double.infinity),
      ),
    );
  }

  Widget _cardBackground() {
    return Container(
        margin: EdgeInsets.only(top: 120.w),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.w),
                topRight: Radius.circular(32.w))));
  }

  Widget _flexibleContent(
      BuildContext context, UserState user, MineState mineState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 36.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VisibilityDetector(
                onVisibilityChanged: (VisibilityInfo info) {
                  if (info.visibleFraction > 0.5) {
                    _nicknameWidgetBottom = info.visibleBounds.bottom;
                  }
                },
                key: const Key('user_center_page'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    90.hSize,
                    Row(
                      children: [
                        ClipOval(
                          child: AvatarWidget(
                            imageUrl: user.avatar,
                            size: 100.w,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, AppRoutes.userDetailPage);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 20.w),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.w, horizontal: 10.w),
                              child: const Text(
                                '编辑资料',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    10.hSize,
                    Text(
                      user.nickname,
                      style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
              5.hSize,
              Text(user.signature),
              10.hSize,
              Text.rich(TextSpan(children: [
                TextSpan(
                    recognizer: TapGestureRecognizer()..onTap = () {},
                    children: [
                      TextSpan(
                          text: mineState.likeNum.toString(),
                          style: const TextStyle(color: Colors.black, fontSize: 15)),
                      WidgetSpan(
                          child: 5.wSize),
                      const TextSpan(
                          text: '获赞',
                          style: TextStyle(color: Colors.grey, fontSize: 15)),
                    ]),
                WidgetSpan(
                    child: 20.wSize),
                TextSpan(
                    recognizer: TapGestureRecognizer()..onTap = () {},
                    children: [
                      TextSpan(
                          text: mineState.attentionNum.toString(),
                          style: const TextStyle(color: Colors.black, fontSize: 15)),
                      WidgetSpan(
                          child: 5.wSize),
                      const TextSpan(
                          text: '关注',
                          style: TextStyle(color: Colors.grey, fontSize: 15)),
                    ]),
                WidgetSpan(
                    child: 20.wSize),
                TextSpan(
                    recognizer: TapGestureRecognizer()..onTap = () {},
                    children: [
                      TextSpan(
                          text: mineState.fansNum.toString(),
                          style: const TextStyle(color: Colors.black, fontSize: 15)),
                      WidgetSpan(
                          child: 5.wSize),
                      const TextSpan(
                          text: '粉丝',
                          style: TextStyle(color: Colors.grey, fontSize: 15)),
                    ]),
              ]))
            ],
          ),
        ),
        15.hSize,
        Container(
          height: 12.w,
          color: Colors.black.withOpacity(0.1),
        ),
      ],
    );
  }

  Widget _titleBar(UserState currentUser) {
    var showTitleBar =
        ref.watch(userCenterVMProvider.select((value) => value.showTitleBar));
    return PreferredSize(
        preferredSize: Size(double.infinity, 48.w),
        child: SizedBox(
          width: double.infinity,
          height: 48.w,
          child: Visibility(
            visible: showTitleBar,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipOval(
                    child:
                        AvatarWidget(imageUrl: currentUser.avatar, size: 30)),
                8.wSize,
                Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    currentUser.nickname,
                    style: const TextStyle(color: Colors.black))
              ],
            ),
          ),
        ));
  }

}
