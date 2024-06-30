import 'package:equatable/equatable.dart';
import 'package:fun_joke/models/joke_detail_model.dart';
import 'package:fun_joke/models/recommend_user_model.dart';

class FollowState extends Equatable {
  final List<RecommendUserModel> users;
  final List<JokeDetailModel> jokes;

  const FollowState({
    this.users = const [],
    this.jokes = const [],
  });

  FollowState copyWith({
    List<RecommendUserModel>? users,
    List<JokeDetailModel>? jokes,
  }) {
    return FollowState(
      users: users ?? this.users,
      jokes: jokes ?? this.jokes,
    );
  }

  @override
  List<Object?> get props =>[users, jokes];
}