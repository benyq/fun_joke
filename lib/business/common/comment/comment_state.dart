import 'package:equatable/equatable.dart';
import 'package:fun_joke/models/joke_comment_model.dart';

class CommentState extends Equatable {

  final List<Comment> commentList;
  final int commentSize;

  const CommentState(this.commentList, this.commentSize);

  CommentState copyWith({
    List<Comment>? commentList,
    int? commentSize,
  }) {
    return CommentState(
      commentList ?? this.commentList,
      commentSize ?? this.commentSize,
    );
  }

  @override
  List<Object?> get props => [commentList, commentSize];

}