import 'package:equatable/equatable.dart';
import 'package:fun_joke/models/joke_detail_model.dart';

class SearchState extends Equatable {
  final String keyword;
  final List<String> history;
  final List<String> hotKey;
  final List<JokeDetailModel> jokes;
  final bool showJokes;

  const SearchState({
    this.keyword = '',
    this.history = const [],
    this.hotKey = const [],
    this.jokes = const [],
    this.showJokes = false,
  });

  SearchState copyWith({
    String? keyword,
    List<String>? history,
    List<String>? hotKey,
    List<JokeDetailModel>? jokes,
    bool? showJokes,
  }) {
    return SearchState(
      keyword: keyword ?? this.keyword,
      history: history ?? this.history,
      hotKey: hotKey ?? this.hotKey,
      showJokes: showJokes ?? this.showJokes,
      jokes: jokes ?? this.jokes,
    );
  }

  @override
  List<Object?> get props => [keyword, history, hotKey, showJokes, jokes];
}