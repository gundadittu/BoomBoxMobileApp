// Flutter + Dart dependencies
import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';

// External dependencies
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// Providers
import 'providers/auth_manager.dart';
import 'providers/streaming_auth_manager.dart';
import 'package:BoomBoxApp/providers/streaming_library_manager.dart';

// Screens
import 'screens/auth_screen.dart';
import 'package:BoomBoxApp/screens/home_screen.dart';

// Internal Helpers
import './error_manager.dart';
import './firebase_manager.dart';

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
        FirebaseManager.shared = firebase;
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
        // Firebase SDK initialization success
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => AuthManager(),
              ),
              ChangeNotifierProxyProvider<AuthManager, StreamingAuthManager>(
                create: (context) => StreamingAuthManager(),
                update: (context, authManager, streamingAuthManager) {
                  streamingAuthManager.update(authManager.userUid);
                  return streamingAuthManager;
                },
              ),
              ChangeNotifierProxyProvider<StreamingAuthManager,
                      StreamingLibraryManager>(
                  create: (context) => StreamingLibraryManager(),
                  update:
                      (context, streamingAuthManager, streamingLibraryManager) {
                    streamingLibraryManager
                        .update(streamingAuthManager.streamingAccount);
                    return streamingLibraryManager;
                  }),
            ],
            child: HomeScreen(),
          );
        }

        // Firebase SDK initialization failed
        if (snapshot.hasError) {
          return Text(
              "Something went wrong"); // TODO: Create proper page for this
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
