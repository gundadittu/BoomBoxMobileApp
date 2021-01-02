import 'package:BoomBoxApp/redux/auth/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:redux/redux.dart';

import 'auth_actions.dart';

final authReducer = combineReducers<AuthState>([
  new TypedReducer<AuthState, SetAuthUser>(setAuthUser),
  new TypedReducer<AuthState, SetStatusForSendEmailWithAuthLink>(
      setStatusForSendEmailWithAuthLink),
  new TypedReducer<AuthState, SetStatusForVerifyEmailAuthLink>(
      setStatusForVerifyEmailAuthLink),
]);

AuthState setAuthUser(AuthState state, SetAuthUser action) {
  print("setAuthUser reducer");
  return state.copyWith(user: action.user);
}

AuthState setStatusForSendEmailWithAuthLink(
    AuthState state, SetStatusForSendEmailWithAuthLink action) {
  print("setStatusForSendEmailWithAuthLink reducer: "+action.status.toString());
  return state.copyWith(sendEmailWithAuthLinkStatus: action.status);
}

AuthState setStatusForVerifyEmailAuthLink(
    AuthState state, SetStatusForVerifyEmailAuthLink action) {
  print("SetStatusForVerifyEmailAuthLink reducer: "+action.status.toString());
  return state.copyWith(verifyEmailAuthLinkStatus: action.status);
}
