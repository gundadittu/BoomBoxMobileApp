// import 'package:BoomBoxApp/global_navigator.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:BoomBoxApp/redux/app/app_state.dart';
import 'package:BoomBoxApp/redux/auth/auth_actions.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../error_manager.dart';
import '../../firebase_manager.dart';
// import '../../routes.dart';

ThunkAction<AppState> initAppResources() {
  return (Store<AppState> store) async {
    store.dispatch(SetAppResourceLoadingStatus(isLoading: true));

    FirebaseApp firebase = await Firebase.initializeApp();
    FirebaseManager.shared = firebase;

    // Listen for changes in User auth status and pushes appropriate screens
    store.dispatch(setAuthListener());

    // Includes logic to check if deep link is for signing in via email and tell AuthManager
    Future<bool> handleEmailAuthLink(Uri deepLink) async {
      final String deepLinkString = deepLink.toString();
      if (FirebaseManager.auth.isSignInWithEmailLink(deepLinkString)) {
        store.dispatch(verifyEmailAuthLinkAction(deepLinkString));
        return true; 
      }
      return false;
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        await handleEmailAuthLink(deepLink);
      }
    }, onError: (OnLinkErrorException e) async {
      ErrorManager.reportError(e, StackTrace.current);
    });

    // Checks if a dynamic link is what caused the app to open; will retun null otherwise
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      await handleEmailAuthLink(deepLink);
    }

    store.dispatch(SetAppResourceLoadingStatus(isLoading: false));
  };
}

class SetAppResourceLoadingStatus {
  final bool isLoading;

  SetAppResourceLoadingStatus({@required this.isLoading});
}
