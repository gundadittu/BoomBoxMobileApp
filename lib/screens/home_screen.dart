import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'main_bottom_nav_bar_screen.dart';
import 'package:flutter/material.dart';
import '../providers/auth_manager.dart';
import '../error_manager.dart';
import 'auth_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    this.initDynamicLinks();
  }

  /*
  Relevant Docs: 
  - https://pub.dev/packages/firebase_dynamic_links 
  - https://pub.dev/documentation/firebase_dynamic_links/latest/firebase_dynamic_links/firebase_dynamic_links-library.html
  */
  void initDynamicLinks() async {
    await Provider.of<AuthManager>(context, listen: false)
        .signOut(); // - for dev purposes

    // Includes logic to check if deep link is for signing in via email and tell AuthManager
    Future<bool> handleEmailAuthLink(Uri deepLink) async {
      final String deepLinkString = deepLink.toString();
      if (FirebaseAuth.instance.isSignInWithEmailLink(deepLinkString)) {
        try {
          await Provider.of<AuthManager>(context, listen: false)
              .verifyEmailAuthLink(deepLinkString);
          return true;
        } catch (e) {
          ErrorManager.showErrorDialog(context, e.toString());
        }
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
      ErrorManager.showErrorDialog(
          context, "There was an issue opening this deep link.");
    });

    // Checks if a dynamic link is what caused the app to open; will retun null otherwise
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      await handleEmailAuthLink(deepLink);
    }
  }

  /* 
  Related docs
  - Provider package docs: https://pub.dev/packages/provider
  */
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthManager>(
      builder: (ctx, authManager, _) {
        return authManager.isLoggedIn == true
            ? MainBottomNavBar()
            : AuthScreen();
      },
    );
  }
}
