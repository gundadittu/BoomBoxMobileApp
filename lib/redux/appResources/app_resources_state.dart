import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:redux_thunk/redux_thunk.dart';
// import 'package:redux/redux.dart';

@immutable
class AppResourcesState {
  final bool isLoading;

  AppResourcesState({@required this.isLoading});

  factory AppResourcesState.initial() {
    return AppResourcesState(
      isLoading: false,
    );
  }

  AppResourcesState copyWith({
    bool isLoading,
  }) {
    return AppResourcesState(
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppResourcesState && isLoading == other.isLoading);
}
