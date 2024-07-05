import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fun_joke/business/common/photo_preview/photo_preivew_page.dart';
import 'package:fun_joke/business/setting/user_detail/avatar_crop/avatar_crop_page.dart';
import 'package:fun_joke/business/setting/user_detail/edit_user_info_page.dart';
import 'package:fun_joke/business/setting/user_detail/user_detail_apge.dart';
import 'package:fun_joke/splash_page.dart';

import 'business/user/login/login_page.dart';

class AppRoutes {
  static const indexPage = "/";
  static const loginPage = "/login";
  static const previewPage = "/preview";
  static const userDetailPage = "/userDetail";
  static const editUserInfo = "/editUserInfo";
  static const userEditCropAvatarPage = "/userEditCropAvatarPage";

  static final Map<String, Widget Function(BuildContext, Object?)> routes = {
    indexPage: (context, args) => const SplashPage(),
    loginPage: (context, args) => const LoginPage(),
    previewPage: (context, args) {
      PreviewArgument bundle = args as PreviewArgument;
      return PhotoPreviewPage(
        index: bundle.index,
        imageUrls: bundle.images,
      );
    },
    userDetailPage: (context, args) => const UserDetailPage(),
    editUserInfo: (context, args) {
      EditUserInfoArgument bundle = args as EditUserInfoArgument;
      return EditUserInfoPage(
          title: bundle.title,
          value: bundle.value,
          maxLength: bundle.maxLength,
          desc: bundle.desc);
    },
    userEditCropAvatarPage: (context, args) {
      return AvatarCropPage(imgFile: args as File,);
    },
  };
}
