import 'package:BoomBoxApp/redux/app/app_state.dart';
import 'package:BoomBoxApp/redux/auth/auth_state.dart';
import 'package:BoomBoxApp/redux/auth/auth_actions.dart';

import 'package:redux/redux.dart';

class AuthScreenModel {
  final SendEmailWithAuthLinkStatus sendEmailWithAuthLinkStatus;
  final Function(String) sendEmailWithAuthLink; 
  final VerifyEmailAuthLinkStatus verifyEmailAuthLinkStatus; 

  AuthScreenModel({
    this.sendEmailWithAuthLinkStatus, 
    this.sendEmailWithAuthLink, 
    this.verifyEmailAuthLinkStatus,
  });

  static AuthScreenModel fromStore(Store<AppState> store) {
    return AuthScreenModel(
      sendEmailWithAuthLinkStatus: store.state.authState.sendEmailWithAuthLinkStatus,
      sendEmailWithAuthLink: (String userEmail) {
        store.dispatch(sendEmailWithAuthLinkAction(userEmail));
      },
      verifyEmailAuthLinkStatus: store.state.authState.verifyEmailAuthLinkStatus, 
    );
  }
}