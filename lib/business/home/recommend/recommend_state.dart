import 'package:equatable/equatable.dart';
import 'package:fun_joke/models/joke_detail_model.dart';

class RecommendState extends Equatable{
  List<JokeDetailModel> jokeList;
  int size;

  RecommendState(this.jokeList, this.size);

  RecommendState copyWith({
    List<JokeDetailModel>? jokeList,
    int? size,
  }) {
    return RecommendState(
      jokeList ?? this.jokeList,
      size ?? this.size,);
    }

  @override
  List<Object?> get props => [jokeList, size];
}