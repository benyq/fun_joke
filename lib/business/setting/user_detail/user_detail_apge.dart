import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fun_joke/app_providers/user_provider/user_provider.dart';
import 'package:fun_joke/app_routes.dart';
import 'package:fun_joke/business/common/circle_avatar_widget.dart';
import 'package:fun_joke/business/common/photo_preview/photo_preivew_page.dart';
import 'package:fun_joke/utils/joke_log.dart';
import 'package:fun_joke/utils/widget_util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'edit_user_info_page.dart';

class UserDetailPage extends ConsumerStatefulWidget {
  const UserDetailPage({super.key});

  @override
  ConsumerState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends ConsumerState<UserDetailPage> {

  late final UserManager _userVM;

  @override
  void initState() {
    super.initState();
    _userVM = ref.read(userManagerProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userManagerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人资料'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 200.w,
              child: Center(
                  child: SizedBox(
                width: 120.w,
                height: 120.w,
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.previewPage,
                                  arguments: PreviewArgument(
                                      index: 0, images: [user.avatar]));
                            },
                            child: Hero(
                                tag: user.avatar,
                                child: ClipOval(
                                  child: AvatarWidget(imageUrl: user.avatar),
                                )))),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(20.w),
                          border: Border.all(color: Colors.white, width: 2.w),
                        ),
                        child: InkWell(
                          onTap: () {
                            _showChangeAvatarBottomSheet(context);
                          },
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )),
            ),
            Divider(
              height: 10.w,
              thickness: 10.w,
              color: const Color(0xFFEDEDED),
            ),
            _settingItem('昵称', user.nickname, () async {
              var res = await Navigator.pushNamed(
                  context, AppRoutes.editUserInfo,
                  arguments: EditUserInfoArgument(
                      title: '昵称',
                      value: user.nickname,
                      desc: '好名字可以让大家更容易记住你',
                      maxLength: 10)) as String?;
              if (res != null && res.isNotEmpty) {
                _userVM.updateUserNickName(res);
              }
            }),
            _settingItem('签名', user.signature, () async {
              var res = await Navigator.pushNamed(
                  context, AppRoutes.editUserInfo,
                  arguments: EditUserInfoArgument(
                      title: '签名',
                      value: user.signature,
                      desc: '',
                      maxLength: 22)) as String?;
              if (res != null) {
                _userVM.updateUserSignature(res);
              }
            }),
            _settingItem('性别', user.sex, () {
              _showGenderDialog(context, user.sex, (value) {
                _userVM.updateUserGender(value);
              });
            }),
            _settingItem('生日', user.birthday, () {
              _birthdayBottomSheet(context, user.birthday, (value) {
                _userVM.updateUserBirthday(value);
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _settingItem(String title, String value, VoidCallback action) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: action,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
              10.wSize,
              Expanded(
                  child: Text(
                value,
                style: const TextStyle(fontSize: 18, color: Colors.black),
                maxLines: 2,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              )),
              10.wSize,
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20.w,
                color: Colors.grey,
              ),
            ],
          ),
        ));
  }

  void _showGenderDialog(BuildContext context, String defaultValue,
      ValueChanged<String> onChanged) {
    var data = ["男", "女"];
    var index = max(0, data.indexOf(defaultValue));
    FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: index);
    var selectedValue = data[index];
    showMaterialModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.w),
            topRight: Radius.circular(10.w),
          ),
        ),
        builder: (context) {
          return Container(
            height: 200.w,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      '请选择性别',
                      style: TextStyle(fontSize: 18),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        onChanged(selectedValue);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '完成',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: ListWheelScrollView(
                      // 放大倍数
                      itemExtent: 50.w,
                      physics: const BouncingScrollPhysics(),
                      controller: scrollController,
                      diameterRatio: 1,
                      children: data
                          .map((e) => SizedBox(
                                width: double.infinity,
                                child: Center(
                                    child: Text(
                                  e,
                                  style: const TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center,
                                )),
                              ))
                          .toList(),
                      onSelectedItemChanged: (index) {
                        selectedValue = data[index];
                      }),
                )
              ],
            ),
          );
        });
  }

  void _birthdayBottomSheet(BuildContext context, String defaultValue,
      ValueChanged<String> onChanged) {
    String birthday = defaultValue;
    DateTime dateTime =
        birthday.isNotEmpty ? DateTime.parse(birthday) : DateTime.now();
    var selectedTime = birthday;
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => SizedBox(
              height: 300.w,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "请选择出生日期",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        const Spacer(),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.pop(context);
                            onChanged(selectedTime);
                          },
                          child: const Text(
                            "完成",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.w),
                  Expanded(
                      child: Localizations(
                    locale: const Locale('zh', 'CN'),
                    delegates: const [
                      GlobalMaterialLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                    ],
                    child: CupertinoDatePicker(
                      initialDateTime: dateTime,
                      mode: CupertinoDatePickerMode.date,
                      dateOrder: DatePickerDateOrder.ymd,
                      onDateTimeChanged: (date) {
                        JokeLog.i("onDateTimeChanged=${date}");
                        int month = date.month;
                        int day = date.day;
                        String monthStr =
                            (month < 10) ? "0$month" : month.toString();
                        String dayStr = (day < 10) ? "0$day" : day.toString();
                        selectedTime = "${date.year}-$monthStr-$dayStr";
                      },
                    ),
                  )),
                  SizedBox(height: 10.w),
                ],
              ),
            ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.w),
                topRight: Radius.circular(10.w))));
  }

  void _showChangeAvatarBottomSheet(BuildContext pageContext) {
    showModalBottomSheet(
        context: pageContext,
        builder: (context) {
          return Container(
              height: 240.w,
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
              child: Column(children: [
                Row(children: [
                  const Text(
                    "更换头像",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  const Spacer(),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text("取消",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          )))
                ]),
                SizedBox(height: 10.w),
                _bottomSheetItem('相册', (){
                  Navigator.pop(context);
                  _selectAvatarFromGallery(context, (file){
                    _jumpCropPage(pageContext, file);
                  });
                }),
                _bottomSheetItem('拍照', ()async{
                  Navigator.pop(context);
                  _selectAvatarFromCamera((file){
                    _jumpCropPage(pageContext, file);
                  });
                }),
                _bottomSheetItem('取消', (){
                  Navigator.pop(context);
                }),
                SizedBox(height: 10.w),
              ]));
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.w),
                topRight: Radius.circular(10.w)))
    );
  }

  Widget _bottomSheetItem(String title, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
          child: Text(title,
              style: const TextStyle(fontSize: 16, color: Colors.black), textAlign: TextAlign.center,),
        ),
      ),
    );
  }

  void _selectAvatarFromGallery(BuildContext context, ValueChanged<File> onSuccess) async{
    var assets = await AssetPicker.pickAssets(context,
        pickerConfig: const AssetPickerConfig(
            requestType: RequestType.image,
            maxAssets: 1,
            gridCount: 3,
            pageSize: 30));
    if(assets != null){
      File? imgFile = await assets[0].file;
      if (imgFile != null) {
        onSuccess(imgFile);
      }
    }
  }


  void _selectAvatarFromCamera(ValueChanged<File> onSuccess) async{
    await ImagePicker().pickImage(source: ImageSource.camera).then((value) {
      if(value != null){
        onSuccess(File(value.path));
      }
    });
  }

  void _jumpCropPage(BuildContext context, File imgFile)async {
    var res = await Navigator.pushNamed(context, AppRoutes.userEditCropAvatarPage, arguments: imgFile);
    if (res is String) {
      _userVM.updateUserAvatar(res);
    }
  }
}
