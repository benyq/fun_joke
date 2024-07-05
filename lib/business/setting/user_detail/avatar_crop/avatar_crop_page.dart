import 'dart:io';

import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fun_joke/business/setting/user_detail/avatar_crop/avatar_crop_view_model.dart';
import 'package:fun_joke/common/view_state/default_state_widget.dart';

class AvatarCropPage extends StatefulWidget {
  final File imgFile;
  const AvatarCropPage({super.key, required this.imgFile});

  @override
  State<AvatarCropPage> createState() => _AvatarCropPageState();
}

class _AvatarCropPageState extends State<AvatarCropPage> {

  late final CustomImageCropController _controller;
  final AvatarCropVM _avatarCropVM = AvatarCropVM();

  @override
  void initState() {
    super.initState();
    _controller = CustomImageCropController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('上传头像'), centerTitle: true, actions: [
        ElevatedButton(onPressed: ()async{
          var result = await uploadAvatar();
          if (result != null && mounted) {
            Navigator.pop(context, result);
          }
        }, child: const Text('完成'))
      ],),
      body: CustomImageCrop(
        cropController: _controller,
        shape: CustomCropShape.Square,
        cropPercentage: 0.75,
        canRotate: false,
        imageFit: CustomImageFit.fillVisibleWidth,
        customProgressIndicator: defaultLoadingWidget(),
        image: FileImage(widget.imgFile),
      ),
    );
  }

  Future<String?> uploadAvatar() async {
    SmartDialog.showLoading(msg:'loading...');
    final image = await _controller.onCropImage();
    String? resultPath;
    if (image != null) {
      resultPath = await _avatarCropVM.cropImage(image);
    }
    SmartDialog.dismiss();
    return resultPath;
  }
}
