import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fun_joke/business/common/joke_item.dart';
import 'package:fun_joke/business/home/follow/follow_view_model.dart';
import 'package:fun_joke/business/user/mine/mine_page.dart';
import 'package:fun_joke/common/keep_alive_wrapper.dart';
import 'package:fun_joke/common/paging_widget/page_data_widget.dart';
import 'package:fun_joke/common/view_state/state_view_widget.dart';
import 'package:fun_joke/models/recommend_user_model.dart';
import 'package:fun_joke/utils/asset_util.dart';

class FollowPage extends ConsumerStatefulWidget {
  const FollowPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FollowPageState();
}

class _FollowPageState extends ConsumerState<FollowPage>
    with AutomaticKeepAliveClientMixin, StateViewMixin, PageStateWidgetMixin {
  late FollowVM _followVM;

  @override
  void initState() {
    super.initState();
    _followVM = ref.read(followVMProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var state = ref.watch(followVMProvider);
    return buildView(context, ref, state);
  }


  @override
  Widget buildPagingList(WidgetRef ref) {
    var users =
        ref.watch(followVMProvider.select((value) => value.data?.users)) ?? [];
    var jokes =
        ref.watch(followVMProvider.select((value) => value.data?.jokes)) ?? [];
    return ListView.separated(
        itemBuilder: (context, index) {
          if (index == 0) {
            if (users.isEmpty) {
              return Container(
                width: double.infinity,
                height: 150.w,
                decoration: BoxDecoration(
                  color: Colors.grey.shade500,
                  borderRadius: BorderRadius.circular(10.w),
                ),
              );
            } else {
              return KeepAliveWrapper(
                keepAlive: true,
                  child: _recommendUserWidget(users));
            }
          } else {
            var joke = jokes[index - 1];
            return JokeItemWidget(
                joke: joke,
                likeAction: () {},
                disLikeAction: () {},
                commentAction: () {},
                shareAction: () {});
          }
        },
        separatorBuilder: (context, index) {
          return Container(
            height: 5.w,
            color: Colors.grey.shade500,
          );
        },
        itemCount: jokes.length + 1);
  }

  @override
  Widget? buildCustomLoadingWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 150.w,
            decoration: BoxDecoration(
              color: Colors.grey.shade500,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          SizedBox(
            height: 20.w,
          ),
          Expanded(
              child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade500,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ))
        ],
      ),
    );
  }


  Widget _recommendUserWidget(List<RecommendUserModel> users) {
    return Container(
      color: default_bg,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('推荐用户'),
          SizedBox(
            height: 10.w,
          ),
          SingleChildScrollView(
            controller: ScrollController(),
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: Wrap(
              spacing: 10.w,
              children: users.map((e) => _recommendUserItem(e)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recommendUserItem(RecommendUserModel user) {
    return Container(
      width: 120.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: user.avatar,
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
          ),
          SizedBox(
            height: 5.w,
          ),
          Text(
            user.nickname,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontFamily: 'PingFang SC', fontSize: 13, color: Colors.black),
          ),
          SizedBox(
            height: 5.w,
          ),
          Text(
            '发表 ${user.jokesNum} 粉丝 ${user.fansNum}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          SizedBox(
            height: 5.w,
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(15.w),
              ),
              height: 25.w,
              child: const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 16,
                    ),
                    Text(
                      '关注',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  EasyRefreshController? createRefreshController() {
    return _followVM.refreshController;
  }

  @override
  void refreshData() {
    _followVM.refresh();
  }

  @override
  void loadMoreData() {
    _followVM.loadMore();
  }

  @override
  bool get wantKeepAlive => true;

}
