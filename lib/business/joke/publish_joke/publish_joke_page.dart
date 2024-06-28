import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fun_joke/business/common/joke_video_player.dart';
import 'package:fun_joke/business/common/photo_preview/photo_preivew_page.dart';
import 'package:fun_joke/business/joke/publish_joke/publish_view_model.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

const _maxContentLength = 300;

class PublishJokePage extends ConsumerStatefulWidget {
  const PublishJokePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PublishJokePageState();

}

class _PublishJokePageState extends ConsumerState<PublishJokePage> {

  @override
  Widget build(BuildContext context) {
    final jokeVM = ref.read(publishJokeVMProvider.notifier);
    final selectedImageAssets = ref.watch(publishJokeVMProvider.select((value) => value.selectedImageAssets));
    final imagePaths = ref.watch(publishJokeVMProvider.select((value) => value.imagePaths));
    final videoFile = ref.watch(publishJokeVMProvider.select((value) => value.videoFile));
    final contentLength = ref.watch(publishJokeVMProvider.select((value) => value.contentLength));
    ref.listen(publishJokeVMProvider.select((value)=>value.publishSuccess), (previous, next) {
      if (next) {
        SmartDialog.showToast('发布成功');
        Navigator.of(context).pop();
      }
    });
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 30.w,
                  ),
                ),
                const Expanded(
                    child: Center(
                  child: Text(
                    '发布帖子',
                    style: TextStyle(fontSize: 18),
                  ),
                )),
                GestureDetector(
                  onTap: (){
                    jokeVM.publishJoke();
                  },
                  child: const Text('发布', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey.withOpacity(0.3),
          ),
          SizedBox(
              width: double.infinity,
              height: 230.h,
              child: TextField(
                maxLines: 30,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(_maxContentLength),
                ],
                controller: jokeVM.contentController,
                decoration: InputDecoration(
                    hintText: '来点料呗，我送你上推荐~',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.w),
                        borderSide: BorderSide.none),
                    fillColor: Colors.grey.withOpacity(0.2)),
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (!jokeVM.isShowingImage) {
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          title: const Text('提示'),
                          content: const Text('是否取消选择图片？'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text('取消')),
                            TextButton(
                                onPressed: () {
                                  jokeVM.clearVideo();
                                  Navigator.of(context).pop(true);
                                  jokeVM.selectImage(context);
                                },
                                child: const Text('确定'))
                            ]);
                      });
                    }else {
                      jokeVM.selectImage(context);
                    }
                  },
                  child: Icon(
                    Icons.image,
                    size: 35.w,
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                GestureDetector(
                  onTap: () {
                    jokeVM.selectVideo(context);
                  },
                  child: Icon(
                    Icons.ondemand_video,
                    size: 35.w,
                  ),
                ),
                const Spacer(),
                Text('$contentLength / $_maxContentLength字')
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Stack(
                children: [
                  Visibility(
                    visible: selectedImageAssets.isNotEmpty,
                    child: GridView.builder(
                        itemCount: selectedImageAssets.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 3.w,
                            mainAxisSpacing: 3.w,
                            crossAxisCount: 3),
                        itemBuilder: (context, index) {
                          final asset = selectedImageAssets[index];
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation, secondAnimation) {
                                return FadeTransition(opacity: animation, child: PhotoPreviewPage(imageUrls: imagePaths, index: index),);
                              }));
                            },
                              child: Hero(
                                tag: imagePaths[index],
                                  child: AssetEntityImage(asset, isOriginal: false, fit: BoxFit.cover)));
                        }),
                  ),
                  Visibility(
                      visible: videoFile != null,
                      child: JokeVideoPlayer(videoFile: videoFile,))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
