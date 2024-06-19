// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  String token;
  String type;
  UserInfo userInfo;

  LoginModel({
    required this.token,
    required this.type,
    required this.userInfo,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    token: json["token"],
    type: json["type"],
    userInfo: UserInfo.fromJson(json["userInfo"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "type": type,
    "userInfo": userInfo.toJson(),
  };
}

class UserInfo {
  String avatar;
  String birthday;
  String inviteCode;
  String invitedCode;
  String nickname;
  String sex;
  String signature;
  int userId;
  String userPhone;

  UserInfo({
    required this.avatar,
    required this.birthday,
    required this.inviteCode,
    required this.invitedCode,
    required this.nickname,
    required this.sex,
    required this.signature,
    required this.userId,
    required this.userPhone,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    avatar: json["avatar"],
    birthday: json["birthday"],
    inviteCode: json["inviteCode"],
    invitedCode: json["invitedCode"],
    nickname: json["nickname"],
    sex: json["sex"],
    signature: json["signature"],
    userId: json["userId"],
    userPhone: json["userPhone"],
  );

  Map<String, dynamic> toJson() => {
    "avatar": avatar,
    "birthday": birthday,
    "inviteCode": inviteCode,
    "invitedCode": invitedCode,
    "nickname": nickname,
    "sex": sex,
    "signature": signature,
    "userId": userId,
    "userPhone": userPhone,
  };
}
