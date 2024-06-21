import 'package:equatable/equatable.dart';

class MineState extends Equatable {
  final int attentionNum;
  final int experienceNum;
  final int fansNum;
  final int likeNum;

  const MineState({
    this.attentionNum = 0,
    this.experienceNum = 0,
    this.fansNum = 0,
    this.likeNum = 0,
  });

  MineState copyWith({
    int? attentionNum,
    int? experienceNum,
    int? fansNum,
    int? likeNum,
  }) {
    return MineState(
      attentionNum: attentionNum ?? this.attentionNum,
      experienceNum: experienceNum ?? this.experienceNum,
      fansNum: fansNum ?? this.fansNum,
      likeNum: likeNum ?? this.likeNum,
    );
  }

  @override
  List<Object?> get props => [
        attentionNum,
        experienceNum,
        fansNum,
        likeNum,
      ];
}
