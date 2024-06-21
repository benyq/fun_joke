// To parse this JSON data, do
//
//     final jokeCommentModel = jokeCommentModelFromJson(jsonString);

import 'dart:convert';

JokeCommentModel jokeCommentModelFromJson(String str) => JokeCommentModel.fromJson(json.decode(str));

String jokeCommentModelToJson(JokeCommentModel data) => json.encode(data.toJson());

class JokeCommentModel {
  List<Comment> comments;
  int count;

  JokeCommentModel({
    required this.comments,
    required this.count,
  });

  factory JokeCommentModel.fromJson(Map<String, dynamic> json) => JokeCommentModel(
    comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
    "count": count,
  };
}

class Comment {
  int commentId;
  CommentUser commentUser;
  String content;
  bool isLike;
  List<ItemCommentList>? itemCommentList;
  int itemCommentNum;
  int jokeId;
  int jokeOwnerUserId;
  int likeNum;
  String timeStr;

  Comment({
    required this.commentId,
    required this.commentUser,
    required this.content,
    required this.isLike,
    this.itemCommentList,
    required this.itemCommentNum,
    required this.jokeId,
    required this.jokeOwnerUserId,
    required this.likeNum,
    required this.timeStr,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    commentId: json["commentId"],
    commentUser: CommentUser.fromJson(json["commentUser"]),
    content: json["content"],
    isLike: json["isLike"],
    itemCommentList: json["itemCommentList"] == null ? [] : List<ItemCommentList>.from(json["itemCommentList"]!.map((x) => ItemCommentList.fromJson(x))),
    itemCommentNum: json["itemCommentNum"],
    jokeId: json["jokeId"],
    jokeOwnerUserId: json["jokeOwnerUserId"],
    likeNum: json["likeNum"],
    timeStr: json["timeStr"],
  );

  Map<String, dynamic> toJson() => {
    "commentId": commentId,
    "commentUser": commentUser.toJson(),
    "content": content,
    "isLike": isLike,
    "itemCommentList": itemCommentList == null ? [] : List<dynamic>.from(itemCommentList!.map((x) => x.toJson())),
    "itemCommentNum": itemCommentNum,
    "jokeId": jokeId,
    "jokeOwnerUserId": jokeOwnerUserId,
    "likeNum": likeNum,
    "timeStr": timeStr,
  };
}

class CommentUser {
  String nickname;
  String userAvatar;
  int userId;

  CommentUser({
    required this.nickname,
    required this.userAvatar,
    required this.userId,
  });

  factory CommentUser.fromJson(Map<String, dynamic> json) => CommentUser(
    nickname: json["nickname"],
    userAvatar: json["userAvatar"],
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "nickname": nickname,
    "userAvatar": userAvatar,
    "userId": userId,
  };
}

class ItemCommentList {
  int commentItemId;
  int commentParentId;
  CommentUser commentUser;
  String commentedNickname;
  int commentedUserId;
  String content;
  bool isReplyChild;
  int jokeId;
  String timeStr;

  ItemCommentList({
    required this.commentItemId,
    required this.commentParentId,
    required this.commentUser,
    required this.commentedNickname,
    required this.commentedUserId,
    required this.content,
    required this.isReplyChild,
    required this.jokeId,
    required this.timeStr,
  });

  factory ItemCommentList.fromJson(Map<String, dynamic> json) => ItemCommentList(
    commentItemId: json["commentItemId"],
    commentParentId: json["commentParentId"],
    commentUser: CommentUser.fromJson(json["commentUser"]),
    commentedNickname: json["commentedNickname"],
    commentedUserId: json["commentedUserId"],
    content: json["content"],
    isReplyChild: json["isReplyChild"],
    jokeId: json["jokeId"],
    timeStr: json["timeStr"],
  );

  Map<String, dynamic> toJson() => {
    "commentItemId": commentItemId,
    "commentParentId": commentParentId,
    "commentUser": commentUser.toJson(),
    "commentedNickname": commentedNickname,
    "commentedUserId": commentedUserId,
    "content": content,
    "isReplyChild": isReplyChild,
    "jokeId": jokeId,
    "timeStr": timeStr,
  };
}
