import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:redux_thunk/redux_thunk.dart';
// import 'package:redux/redux.dart';

enum SendEmailWithAuthLinkStatus {
  loading,
  success,
  completed, 
  failureUnknown,
  failureInvalidEmail,
}
enum VerifyEmailAuthLinkStatus {
  loading,
  success,
  failureUnknown,
  failureInvalidExpiredLink,
  failureUserDisabled
}

@immutable
class AuthState {
  final User user;
  final SendEmailWithAuthLinkStatus sendEmailWithAuthLinkStatus;
  final VerifyEmailAuthLinkStatus verifyEmailAuthLinkStatus;

  AuthState({
    @required this.user,
    @required this.sendEmailWithAuthLinkStatus,
    @required this.verifyEmailAuthLinkStatus,
  });

  factory AuthState.initial() {
    return AuthState(
      user: null,
      sendEmailWithAuthLinkStatus: null,
      verifyEmailAuthLinkStatus: null,
    );
  }

  AuthState copyWith({
    User user,
    SendEmailWithAuthLinkStatus sendEmailWithAuthLinkStatus,
    VerifyEmailAuthLinkStatus verifyEmailAuthLinkStatus,
  }) {
    return AuthState(
      user: user ?? this.user,
      sendEmailWithAuthLinkStatus:
          sendEmailWithAuthLinkStatus ?? this.sendEmailWithAuthLinkStatus,
      verifyEmailAuthLinkStatus:
          verifyEmailAuthLinkStatus ?? this.verifyEmailAuthLinkStatus,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AuthState &&
            user == other.user &&
            sendEmailWithAuthLinkStatus == other.sendEmailWithAuthLinkStatus &&
            verifyEmailAuthLinkStatus == other.verifyEmailAuthLinkStatus);
  }
}
