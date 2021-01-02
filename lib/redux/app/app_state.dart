import 'package:BoomBoxApp/redux/appResources/app_resources_state.dart';
import 'package:BoomBoxApp/redux/streaming_auth/streaming_auth_state.dart';
import 'package:flutter/material.dart';

import '../auth/auth_state.dart';

@immutable
class AppState {
  final AppResourcesState appResourcesState;
  final AuthState authState;
  final StreamingAuthState streamingAuthState;

  AppState({
    @required this.appResourcesState,
    @required this.authState,
    @required this.streamingAuthState,
  });

  factory AppState.initial() {
    return AppState(
      appResourcesState: AppResourcesState.initial(),
      authState: AuthState.initial(),
      streamingAuthState: StreamingAuthState.initial(),
    );
  }

  AppState copyWith(
      {AppResourcesState appResourcesState,
      AuthState authState,
      StreamingAuthState streamingAuthState}) {
    return AppState(
      appResourcesState: appResourcesState ?? this.appResourcesState,
      authState: authState ?? this.authState,
      streamingAuthState: streamingAuthState ?? this.streamingAuthState,
    );
  }
}
