import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fun_joke/app_providers/user_provider/user_provider.dart';
import 'package:fun_joke/app_providers/user_service.dart';
import 'package:fun_joke/app_routes.dart';
import 'package:fun_joke/business/user/mine/mine_view_model.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(
                height: 10.w, thickness: 10.w, color: const Color(0xFFEDEDED)),
            _settingItem('编辑资料', () {
              Navigator.pushNamed(context, AppRoutes.userDetailPage);
            }),
            _settingItem('账号与安全', () {
              SmartDialog.showToast('TODO');
            }),
            _settingItem('隐私设置', () {
              SmartDialog.showToast('TODO');
            }),
            Divider(
                height: 10.w, thickness: 10.w, color: const Color(0xFFEDEDED)),
            _settingItem('关于APP', () {
              _showAboutDialog(context);
            }),
            _settingItem('退出登录', () {
              _logout(ref);
            }),
          ],
        ),
      ),
    );
  }

  Widget _settingItem(String title, VoidCallback action) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: action,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20.w,
                color: Colors.grey,
              ),
            ],
          ),
        ));
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsPadding: EdgeInsets.only(right: 15.w, bottom: 10.w),
            title: const Text('关于App'),
            content: const Text('JokeFun使用Flutter开发，数据源来自【MZCretin】大佬的开源项目【段子乐】'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.blue),
                child: const Text('确定'),
              )
            ],
            surfaceTintColor: Colors.white,
          );
        });
  }

  void _logout(WidgetRef ref) {
    // 1. 清除本地存储的用户信息
    UserService.instance.logout();
    // 2. 清空userManagerProvider中的信息
    ref.read(userManagerProvider.notifier).clear();
    // 3. 清除minePageVMProvider中的信息
    ref.read(minePageVMProvider.notifier).clear();
    SmartDialog.showToast('退出登录');
  }
}
