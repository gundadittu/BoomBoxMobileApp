// Flutter + Dart dependencies
import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';

// External dependencies
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// Providers

// Screens
import 'screens/auth_screen.dart';
import 'screens/main_bottom_nav_bar_screen.dart';
// Internal Helpers
import './error_manager.dart';

// Note: Ignore the below error when executing "flutter run" for Android. Not fatal. Will be fixed in future Android release.
// - W/ConnectionTracker(18335): Exception thrown while unbinding
// - W/ConnectionTracker(18335): java.lang.IllegalArgumentException: Service not registered: lu@7e72165
// - ..........
// Refer to the below links for more info:
// https://github.com/firebase/firebase-android-sdk/issues/2244
// https://stackoverflow.com/questions/63492211/no-firebase-app-default-has-been-created-call-firebase-initializeapp-in

Future<void> main() async {
  //  WidgetsFlutterBinding.ensureInitialized(); added due to address the issue discussed here:
  // - https://stackoverflow.com/questions/57689492/flutter-unhandled-exception-servicesbinding-defaultbinarymessenger-was-accesse
  WidgetsFlutterBinding.ensureInitialized();
  await SentryFlutter.init(
    (options) => options.dsn =
        'https://55e8c725858d460588bc683e69ebb554@o493644.ingest.sentry.io/5563418', // TODO: refactor to store dsn in config file
    appRunner: () => runApp(MyApp()),
  );
}

class MyApp extends StatelessWidget {
  /* 
  Relevant docs: 
  - FlutterFire: https://firebase.flutter.dev/docs/overview
  - How to setup
  */
  FutureBuilder _createFirebaseFutureBuilder() {
    Future<FirebaseApp> _firebaseInitialization() async {
      try {
        FirebaseApp firebase = await Firebase.initializeApp();
        return firebase;
      } catch (error, stackTrace) {
        ErrorManager.reportError(error, stackTrace);
        throw error;
      }
    }

    return FutureBuilder(
      // Initialize FlutterFire:
      future: _firebaseInitialization(),
      builder: (context, snapshot) {
        // Firebase SDK initialization failed
        if (snapshot.hasError) {
          return Text("Something went wrong"); // TODO: Create proper widget for this
        }

        // Firebase SDK initialization success
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => AuthManager(),
              ),
              // ChangeNotifierProxyProvider<AuthManager, Products>(
              //   create: null,
              //   update: (ctx, auth, previousProducts) => Products(
              //     auth.token,
              //     auth.userId,
              //     previousProducts == null ? [] : previousProducts.items,
              //   ),
              // ),
              // ChangeNotifierProvider(
              //   create: (_) => Cart(),
              // ),
              // ChangeNotifierProxyProvider<Auth, Orders>(
              //   create: null,
              //   update: (ctx, auth, previousOrders) => Orders(
              //     auth.token,
              //     auth.userId,
              //     previousOrders == null ? [] : previousOrders.orders,
              //   ),
              // ),
            ],
            child: HomePage(),
          );
        }

        // Firebase SDK initialization in progress
        return Text("Loading"); // TODO: Replace this with proper page
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'BoomBox', // TODO: refactor to global config file
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.yellowAccent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // Initializes Firebase SDK and UI
        home: _createFirebaseFutureBuilder(),
        navigatorObservers: [
          SentryNavigatorObserver(),
        ],
        routes: {
          AuthScreen.routeName: (_) => AuthScreen(),
        });
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    await Provider.of<AuthManager>(context, listen: false).signOut(); // - for dev purposes
    
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
      ErrorManager.showErrorDialog(context, "There was an issue opening this deep link.");
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
