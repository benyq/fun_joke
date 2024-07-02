import 'package:equatable/equatable.dart';

class UserDetailState extends Equatable {
  final bool showTitleBar;

  const UserDetailState({
    this.showTitleBar = false,
  });

  UserDetailState copyWith({
    bool? showTitleBar,
  }) {
    return UserDetailState(
      showTitleBar: showTitleBar ?? this.showTitleBar,
    );
  }

  @override
  List<Object?> get props => [
    showTitleBar,
  ];
}

