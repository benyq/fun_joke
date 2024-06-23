import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PublishJokeState extends Equatable {

  final AssetEntity? videoEntity;
  final File? videoFile;

  final List<AssetEntity> selectedImageAssets;
  final List<String> imagePaths;

  final int contentLength;

  final bool publishSuccess;

  const PublishJokeState({
    this.videoEntity,
    required this.videoFile,
    required this.selectedImageAssets,
    required this.imagePaths,
    required this.contentLength,
    required this.publishSuccess,
  });

  static defaultState() => const PublishJokeState(
    videoEntity: null,
    videoFile: null,
    selectedImageAssets: [],
    imagePaths: [],
    contentLength: 0,
    publishSuccess: false,
  );

  PublishJokeState copyWith({
    AssetEntity? videoEntity,
    File? videoFile,
    List<AssetEntity>? selectedImageAssets,
    List<String>? imagePaths,
    int? contentLength,
    bool? publishSuccess,
  }) {
    return PublishJokeState(
      videoEntity: videoEntity,
      videoFile: videoFile,
      selectedImageAssets: selectedImageAssets ?? this.selectedImageAssets,
      imagePaths: imagePaths ?? this.imagePaths,
      contentLength: contentLength ?? this.contentLength,
      publishSuccess: publishSuccess ?? this.publishSuccess,
    );
  }

  @override
  List<Object?> get props => [videoEntity, videoFile, selectedImageAssets, imagePaths, contentLength, publishSuccess];
}