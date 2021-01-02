import 'package:BoomBoxApp/models/user_streaming_account_store_item.dart';
import 'package:flutter/material.dart';

enum AuthorizeNewStreamingAccountStatus {
  loading,
  success,
  completed,
  failureUnknown,
  failureIncompatibleAccount,
  failureSubscriptionRequired,
  failureIncompatibleDevicePlatform,
  failurePermissionDeniedByUser
}

@immutable
class StreamingAuthState {
  final AuthorizeNewStreamingAccountStatus authorizeNewStreamingAccountStatus;
  final UserStreamingAccountStoreItem streamingAccount;

  StreamingAuthState(
      {@required this.authorizeNewStreamingAccountStatus,
      @required this.streamingAccount});

  factory StreamingAuthState.initial() {
    return StreamingAuthState(
      authorizeNewStreamingAccountStatus: null,
      streamingAccount: null,
    );
  }

  StreamingAuthState copyWith({
    AuthorizeNewStreamingAccountStatus authorizeNewStreamingAccountStatus,
    UserStreamingAccountStoreItem streamingAccount,
  }) {
    return StreamingAuthState(
      authorizeNewStreamingAccountStatus: authorizeNewStreamingAccountStatus ??
          this.authorizeNewStreamingAccountStatus,
      streamingAccount: streamingAccount ?? this.streamingAccount,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is StreamingAuthState &&
            streamingAccount == other.streamingAccount &&
            authorizeNewStreamingAccountStatus ==
                other.authorizeNewStreamingAccountStatus);
  }
}
