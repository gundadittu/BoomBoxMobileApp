import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:developer' as developer;

import '../error_manager.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthManager with ChangeNotifier {
  FirebaseAuth firebaseAuthInstance = FirebaseAuth.instance;

  String userEmailForSignInWithEmailLinkKey = 'userEmailForSignInWithEmailLink';

  bool get isLoggedIn {
    return firebaseAuthInstance.currentUser != null;
  }

  String get userUid {
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
          "https://boomboxapp.page.link/", // TODO: efactor and save in global constants
      handleCodeInApp: true,
      iOSBundleId: "com.boombox.boomboxapp", // TODO:refactor as global constants
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
      if (e.code == "invalid-email") {
        // "expected" error
        throw Exception("The email address provided is invalid.");
      } else {
        await ErrorManager.reportError(e, stackTrace);
        throw Exception(
            "There was an issue sending your signup/login link. Please quit the app and try again.");
      }
    } catch (error, stackTrace) {
      await ErrorManager.reportError(error, stackTrace);
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
      Exception reported_e = Exception(
          "${userEmailForSignInWithEmailLinkKey} is null -> Can not verify email link for authentication.");
      ErrorManager.reportError(reported_e, StackTrace.current);

      // Send back an exception with user-friendly message to UI
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
        await ErrorManager.reportError(error, stackTrace);
        throw error;
      }
    } else {
      Exception e = Exception(
          "emailAuthLink is not a valid sign in link according to FirebaseAuth - Should be checking before calling this function.");
      ErrorManager.reportError(e, StackTrace.current);
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuthInstance.signOut();
      notifyListeners();
    } catch (error, stackTrace) {
      ErrorManager.reportError(error, stackTrace);
      throw error;
    }
  }
}
