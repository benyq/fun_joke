import 'package:fun_joke/http/api_response.dart';
import 'package:fun_joke/http/dio_client.dart';
import 'package:fun_joke/models/joke_comment_model.dart';
import 'package:fun_joke/models/joke_detail_model.dart';
import 'package:dio/dio.dart';
import 'package:fun_joke/models/login_model.dart';
import 'package:fun_joke/models/recommend_user_model.dart';
import 'package:fun_joke/models/user_info_model.dart';
import 'package:retrofit/http.dart';
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

  @POST('/home/latest')
  @FormUrlEncoded()
  Future<ApiResponse<List<JokeDetailModel>>> getFreshList([@CancelRequest() CancelToken? cancelToken]);

  @POST('/home/pic')
  @FormUrlEncoded()
  Future<ApiResponse<List<JokeDetailModel>>> getImageList([@CancelRequest() CancelToken? cancelToken]);

  @POST('/home/text')
  @FormUrlEncoded()
  Future<ApiResponse<List<JokeDetailModel>>> getTextList([@CancelRequest() CancelToken? cancelToken]);

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


  /// 发布段子, 目前只支持 纯文字
  @POST('/jokes/post')
  @FormUrlEncoded()
  Future<ApiResponse<dynamic>> publishJoke(@Field() String content, @Field() int type);

  /// 获取审核列表
  /// @status 状态 0 审核中 1 审核失败
  @POST('/jokes/audit/list')
  @FormUrlEncoded()
  Future<ApiResponse<List<JokeDetailModel>>> getAuditJokes(@Field() int status, @Field() int page);

  /// 热搜
  @POST('/helper/hot_search')
  @FormUrlEncoded()
  Future<ApiResponse<List<String>>> getHotKey();

  /// 搜索Joke
  @POST('/home/jokes/search')
  @FormUrlEncoded()
  Future<ApiResponse<List<JokeDetailModel>>> searchJoke(@Field() String keyword, @Field() int page);


  @POST('/home/attention/recommend')
  @FormUrlEncoded()
  Future<ApiResponse<List<RecommendUserModel>>> getRecommendUser();


  @POST('/home/attention/list')
  @FormUrlEncoded()
  Future<ApiResponse<List<JokeDetailModel>>> getAttentionJoke(@Field() int page);


  @POST('/jokes/comment')
  @FormUrlEncoded()
  Future<ApiResponse<Comment>> publishJokeComment(@Field() String content, @Field() String jokeId);

  ///status 	true为点赞 false为取消点赞
  @POST('/jokes/like')
  @FormUrlEncoded()
  Future<ApiResponse<dynamic>> likeJoke(@Field() String id, @Field() bool status);

  ///status 	true为踩 false为取消踩
  @POST('/jokes/unlike')
  @FormUrlEncoded()
  Future<ApiResponse<dynamic>> unlikeJoke(@Field() String id, @Field() bool status);


  /// type 更新的类目 0 修改头像 先上传到七牛云 1 修改昵称 2 修改签名 3 修改性别 4 修改生日
  @POST('/user/info/update')
  @FormUrlEncoded()
  Future<ApiResponse<dynamic>> updateUserInfo(@Field() String content, @Field() int type);
}