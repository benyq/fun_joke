import 'package:flutter/material.dart';

class AssetUtil {
  static AssetImage getAssetImage(String path, [suffix = ".png"]) {
    return AssetImage("assets/images/$path$suffix");
  }
}