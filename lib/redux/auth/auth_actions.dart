import 'package:BoomBoxApp/global_navigator.dart';
import 'package:BoomBoxApp/redux/app/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';

import '../../firebase_manager.dart';
import '../../routes.dart';
import '../../error_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_state.dart';

String userEmailForSignInWithEmailLinkKey = 'userEmailForSignInWithEmailLink';

ThunkAction<AppState> setAuthListener() {
  return (Store<AppState> store) async {
    void handleAuthChange(User user) {
      store.dispatch(SetAuthUser(user: user));
      if (user == null) {
        GlobalNavigator.key.currentState.pushNamedAndRemoveUntil(
            Routes.signInScreen, (Route<dynamic> route) => false);
      } else {
        GlobalNavigator.key.currentState
            .pushReplacementNamed(Routes.mainBottomNavBarScreen);
      }
    }

    handleAuthChange(FirebaseManager.auth.currentUser);

    // Adds listener to handle future auth changes
    FirebaseManager.auth.authStateChanges().listen((User user) {
      handleAuthChange(user);
    });
  };
}

ThunkAction<AppState> sendEmailWithAuthLinkAction(String userEmail) {
  return (Store<AppState> store) async {
    var acs = ActionCodeSettings(
      url:
          "https://boomboxapp.page.link/", // TODO: efactor and save in global constants
      handleCodeInApp: true,
      iOSBundleId:
          "com.boombox.boomboxapp", // TODO:refactor as global constants
      androidPackageName:
          "com.boombox.boomboxapp", // TODO:refactor as global constants
      androidInstallApp: true,
      androidMinimumVersion: "12",
      dynamicLinkDomain: "boomboxapp.page.link",
    );

    try {
      store.dispatch(SetStatusForSendEmailWithAuthLink(
          status: SendEmailWithAuthLinkStatus.loading));

      // Reference doc: https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/sendSignInLinkToEmail.html
      await FirebaseManager.auth
          .sendSignInLinkToEmail(email: userEmail, actionCodeSettings: acs);

      final prefs = await SharedPreferences.getInstance();
      prefs.setString(userEmailForSignInWithEmailLinkKey, userEmail);

      store.dispatch(SetStatusForSendEmailWithAuthLink(
          status: SendEmailWithAuthLinkStatus.success));
    } on FirebaseAuthException catch (e, stackTrace) {
      // TODO: Throw custom error for UI
      if (e.code == "invalid-email") {
        store.dispatch(SetStatusForSendEmailWithAuthLink(
            status: SendEmailWithAuthLinkStatus.failureInvalidEmail));
      } else {
        ErrorManager.reportError(e, stackTrace);

        store.dispatch(SetStatusForSendEmailWithAuthLink(
            status: SendEmailWithAuthLinkStatus.failureUnknown));
      }
    } catch (error, stackTrace) {
      ErrorManager.reportError(error, stackTrace);
      store.dispatch(SetStatusForSendEmailWithAuthLink(
          status: SendEmailWithAuthLinkStatus.failureUnknown));
    }
  };
}

ThunkAction<AppState> verifyEmailAuthLinkAction(String emailAuthLink) {
  return (Store<AppState> store) async {

    // Ensures UI does not not show any errors/messages related to sending email auth link anymore
    store.dispatch(SetStatusForSendEmailWithAuthLink(
        status: SendEmailWithAuthLinkStatus.completed));

    store.dispatch(SetStatusForVerifyEmailAuthLink(
        status: VerifyEmailAuthLinkStatus.loading));

    final prefs = await SharedPreferences.getInstance();
    String userEmail = prefs.getString(userEmailForSignInWithEmailLinkKey);
    if (userEmail == null) {
      Exception e = Exception(
          "${userEmailForSignInWithEmailLinkKey} is null -> Can not verify email link for authentication.");
      ErrorManager.reportError(e, StackTrace.current);

      store.dispatch(SetStatusForVerifyEmailAuthLink(
          status: VerifyEmailAuthLinkStatus.failureUnknown));
      return;
    }

    if (FirebaseManager.auth.isSignInWithEmailLink(emailAuthLink)) {
      try {
        // https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithEmailLink.html
        await FirebaseManager.auth
            .signInWithEmailLink(email: userEmail, emailLink: emailAuthLink);

        prefs.remove(userEmailForSignInWithEmailLinkKey);

        store.dispatch(SetStatusForVerifyEmailAuthLink(
            status: VerifyEmailAuthLinkStatus.success));
      } on FirebaseAuthException catch (e) {
        print(e.code);
        if (e.code == "invalid-action-code") {
          store.dispatch(SetStatusForVerifyEmailAuthLink(
              status: VerifyEmailAuthLinkStatus.failureInvalidExpiredLink));
        } else if (e.code == "user-disabled") {
          store.dispatch(SetStatusForVerifyEmailAuthLink(
              status: VerifyEmailAuthLinkStatus.failureUserDisabled));
        } else {
          store.dispatch(SetStatusForVerifyEmailAuthLink(
              status: VerifyEmailAuthLinkStatus.failureUnknown));
        }
      } catch (error, stackTrace) {
        ErrorManager.reportError(error, stackTrace);
        store.dispatch(SetStatusForVerifyEmailAuthLink(
            status: VerifyEmailAuthLinkStatus.failureUnknown));
      }
    }
  };
}

ThunkAction<AppState> SignOutUserAction() {
  return (Store<AppState> store) async {
    await FirebaseManager.auth.signOut();
    // TODO: handle errors thrown from here??
    store.dispatch(SetAuthUser(user: null));

    // TODO: dispatch action to clear entire state;
  };
}

class SetAuthUser {
  final User user;
  SetAuthUser({@required this.user});
}

class SetStatusForSendEmailWithAuthLink {
  final SendEmailWithAuthLinkStatus status;
  SetStatusForSendEmailWithAuthLink({@required this.status});
}

class SetStatusForVerifyEmailAuthLink {
  final VerifyEmailAuthLinkStatus status;
  SetStatusForVerifyEmailAuthLink({@required this.status});
}
