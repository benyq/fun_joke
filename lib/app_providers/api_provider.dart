import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_joke/app_providers/user_service.dart';
import 'package:fun_joke/http/joke_service.dart';

final apiProvider = Provider((ref)async{
  // api中会用到缓存的token，用法还是很怪
  await UserService.instance.init();
  return JokeService();
});