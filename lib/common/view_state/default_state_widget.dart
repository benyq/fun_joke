import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fun_joke/http/http_error.dart';
import 'package:fun_joke/utils/asset_util.dart';
import 'package:lottie/lottie.dart';


/// 默认页面状态视图组件（加载中、加载失败、网络错误、空布局）
Widget defaultLoadingWidget() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 40.w),
        ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.blue,
              BlendMode.srcIn,
            ),
            child: Lottie.asset("view_loading".lottie,
                width: 256.w, height: 256.w)),
        // Text("加载中...",
        //     style: TextStyle(
        //         color: ColorPalettes.instance.thirdText, fontSize: 26.w)),
        SizedBox(height: 40.w),
      ],
    ),
  );
}

Widget defaultEmptyWidget(BuildContext context, {int? errorCode, String? errorMessage, VoidCallback? retryBlock}) {
  return InkWell(
    onTap: retryBlock,
    child: Center(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40.w),
            Container(
                width: 256.w,
                height: 256.w,
                alignment: Alignment.center,
                child: Image.asset("ic_view_empty".webp,
                    width: 120.w,
                    height: 120.w,
                    color: Colors.blue)),
            Text("暂无数据，点击刷新",
                style: TextStyle(
                    color: Colors.blue, fontSize: 26.w)),
            SizedBox(height: 40.w),
          ],
        ),
      ),
    ),
  );
}

Widget defaultErrorWidget(BuildContext context, {int? errorCode, String? errorMessage, VoidCallback? retryBlock}) {
  return InkWell(
    onTap: retryBlock,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 40.w),
          Container(
              width: 256.w,
              height: 256.w,
              alignment: Alignment.center,
              child: Image.asset(
                  (errorCode == HttpErrorCode.CODE_NETWORK_ERROR)
                      ? "ic_view_network_error".webp
                      : "ic_view_fail".webp,
                  width: 180.w,
                  height: 180.w,
                  color: Colors.blue)),
          Text("${errorMessage ?? "未知错误"}，点击重试",
              style: TextStyle(
                  color: Colors.black, fontSize: 26.w)),
          SizedBox(height: 40.w),
        ],
      ),
    ),
  );
}