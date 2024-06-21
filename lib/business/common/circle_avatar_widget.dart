import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fun_joke/utils/asset_util.dart';

class CircleAvatarWidget extends StatelessWidget {

  final String imageUrl;
  final double size;
  final String defaultImg;

  const CircleAvatarWidget({super.key, required this.imageUrl, required this.size, this.defaultImg = 'default_avatar'});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => Image(
          image: AssetUtil.getAssetImage(defaultImg),
        ),
        width: size,
        height: size,
      ),
    );
  }
}
