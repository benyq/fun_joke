import 'package:fun_joke/http/api_response.dart';
import 'package:fun_joke/http/dio_client.dart';
import 'package:fun_joke/models/joke_comment_model.dart';
import 'package:fun_joke/models/joke_detail_model.dart';
import 'package:dio/dio.dart';
import 'package:fun_joke/models/login_model.dart';
import 'package:fun_joke/models/user_info_model.dart';
import 'package:retrofit/retrofit.dart';

part 'joke_service.g.dart';


@RestApi(baseUrl: 'http://tools.cretinzp.com/jokes')
abstract class JokeService {
  factory JokeService({Dio? dio, String? baseUrl}) {
    return _JokeService(DioClient().dio, baseUrl: baseUrl);
  }

  @POST('/home/recommend')
  @FormUrlEncoded()
  Future<ApiResponse<List<JokeDetailModel>>> getRecommendList([@CancelRequest() CancelToken? cancelToken]);


  /// 获取登录验证码
  @POST('/user/login/get_code')
  @FormUrlEncoded()
  Future<ApiResponse<dynamic>> getLoginVerifyCode(@Field() String phone);

  /// 获取登录验证码
  @POST('/user/login/code')
  @FormUrlEncoded()
  Future<ApiResponse<LoginModel>> loginByCode(@Field() String phone, @Field() String code);


  /// 获取用户信息
  @POST('/user/info')
  @FormUrlEncoded()
  Future<ApiResponse<UserInfoModel>> getUserInfo();


  /// 获取段子获取评论列表
  @POST('/jokes/comment/list')
  @FormUrlEncoded()
  Future<ApiResponse<JokeCommentModel>> getJokeCommentList(@Field() String jokeId, @Field() int page);
}