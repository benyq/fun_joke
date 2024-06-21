import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserState extends Equatable {
  final String avatar;
  final String birthday;
  final String nickname;
  final String sex;
  final String signature;
  final int userId;

  const UserState({
    this.avatar = '',
    this.birthday = '',
    this.nickname = '',
    this.sex = '',
    this.signature = '',
    this.userId = -1,
  });

  bool get isLoggedIn => userId != -1 && nickname.isNotEmpty;

  UserState copyWith({
    String? avatar,
    String? birthday,
    String? nickname,
    String? sex,
    String? signature,
    int? userId,
  }) {
    return UserState(
      avatar: avatar ?? this.avatar,
      birthday: birthday ?? this.birthday,
      nickname: nickname ?? this.nickname,
      sex: sex ?? this.sex,
      signature: signature ?? this.signature,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [
    avatar,
    nickname,
    sex,
    signature,
    userId,
  ];

}