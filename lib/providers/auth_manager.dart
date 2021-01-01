import 'dart:async';

import 'package:flutter/material.dart';
import '../error_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_manager.dart';

class AuthManager with ChangeNotifier {
  FirebaseAuth firebaseAuthInstance = FirebaseManager.auth;
  String userEmailForSignInWithEmailLinkKey = 'userEmailForSignInWithEmailLink';
  StreamSubscription<User> _userAuthListener;

  User _user;

  User get user {
    return _user;
  }

  bool get isLoggedIn {
    return _user != null;
  }

  String get userUid {
    if (_user == null) {
      return null;
    }
    return _user.uid;
  }

  String get userEmail {
    if (_user == null) {
      return null;
    }
    return _user.email;
  }

  String get displayName {
    if (_user == null) {
      return null;
    }
    return _user.displayName;
  }

  AuthManager._internal() {
    // Sets up listener for when Firebase authenticated user state changes
    // -> Consumers will read updated isLoggedIn and userUid values
    _userAuthListener =
        firebaseAuthInstance.authStateChanges().listen((User user) {
      print(
          "in firebaseAuthInstance.authStateChanges() with user: " + user?.uid);
      _user = user;
      notifyListeners();
    });
  }

  static final AuthManager _singleton = new AuthManager._internal();

  factory AuthManager() {
    return _singleton;
  }

  @override
  void dispose() {
    if (_userAuthListener != null) {
      _userAuthListener.cancel();
      _userAuthListener = null;
    }
    super.dispose();
  }

  /* 
  Relevant docs: 
  - https://firebase.flutter.dev/docs/auth/usage#email-link-authentication 
  */
  Future<void> sendEmailWithAuthLink(String userEmail) async {
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
      // Reference doc: https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/sendSignInLinkToEmail.html
      await firebaseAuthInstance.sendSignInLinkToEmail(
          email: userEmail, actionCodeSettings: acs);

      final prefs = await SharedPreferences.getInstance();
      prefs.setString(userEmailForSignInWithEmailLinkKey, userEmail);
      notifyListeners();
    } on FirebaseAuthException catch (e, stackTrace) {
      // TODO: Throw custom error for UI
      if (e.code == "invalid-email") {
        // "expected" error
        throw Exception("The email address provided is invalid.");
      } else {
        ErrorManager.reportError(e, stackTrace);
        throw Exception(
            "There was an issue sending your signup/login link. Please quit the app and try again.");
      }
    } catch (error, stackTrace) {
      // TODO: Throw custom error for UI
      ErrorManager.reportError(error, stackTrace);
      throw Exception(
          "There was an issue sending your signup/login link. Please quit the app and try again.");
    }
  }

  /* 
  Relevant docs: 
  - https://firebase.flutter.dev/docs/auth/usage#verify-email-link-and-sign-in
  - https://pub.dev/packages/shared_preferences
  */
  Future<void> verifyEmailAuthLink(String emailAuthLink) async {
    final prefs = await SharedPreferences.getInstance();
    String userEmail = prefs.getString(userEmailForSignInWithEmailLinkKey);

    if (userEmail == null) {
      // TODO: Throw custom error for UI
      Exception reported_e = Exception(
          "${userEmailForSignInWithEmailLinkKey} is null -> Can not verify email link for authentication.");
      ErrorManager.reportError(reported_e, StackTrace.current);

      // TODO: Throw custom error for UI
      throw Exception(
          "There was an issue verifying this link. Please try again with a new link.");
    }

    if (firebaseAuthInstance.isSignInWithEmailLink(emailAuthLink)) {
      try {
        await firebaseAuthInstance.signInWithEmailLink(
            email: userEmail, emailLink: emailAuthLink);

        prefs.remove(userEmailForSignInWithEmailLinkKey);
        notifyListeners();
      } catch (error, stackTrace) {
        // TODO: Throw custom error for UI
        ErrorManager.reportError(error, stackTrace);
        throw error;
      }
    } else {
      // TODO: Throw custom error for UI
      Exception e = Exception(
          "emailAuthLink is not a valid sign in link according to FirebaseAuth - Should be checking before calling this function.");
      ErrorManager.reportError(e, StackTrace.current);
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuthInstance.signOut();
    } catch (error, stackTrace) {
      ErrorManager.reportError(error, stackTrace);
      // TODO: Throw custom error for UI
      throw error;
    }
  }
}
