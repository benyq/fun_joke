// To parse this JSON data, do
//
//     final jokeDetailModel = jokeDetailModelFromJson(jsonString);

import 'dart:convert';

JokeDetailModel jokeDetailModelFromJson(String str) => JokeDetailModel.fromJson(json.decode(str));

String jokeDetailModelToJson(JokeDetailModel data) => json.encode(data.toJson());

class JokeDetailModel {
  Joke joke;
  Info info;
  User user;

  JokeDetailModel({
    required this.joke,
    required this.info,
    required this.user,
  });

  factory JokeDetailModel.fromJson(Map<String, dynamic> json) => JokeDetailModel(
    joke: Joke.fromJson(json["joke"]),
    info: Info.fromJson(json["info"]),
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "joke": joke.toJson(),
    "info": info.toJson(),
    "user": user.toJson(),
  };
}

class Info {
  int likeNum;
  int shareNum;
  int commentNum;
  int disLikeNum;
  bool isLike;
  bool isUnlike;
  bool isAttention;

  Info({
    required this.likeNum,
    required this.shareNum,
    required this.commentNum,
    required this.disLikeNum,
    required this.isLike,
    required this.isUnlike,
    required this.isAttention,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
    likeNum: json["likeNum"],
    shareNum: json["shareNum"],
    commentNum: json["commentNum"],
    disLikeNum: json["disLikeNum"],
    isLike: json["isLike"],
    isUnlike: json["isUnlike"],
    isAttention: json["isAttention"],
  );

  Map<String, dynamic> toJson() => {
    "likeNum": likeNum,
    "shareNum": shareNum,
    "commentNum": commentNum,
    "disLikeNum": disLikeNum,
    "isLike": isLike,
    "isUnlike": isUnlike,
    "isAttention": isAttention,
  };
}

class Joke {
  int jokesId;
  DateTime addTime;
  String content;
  int userId;
  int type;
  String imageUrl;
  bool hot;
  String? latitudeLongitude;
  String showAddress;
  String thumbUrl;
  String videoUrl;
  int videoTime;
  String? videoSize;
  String? imageSize;
  String? auditMsg;

  Joke({
    required this.jokesId,
    required this.addTime,
    required this.content,
    required this.userId,
    required this.type,
    required this.imageUrl,
    required this.hot,
    this.latitudeLongitude,
    required this.showAddress,
    required this.thumbUrl,
    required this.videoUrl,
    required this.videoTime,
    this.videoSize,
    this.imageSize,
    this.auditMsg,
  });

  factory Joke.fromJson(Map<String, dynamic> json) => Joke(
    jokesId: json["jokesId"],
    addTime: DateTime.parse(json["addTime"]),
    content: json["content"],
    userId: json["userId"],
    type: json["type"],
    imageUrl: json["imageUrl"],
    hot: json["hot"],
    latitudeLongitude: json["latitudeLongitude"],
    showAddress: json["showAddress"],
    thumbUrl: json["thumbUrl"],
    videoUrl: json["videoUrl"],
    videoTime: json["videoTime"],
    videoSize: json["videoSize"],
    imageSize: json["imageSize"],
    auditMsg: json["audit_msg"],
  );

  Map<String, dynamic> toJson() => {
    "jokesId": jokesId,
    "addTime": addTime.toIso8601String(),
    "content": content,
    "userId": userId,
    "type": type,
    "imageUrl": imageUrl,
    "hot": hot,
    "latitudeLongitude": latitudeLongitude,
    "showAddress": showAddress,
    "thumbUrl": thumbUrl,
    "videoUrl": videoUrl,
    "videoTime": videoTime,
    "videoSize": videoSize,
    "imageSize": imageSize,
    "audit_msg": auditMsg,
  };
}

class User {
  int userId;
  String? nickName;
  String? signature;
  String avatar;

  User({
    required this.userId,
    this.nickName,
    this.signature,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json["userId"],
    nickName: json["nickName"],
    signature: json["signature"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "nickName": nickName,
    "signature": signature,
    "avatar": avatar,
  };
}
