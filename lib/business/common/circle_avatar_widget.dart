import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fun_joke/utils/asset_util.dart';

class AvatarWidget extends StatelessWidget {

  final String imageUrl;
  final double size;
  final String defaultImg;
  final BoxFit fit;

  const AvatarWidget({super.key, required this.imageUrl, required this.size, this.defaultImg = 'default_avatar', this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) => Image(
        image: AssetUtil.getAssetImage(defaultImg),
      ),
      fit: fit,
      width: size,
      height: size,
    );
  }
}
