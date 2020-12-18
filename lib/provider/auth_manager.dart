import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:http/http.dart' as http;

class AuthManager with ChangeNotifier {
  FirebaseAuth firebaseAuthInstance = FirebaseAuth.instance;

  String userEmailForSignInWithEmailLinkKey = 'userEmailForSignInWithEmailLink';

  bool get isLoggedIn {
    return firebaseAuthInstance.currentUser != null;
  }

  String get userId {
    return firebaseAuthInstance.currentUser != null
        ? firebaseAuthInstance.currentUser.uid
        : null;
  }

  /* 
  Relevant docs: 
  - https://firebase.flutter.dev/docs/auth/usage#email-link-authentication 
  */
  Future<void> sendEmailWithAuthLink(String userEmail) async {
    var acs = ActionCodeSettings(
      url:
          "https://www.example.com/finishSignUp?cartId=1234", // NEED TO REPLACE THIS WITH PROPER URL to page with user instructions (download app and then click link again)
      handleCodeInApp: true,
      iOSBundleId: "com.boombox.boomboxapp", // refactor as global constants
      androidPackageName: "com.boombox.boomboxapp", // refactor as global constants
      androidInstallApp: true,
      androidMinimumVersion: "12",
    );

    try {
      await firebaseAuthInstance.sendSignInLinkToEmail(
          email: userEmail, actionCodeSettings: acs);

      final prefs = await SharedPreferences.getInstance();
      prefs.setString(userEmailForSignInWithEmailLinkKey, userEmail);
    } catch (error) {
      throw error; // refactor to manage error and throw errors that UI can read
    }
  }

  /* 
  Relevant docs: 
  - https://firebase.flutter.dev/docs/auth/usage#verify-email-link-and-sign-in
  */
  Future<void> verifyEmailAuthLink(String emailAuthLink) async {
    final prefs = await SharedPreferences.getInstance();
    String userEmail = prefs.getString(userEmailForSignInWithEmailLinkKey);

    // if (userEmail == null) {
    //   // throw an error that can be read by UI
    // }

    if (firebaseAuthInstance.isSignInWithEmailLink(emailAuthLink)) {
      try {
        final value = await firebaseAuthInstance.signInWithEmailLink(
            email: userEmail, emailLink: emailAuthLink);

        prefs.remove(userEmailForSignInWithEmailLinkKey);
        // You can access the new user via value.user
        // value.additionalUserInfo.profile == null
        // You can check if the user is new or existing:
        // value.additionalUserInfo.isNewUser;
        // var user = value.user;
        print('Successfully signed in with email link!');

        notifyListeners();
      } catch (error) {
        throw error; //refactor to throw user friendly error
      }
    } else {
      throw Error(); // refactor to UI friendly error
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuthInstance.signOut();
      notifyListeners();
    } catch (error) {
      throw error; // refactor to throw error that UI can read
    }
  }
}
