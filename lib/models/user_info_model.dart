// To parse this JSON data, do
//
//     final userInfoModel = userInfoModelFromJson(jsonString);

import 'dart:convert';

import 'package:fun_joke/models/user_info.dart';

UserInfoModel userInfoModelFromJson(String str) => UserInfoModel.fromJson(json.decode(str));

String userInfoModelToJson(UserInfoModel data) => json.encode(data.toJson());

class UserInfoModel {
  Info info;
  UserInfo user;

  UserInfoModel({
    required this.info,
    required this.user,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
    info: Info.fromJson(json["info"]),
    user: UserInfo.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "info": info.toJson(),
    "user": user.toJson(),
  };
}

class Info {
  int attentionNum;
  int experienceNum;
  int fansNum;
  int likeNum;

  Info({
    required this.attentionNum,
    required this.experienceNum,
    required this.fansNum,
    required this.likeNum,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
    attentionNum: json["attentionNum"],
    experienceNum: json["experienceNum"],
    fansNum: json["fansNum"],
    likeNum: json["likeNum"],
  );

  Map<String, dynamic> toJson() => {
    "attentionNum": attentionNum,
    "experienceNum": experienceNum,
    "fansNum": fansNum,
    "likeNum": likeNum,
  };
}

