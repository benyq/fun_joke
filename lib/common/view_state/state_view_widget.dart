import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_joke/common/view_state/default_state_widget.dart';
import 'package:fun_joke/common/view_state/view_state.dart';

mixin StateViewMixin {

  late final VoidCallback? retryBlock;

  Widget buildView(BuildContext context, WidgetRef ref, ViewState state, {bool bindState = true}) {
    Widget child;
    if (state.isSuccess()) {
      child = buildBody(context, ref);
    }else if (state.isEmpty()) {
      child = buildCustomEmptyWidget() ?? defaultEmptyWidget(context);
    }else if (state.isError()) {
      child = buildCustomErrorWidget() ?? defaultErrorWidget(context, errorCode: state.errorCode, errorMessage: state.errorMessage, retryBlock: retryBlock);
    }else if (state.isLoading()) {
      child = buildCustomLoadingWidget() ?? defaultLoadingWidget();
    }else {
      child = Container();
    }

    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: backgroundColor(),
      body: child,
    );
  }

  Widget buildBody(BuildContext context, WidgetRef ref);

  Widget? buildCustomLoadingWidget() {
    return null;
  }

  Widget? buildCustomEmptyWidget() {
    return null;
  }

  Widget? buildCustomErrorWidget() {
    return null;
  }

  AppBar? buildAppBar() {
    return null;
  }

  Color? backgroundColor() {
    return null;
  }
}

