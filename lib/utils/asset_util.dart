import 'package:flutter/material.dart';

class AssetUtil {
  static AssetImage getAssetImage(String path, [suffix = ".png"]) {
    return AssetImage("assets/images/$path$suffix");
  }
}

extension AssetExt on String {

  String get webp => "assets/images/$this.webp";
  String get png => "assets/images/$this.png";
  String get lottie => "assets/lottie/$this.json";

}