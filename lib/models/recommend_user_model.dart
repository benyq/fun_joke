// To parse this JSON data, do
//
//     final recommendUserModel = recommendUserModelFromJson(jsonString);

import 'dart:convert';

RecommendUserModel recommendUserModelFromJson(String str) => RecommendUserModel.fromJson(json.decode(str));

String recommendUserModelToJson(RecommendUserModel data) => json.encode(data.toJson());

class RecommendUserModel {
  String avatar;
  String fansNum;
  bool isAttention;
  String jokesNum;
  String nickname;
  int userId;

  RecommendUserModel({
    required this.avatar,
    required this.fansNum,
    required this.isAttention,
    required this.jokesNum,
    required this.nickname,
    required this.userId,
  });

  factory RecommendUserModel.fromJson(Map<String, dynamic> json) => RecommendUserModel(
    avatar: json["avatar"],
    fansNum: json["fansNum"],
    isAttention: json["isAttention"],
    jokesNum: json["jokesNum"],
    nickname: json["nickname"],
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "avatar": avatar,
    "fansNum": fansNum,
    "isAttention": isAttention,
    "jokesNum": jokesNum,
    "nickname": nickname,
    "userId": userId,
  };
}
