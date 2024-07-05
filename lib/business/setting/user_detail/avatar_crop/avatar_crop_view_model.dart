import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fun_joke/utils/joke_log.dart';
import 'package:fun_joke/utils/string_util.dart';
import 'package:path_provider/path_provider.dart';



class AvatarCropVM {

  Future<String> cropImage(MemoryImage image) async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    JokeLog.i('path: $documentsDir');
    Directory avatarDir = Directory('${documentsDir.path}/avatar');
    if (!avatarDir.existsSync()) {
      avatarDir.create();
    }
    String name =
        generateMd5("avatar_crop_${DateTime.now().millisecondsSinceEpoch}") +
            ".png";
    File avatarFile = File('${avatarDir.path}/$name');
    if (avatarFile.existsSync()) {
      avatarFile.delete();
    }
    avatarFile.create();
    await avatarFile.writeAsBytes(image.bytes);
    return avatarFile.absolute.path;
  }

}