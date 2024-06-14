import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_joke/http/joke_service.dart';

final apiProvider = Provider((ref){
  return JokeService();
});