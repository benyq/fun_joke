import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserState extends Equatable {
  String avatar;
  String birthday;
  String inviteCode;
  String invitedCode;
  String nickname;
  String sex;
  String signature;
  int userId;
  String userPhone;

  UserState({
    this.avatar = '',
    this.birthday = '',
    this.inviteCode = '',
    this.invitedCode = '',
    this.nickname = '',
    this.sex = '',
    this.signature = '',
    this.userId = -1,
    this.userPhone = '',
  });

  bool get isLoggedIn => userId != -1 && nickname.isNotEmpty;

  UserState copyWith({
    String? avatar,
    String? birthday,
    String? inviteCode,
    String? invitedCode,
    String? nickname,
    String? sex,
    String? signature,
    int? userId,
    String? userPhone,
  }) {
    return UserState(
      avatar: avatar ?? this.avatar,
      birthday: birthday ?? this.birthday,
      inviteCode: inviteCode ?? this.inviteCode,
      invitedCode: invitedCode ?? this.invitedCode,
      nickname: nickname ?? this.nickname,
      sex: sex ?? this.sex,
      signature: signature ?? this.signature,
      userId: userId ?? this.userId,
      userPhone: userPhone ?? this.userPhone,
    );
  }

  @override
  List<Object?> get props => [
    avatar,
    birthday,
    inviteCode,
    invitedCode,
    nickname,
    sex,
    signature,
    userId,
    userPhone,
  ];

}