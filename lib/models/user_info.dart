class UserInfo {
  String avatar;
  String birthday;
  String inviteCode;
  String nickname;
  String sex;
  String signature;
  int userId;
  String userPhone;

  UserInfo({
    required this.avatar,
    required this.birthday,
    required this.inviteCode,
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
    "nickname": nickname,
    "sex": sex,
    "signature": signature,
    "userId": userId,
    "userPhone": userPhone,
  };
}
