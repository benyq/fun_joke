import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fun_joke/app_providers/api_provider.dart';
import 'package:fun_joke/business/joke/publish_joke/publish_joke_state.dart';
import 'package:fun_joke/utils/joke_log.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

part 'publish_view_model.g.dart';

@riverpod
class PublishJokeVM extends _$PublishJokeVM {

  late TextEditingController _contentController;
  TextEditingController get contentController => _contentController;

  @override
  PublishJokeState build() {
    _contentController = TextEditingController()..addListener(() {
      state = state.copyWith(contentLength: _contentController.text.length);
    });
    ref.onDispose(() {
      _contentController.dispose();
    });
    return PublishJokeState.defaultState();
  }

  void selectImage(BuildContext context) async{
    var assets = await AssetPicker.pickAssets(context,
        pickerConfig: AssetPickerConfig(
            selectedAssets: state.selectedImageAssets,
            requestType: RequestType.image,
            maxAssets: 9,
            gridCount: 3,
            pageSize: 30));
    if(assets != null){
      List<AssetEntity> newAssets = [];
      List<String> images = [];
      for(var asset in assets) {
        File? imgFile = await asset.file;
        if (imgFile != null) {
          images.add(imgFile.path);
          newAssets.add(asset);
        }
      }
      state = state.copyWith(selectedImageAssets: newAssets, imagePaths: images);
    }
  }

  void selectVideo(BuildContext context) async{
    var assets = await AssetPicker.pickAssets(context,
        pickerConfig: AssetPickerConfig(
            selectedAssets: state.videoEntity != null ? [state.videoEntity!] : [],
            requestType: RequestType.video,
            maxAssets: 1,
            gridCount: 3,
            pageSize: 30));
    if(assets != null){
      var newFile = await assets.first.file;
      state = state.copyWith(videoEntity: assets.first, videoFile: newFile);
    }
  }

  void clearImage() {
    state = state.copyWith(selectedImageAssets: [], imagePaths: []);
  }
  void clearVideo() {
    state = state.copyWith(videoEntity: null, videoFile: null);
  }

  bool get isShowingImage => state.selectedImageAssets.isNotEmpty;

  void publishJoke(String content, List<AssetEntity> assets)async {
    var api = await ref.read(apiProvider);

  }
}