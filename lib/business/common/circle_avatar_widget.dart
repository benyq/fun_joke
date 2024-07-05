import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fun_joke/utils/asset_util.dart';
import 'package:fun_joke/utils/media_util.dart';

class AvatarWidget extends StatelessWidget {

  final String imageUrl;
  final double size;
  final String defaultImg;
  final BoxFit fit;

  const AvatarWidget({super.key, required this.imageUrl, this.defaultImg = 'default_avatar', this.fit = BoxFit.cover, this.size = 30, });

  @override
  Widget build(BuildContext context) {
    final webImage = isNetworkImage(imageUrl);
    return webImage ? CachedNetworkImage(
      imageUrl: imageUrl,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) => Image(
        image: AssetUtil.getAssetImage(defaultImg),
      ),
      fit: fit,
      width: size,
      height: size,
    ): Image.file(File(imageUrl), width: size, height: size, fit: fit,);
  }
}
