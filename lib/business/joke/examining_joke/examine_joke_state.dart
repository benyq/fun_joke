import 'package:equatable/equatable.dart';
import 'package:fun_joke/models/joke_detail_model.dart';

class ExamineJokeState extends Equatable {
  final List<JokeDetailModel> jokes;

  const ExamineJokeState({
    this.jokes = const [],
  });

  ExamineJokeState copyWith({
    List<JokeDetailModel>? jokes,
  }) {
    return ExamineJokeState(
      jokes: jokes ?? this.jokes,
    );
  }

  @override
  List<Object?> get props => [jokes];
}