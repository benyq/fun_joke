import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';

/// 协调滚动布局页面基础组件
mixin NestedPage {

  final ScrollController scrollController = ScrollController();

  Widget buildView(BuildContext context) {
    return Scaffold(
        body: ExtendedNestedScrollView(
            controller: scrollController,
            onlyOneScrollInBody: true,
            headerSliverBuilder: (context, value) {
              return [buildNestedHeader(context)];
            },
            pinnedHeaderSliverHeightBuilder: () {
              return pinnedHeaderHeight(context);
            },
            body: buildNestedBody(context)));
  }

  double pinnedHeaderHeight(BuildContext context) => 0.0;

  Widget buildNestedHeader(BuildContext context);

  Widget buildNestedBody(BuildContext context);

  void preInit() {}
}
