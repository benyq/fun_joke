import 'package:equatable/equatable.dart';

class UserCenterState extends Equatable {
  final bool showTitleBar;

  const UserCenterState({
    this.showTitleBar = false,
  });

  UserCenterState copyWith({
    bool? showTitleBar,
  }) {
    return UserCenterState(
      showTitleBar: showTitleBar ?? this.showTitleBar,
    );
  }

  @override
  List<Object?> get props => [
    showTitleBar,
  ];
}

